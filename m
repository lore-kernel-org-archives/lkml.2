Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0HaTwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:52:24 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:24098 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab0HaTwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:52:22 -0400
X-SpamScore: -36
X-BigFish: VPS-36(zzbb2dK1803M1432N98dN9371Pzz1202hzz8275dh5eeePz2fh2a8h)
Message-ID: <4C7D5D60.1070203@am.sony.com>
Date: Tue, 31 Aug 2010 12:52:00 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Murray <amurray@mpcdata.com>
CC: "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux kernel <linux-kernel@vger.kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [RFC] Kernel 'boot cache' to reduce boot time
References: <AANLkTimJkPD=shB9oi3ASocaLEpG=C7oDJMbq8BEy2Fe@mail.gmail.com>
In-Reply-To: <AANLkTimJkPD=shB9oi3ASocaLEpG=C7oDJMbq8BEy2Fe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 12:13 PM, Andrew Murray wrote:
> I have a suggestion for a kernel framework which aims to reduce boot
> time in embedded devices and would be interested in hearing your
> feedback.
> 
> A large portion of kernel boot time is spent in driver probe functions
> often waiting for hardware for example calculating LPJ values or
> trying to determine what type of camera is connected (PAL/NTSC) etc.
> However for most embedded devices the hardware remains constant and
> these probes always determine the same information. Therefore boot
> time can be decreased by removing some of this probe code and
> replacing it with known values.
> 
> To some extent some of these optimisations have already been done
> through a variety of methods - for example the LPJ calculation can be
> bypassed with the lpj= parameter and some drivers have their own
> methods. My solution aims to generalise these solutions...
> 
> The solution is to provide a very simple framework which will allow
> drivers to identify and record such values (LPJ, camera type, decoder
> chip version) during boot. Once booted the user can obtain a
> collection of these values and pass them back to the kernel on
> subsequent boots. During subsequent boots - drivers upon realising
> these values have already been provided can bypass some of their probe
> code and thus reducing boot time. Taking advantage of this framework
> would be very trivial for drivers.
> 
> I wanted to see your views on the overall solution prior to
> considering how it could be implemented.

For my part, I think this sounds like a great idea.  I have
considered such a mechanism in the past, but never gotten around
to actually designing a solution.

Here are some random thoughts on this idea:

My experience is that we've made good progress on boot time
probing, for fixed hardware.  The big problems in the kernel
boot time appear to be with busses that require discovery of
devices, with long timeouts specified in the bus standard and
arbitrary bus connection architecture (I'm thinking of USB,
but other busses have similar problems).  For many embedded
devices, scanning these types of pluggable busses aren't
required for what I call "first product use", but they can be
scanned and populated later.

Note that the asynchronous function call stuff by Arjan
van de Ven addresses some of this boot time probing
delay problem.

Having said that, I don't think that probing of static
hardware is a solved problem, by any means.

For the boot cache data, you are going to need to figure
out how to make the data persistent.  Doing something
in a regular fashion (rather than ad-hoc via command line
options) should help with this.

To some degree this might end up looking very similar
to the "resume" path in the driver, where a particular
device state is entered into from cold start.

Sony has been doing something related to this called
"Snapshot boot" for some time now, which is kind of an
optimized unhibernate operation, with some hardware bringup
done by firmware, and some bringup done using the normal driver
resume operation.  This work was presented at OLS
several years ago, but we haven't pushed it much since
then.  (But we're using it in product)
See http://elinux.org/upload/3/37/Snapshot-boot-final.pdf

Sorry for rambling.  Anyway - I'm all for the boot cache idea.
But acceptability would, of course, be dependent on the
details of the implementation.

The best thing to get started, IMHO, would be to identify
a few drivers which have long probe times, and see
how they could reduce these with the proposed boot cache.
If you find that each new device adds some new wrinkle
in the cache requirements, that would be a bad sign.  But
if different drivers, especially drivers in different functional
areas, are found to be able to use a consistent API, then
this could be a nice feature.

BTW - I could see this tying into the flattened device
tree work by Grant Likely.
 -- Tim

P.S.  Also, I would recommend cross-posting to LKML
to get wider visibility of your proposal.  I'm doing
so in this response - I hope that's OK.

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Network Entertainment
=============================

