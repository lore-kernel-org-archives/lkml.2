Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab1CWUuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:50:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933323Ab1CWUuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:50:51 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: Any USB gadget AIO interface users?
References: <20110322171251.GA4455@xanatos>
	<x49vcz9c3dr.fsf@segfault.boston.devel.redhat.com>
	<20110323190205.GC5947@xanatos>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 23 Mar 2011 16:50:40 -0400
In-Reply-To: <20110323190205.GC5947@xanatos> (Sarah Sharp's message of "Wed,
	23 Mar 2011 12:02:05 -0700")
Message-ID: <x49oc51o927.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah Sharp <sarah.a.sharp@linux.intel.com> writes:

> On Wed, Mar 23, 2011 at 10:34:08AM -0400, Jeff Moyer wrote:
>> Sarah Sharp <sarah.a.sharp@linux.intel.com> writes:
>> 
>> > Has anyone successfully used the asynchronous I/O gadgetfs interface
>> > before?  Specifically, has anyone used it for high-bandwidth isochronous
>> > traffic?
>> >
>> > I ask because I remember discovering about four years ago that there
>> > were several brain-twisty bugs in the in-kernel asynchronous I/O layer
>> > that gadgetfs uses.
>> 
>> Weren't they addressed?  And are you looking to use the gadgetfs aio
>> interface now, or are you looking to get rid of it?  In other words,
>> what's the real motivation behind the question?
>
> I was looking to use it.  The bug in question I remember was about
> cancellation, but I would have to dig in my mailbox from 2007 to find
> the exact issue.

Reference counting in that path is usually the tricky part to get right.
We had one person looking to make use of aio in his driver, iirc, and
that was a major concern of his, as well.  If we can get both of your
requirements together, maybe we can make progress.

> The biggest problem I remember when I was looking at using the aio core
> to replace the ioctls in the usbfs subsystem with true aio operations
> was there was an issue with operation ordering.  In the kernel to
> userspace interface for USB, we want asynchronous operations to a
> particular file to be queued to the hardware in the order they are
> submitted.  So if the userspace application submits asynchronous read A,
> then asynchronous read B, then the buffer for read B doesn't get queued
> to the USB host controller before the buffer for read A.  Otherwise you
> get transmission reordering on the bus, and USB devices aren't very
> happy.

The AIO infrastructure doesn't guarantee that.  It does the setup
required in the context of the calling process, and then queues the
operation to the underlying "device" (where device, in most cases, is a
file or a block device, which means submit_bio is called).  After that,
the AIO code has no control over ordering.  If there are specific
ordering requirements in the application, then maybe AIO isn't the right
fit.  I don't know enough about your application to say.

>> > The AIO core also seemed to be largely unmaintained.  Is this still
>> > true?
>> 
>> Surely you should at least cc the aio list when asking such a question!
>> Anyway, the aio core is maintained by several folks, but nobody is doing
>> active development in that area, to my knowledge.
>
> Sorry, I forgot the aio mailing list existed. :)  In 2007, there was
> lots of talk of using syslets or fibrils in the aio core, and Zack Brown
> had some patches for that, but it seemed like nothing really came out of
> that.  Has anything new been added to the AIO core since then?

Nothing came of it, no.  There haven't been any attempts since, either.

Cheers,
Jeff
