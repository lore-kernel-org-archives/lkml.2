Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1FPL2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:28:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50903 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1FPL2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:28:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: RFC: IIO: Options for 'event' userspace interface.
Date: Thu, 16 Jun 2011 13:27:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
References: <4DF9DBDE.9060907@cam.ac.uk>
In-Reply-To: <4DF9DBDE.9060907@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161327.57015.arnd@arndb.de>
X-Provags-ID: V02:K0:iOzWiWXlhDQNRBmTBlgIJyNLMQm1GbEvpca1pVoA8yT
 76djQEG5PTYXRlJ39NiHKfuXi/fKjwzmIfZ9xRWCuWvvhKS2oa
 naAAM5FNXvZZ8VLwjP47MmyPIGWDv3TBHCBCMPCXxAWugOIzEV
 IYCe2r3hTKWVJB1gXjprJjHsllrQ2x3tsy3l5VooUJwpjKS7tn
 7nSsg4i7JuTuTxfnwHfbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011, Jonathan Cameron wrote:

> Obvious options (or ones that have been suggested)
> 
> * Use out of band signalling on the main data chrdev.  Basically poll with the more
> unusual types, POLLPRI perhaps.  Then use an IOCTL to read what actually happened.
> (grep suggests it gets used for something similar in v4l2-subdev.c) (suggested by
> Arnd Bergmann).

The important change that I'd really like to see is the use of poll() to wait
for events. Using POLLPRI/ioctl to get IIO events is particularly nice IMHO because
it lets you represent every IIO device as a single chardev. However, using a
separate file descriptor (chardev or something else) with POLLIN/read is also
totally fine. An interesting twist would be an ioctl on the chardev that returns
a new file descriptor (from anon_inode_getfd()) on which you then do poll/read
to get the events, instead of having separate character devices.

> * Similar system to evdev in input.  This carries a few extra fields, but that probably
> doesn't matter. We need to know when an event happened reasonably soon after, but not
> asap.

I'd suggest that if you do something similar to evdev, then make it use the *exact*
same user interface with the ioctl command definitions used in evdev.

One disadvantage that I see here is that the evdev interface has a number of flaws
regarding is 32 bit compatibility code that you cannot solve in a backwards-compatible
way. Another is its use of variable-length ioctl arguments, which I would recommend
avoiding in general. Also, Adding evdev extensions for iio into linux/input.h might
be seen as a layer violation by interface purists.

> * Separate evdev from input and share it across both subsystems.  This seemed like
> a good idea, but evdev is pretty tightly tied to the input core. Note we would never
> be sharing input's event codes.  They are too restrictive (with good reason seeing
> as they are for 'input' devices!)  Basically I expect this could be done, but would
> need to be done very carefully so as to not have any impact on input users.  Perhaps
> it is the right answer, but its not trivial. (I've cc'd linux-input to get comments
> on this option!)

This could be a second step if you decide to use the evdev interface. You start
by duplicating evdev functionality within IIO at first, and then at a convenient
time you put the common parts into a library module that is used by both input
and iio for evdev.

> * Some other event passing methods that I've either forgotten or never knew about
> in the first place.

For completeness, the list should probably include generic netlink sockets
(net/netlink/genetlink.c). Some people hate them, others love them. They certainly
fit the requirements and have some other nice properties, so I'd suggest you read
some documentation and examples and build your own opinion.

> * Leave things be. Its small and simple. Perhaps it's best we don't try to be clever
> at all.

I would really hope for the interface to change to allow poll. The least invasive
option would be to simply add a poll() function to iio_event_chrdev_fileops, which
allows you to wait for multiple events in a single thread. Anything beyond that
is an option IMHO.

	Arnd
