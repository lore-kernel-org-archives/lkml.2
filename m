Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074Ab2EWWAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 18:00:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:47027 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2EWWAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 18:00:35 -0400
Date: Thu, 24 May 2012 00:00:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
In-Reply-To: <4FBD39BE.8040101@zytor.com>
Message-ID: <alpine.LFD.2.02.1205232210440.3231@ionos>
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <4FBB7185.6040105@redhat.com> <alpine.LFD.2.02.1205221919260.3231@ionos> <4FBCFDD1.5050405@redhat.com> <alpine.LFD.2.02.1205232037220.3231@ionos>
 <4FBD39BE.8040101@zytor.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1905599269-1337810431=:3231"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1905599269-1337810431=:3231
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 23 May 2012, H. Peter Anvin wrote:

> On 05/23/2012 11:37 AM, Thomas Gleixner wrote:
> >>
> >> That works, but replaces one problem with another: now we have two
> >> sources for the same data, and need to juggle between them depending on
> >> register number (either synchronizing in both directions, or special
> >> casing); so you're simplifying one thing at the expense of the other.
> >> If the microcode starts accessing more registers, then having two
> >> layouts becomes even uglier.
> > 
> > Fair enough :)
> 
> Yes, the µcode accessing this data structure directly probably falls
> under the category of a legitimate need to stick to the hardware format.

Thought more about that.

We have a clear distinction between HW accessed data and software
accessed data.

If I look at TPR then it is special cased already and it does:

   case APIC_TASKPRI:
                report_tpr_access(apic, false|true);
                /* fall thru */

And the fall through is using the general accessor for all not special
cased registers.

So all you have to do is 

   case APIC_TASKPRI:
                report_tpr_access(apic, false|true);
+		return access_mapped_reg(...);

Instead of the fall through.

So there is no synchronizing back and forth problem simply because you
already have a special case for that register.

I know you'll argue that the tpr reporting is a special hack for
windows guests, at least that's what the changelog tells.

But even if we have a few more registers accessed by hardware and if
they do not require a special casing, I really doubt that the overhead
of special casing those few regs will be worse than not having the
obvious optimization in place.

And looking deeper it's a total non issue. The apic mapping is 4k. The
register stride is strictly 0x10. That makes a total of 256 possible
registers.

So now you have two possibilites:

1) Create a 256 bit == 64byte bitfield to select the one or the other
   representation.

   The overhead of checking the bit is not going to be observable.

2) Create a 256 function pointer array == 2k resp. 1k (64 / 32bit)

   That's not a lot of memory even if you have to maintain two
   separate variants for read and write, but it allows you to get rid
   of the already horribly compiled switch case in apic_read/write and
   you'll get the optional stuff like report_tpr_access() w/o extra
   conditionals just for free.

   An extra goodie is that you can catch any access to a non existing
   register which you now just silently ignore.  And that allows you
   to react on any future hardware oddities without adding a single
   runtime conditional.

   This is stricly x86 and x86 is way better at dealing with indirect
   calls than with the mess gcc creates compiling those switch case
   constructs.

   So I'd go for that and rather spend the memory and the time in
   setting up the function pointers on init/ioctl than dealing with
   the inconsistency of HW/SW representation with magic hacks.

Thanks,

	tglx
--8323328-1905599269-1337810431=:3231--
