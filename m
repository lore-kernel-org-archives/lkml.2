Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab0JZBCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:02:38 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:38006 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0JZBCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:02:37 -0400
Date: Mon, 25 Oct 2010 21:02:18 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: Re: [PATCH 27/30] staging/vme: rework the bus model
Message-ID: <20101026010218.GO10869@flamenco.cs.columbia.edu>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
 <1287729412-24356-28-git-send-email-cota@braap.org>
 <20101022232707.GA1370@braap.org>
 <4CC568F6.2070207@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC568F6.2070207@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 12:24:38 +0100, Martyn Welch wrote:
> On 23/10/10 00:27, Emilio G. Cota wrote:
> >> * installing drivers even before the bridges they need are present
> >>   seems counter-intuitive and wrong.
> 
> There are plenty of instances where a driver can be loaded before the
> bus is probed or a device is even present. When the bus become
> available, the probe routine will be run.

That would be acceptable if and only if no other alternative was available.

It doesn't make any sense to constrain ourselves to installing
drivers only BEFORE loading bridge drivers.

This seems fairly obvious to me; imagine you're developing a driver. In the
current situation you can't simply do `rmmod mymod && insmod mymod' !
You'd need to remove all devices that sit on the bridge, plus the bridge
driver, and then re-install them all again. Not to mention the case where
the driver you want to reinstall controls devices across different bridges..

I really doubt anyone would defend that as a desirable feature.

> >> * a VME bus may need more than 32 devices--the relation to the 32 slots on
> >>   a VME crate is artificial and confusing:
> 
> It is certainly not artificial. The VME64 spec (as approved in 1995)
> defines a CR/CSR space. This is a special 24-bit address space, which is
> divided in to 512KB blocks - specific offsets are assigned for Vendor
> and Device IDs.
> 
> In fact, the VME64 spec also states that a rack must not have more than
> 21 slots. I'm sure there is hardware out there that doesn't fully comply
> with the VME64 bit specs (be that because they were designed before 1995
> and/or are used in some niche where adherence to the specs isn't
> important), however I feel that the limit of 32 is not artificial - as
> it is at the moment a probe routine can be written for a VME64 compliant
> card that probes through the CR/CSR space.

I meant artificial as 'false, misleading'.
http://en.wiktionary.org/wiki/artificial

I know where the number comes from. Probably 'confusing' was clearer than
'artificial'. The slot number is a physical thing. Only in some
circumstances (VME64x crate + device) we can tell on which slot a device
is sitting.
For the vast majority of devices out there, which are not VME64x-compatible,
we simply cannot know where they've been plugged. Therefore using the word
'slot' as 'device ID' is confusing, because the poor user may think that
device 'X' is on slot X.

Note that I'm not against having a 'slot' knob somewhere in case we're
dealing with VME64x hardware. However, since we cannot automatically identify
_all_ VME devices by physical slot, it is misleading to use the word
'slot' when in most cases we mean 'arbitrary device ID'.

> For drivers of non-compliant devices, this can be provided as a module
> parameter by the system integrator (I have done exactly this for an
> example driver for an ancient card I have developed to test the framework).

Let me first be clear about something: Let's not make the mistake of
considering non-VME64x as second-class citizens (e.g. "non-compliant");
they are the majority.

What you propose here makes things even worse.

First, you assume that user-space is a reliable source of information--it isn't.

Second, the kernel would just be a dumb loop-back, re-printing information
that user-space entered. This is like having a sysfs file to print
user-space's favourite colour. User-space knows it already, so what's the point?

I have worked with installations of hundreds of non-VME64x crates. The binding
between 'device physical slot' and 'device id' is done in user-space (usually,
in a database with some other information, such as VME offsets). That is a
matter of policy and thus should remain in user-space.

In conclusion, as I see it the word 'slot' should only be used when it makes
sense in the VME meaning (e.g. VME64x)--otherwise it is confusing (and artificial).

> >> 	* Some VME cards may be best treated in the kernel as several
> >> 	  independent devices, and therefore it is pointless to limit the
> >> 	  number of devices on the bus.
> 
> Write a driver for the card and layer modules above it.

This is a non-issue compared to the above, and my message is already too long.

> >> * .probe and .remove pass a pointer to a struct device representing a VME
> >>   bridge, instead of representing the device to be added/removed.
> >> 	* a bridge's module may be removed anytime and things do fall over;
> >> 	  there is no refcounting at all and thus all drivers attached to
> >> 	  the removed bus will oops.
> 
> Yes - this is an issue that does need to be dealt with.

Those were two issues. One of them is that in the current model .match and .probe
have lost their original meanings. The other is that (probably as a consequence)
removing a bridge and causing some nasty oopses is very easy.

> >> * the so-called "bind table" is tricky, unnecessary and boring code that just
> >>   duplicates what modparam's arrays do.

This is another issue, I guess you agree with me on that getting rid of
that unnecessary code is a good thing.

> I'm happy to discuss alternative approaches, however
> I don't consider a dump of 30 patches at the start of a merge window on the
> LKML mailing list without any discussion on the appropriate sub-system mailing
> list (in-fact, not even posted there) a discussion.

See Greg's email and my reply. In my initial email I didn't say anything
about the current merge window, simply because I assumed this was out
of it (hence the [-next] prefix of the whole thing). I'm just playing
by the rules here.

> In these 30 patches there are quite a few improvements that I'm happy to
> ack. Please re-post this series to the correct mailing list (as listed
> in the maintainers file), I will ack the patches that I'm happy with and
> we can discuss them there.

Yes I missed it, sorry again about that. Since you insist I'll re-post
in a minute the whole thing to both mailing lists.

		Emilio

