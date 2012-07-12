Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab2GLQsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:48:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35193 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab2GLQsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:48:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120712140552.GA13745@redhat.com>
References: <20120709180328.GA4105@redhat.com> <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
 <1341859731.801.0.camel@mop> <20120712005405.GA1613@redhat.com>
 <CAPXgP13J98an3GW1-aBOEk=5Vyr+is1DaPhz-UFWHBOJ2nHkKA@mail.gmail.com> <20120712140552.GA13745@redhat.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 12 Jul 2012 18:47:57 +0200
Message-ID: <CAPXgP134KL_hxnsH4OcwGX-mv6hfaRiH9r7Tn4a5XXYzh6EZqA@mail.gmail.com>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
To: Dave Jones <davej@redhat.com>, Kay Sievers <kay@vrfy.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 4:05 PM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Jul 12, 2012 at 03:52:17PM +0200, Kay Sievers wrote:
>  > On Thu, Jul 12, 2012 at 2:54 AM, Dave Jones <davej@redhat.com> wrote:
>  > > On Mon, Jul 09, 2012 at 08:48:51PM +0200, Kay Sievers wrote:
>  >
>  > >  > It looks fine here with the above mentioned patch:
>  > >
>  > > Now that that patch is in Linus tree, I've hit what's probably a different case.
>  > > Look at the modules list in this oops..
>  > >
>  > > [10016.460020] BUG: soft lockup - CPU#1 stuck for 22s! [trinity-child1:24295]
>  > > [10016.470008]  rose<4>[10016.470008]  ip_set_bitmap_ipmac<4>[10016.470008]
>  >
>  > > Also, I have no idea how the hell the 'Modules linked in:' line (9th line) ended up being printed /after/ the
>  > > module listing began (2nd line).

They do not belong together. The second line is just another call to
the same print_modules() done from:
    arch/x86/kernel/dumpstack_64.c :: show_regs()

While we already called print_modules() a few cycles earlier from:
   kernel/watchdog :: watchdog_timer_fn()

>  > I tried to force all sorts of racy print_modules() calls, and kept
>  > your trinity tool from git for hours, it looks all fine here:
>  >
>  > Can you easily reproduce the issue you pasted?  If, could you give me
>  > the /dev/kmsg output?
>
> I've seen it a few times, always with the soft lockup trace.
>
> You might be able to trigger it using scripts/load-all-modules.sh
> from trinity.git. (Assuming you have a lot of modules built, I'm
> still trying to track down which one seems to be responsible).

Hmm, it does not trigger your pattern. I tried adding an rmmod in that
loop, but that crashes after a few seconds. Some modules are just not
meant to be removed. :)

I forced the watchdog to trigger by setting the timeout to 1s, but all
looks still fine:

[   20.854010] BUG: soft lockup - CPU#0 stuck for 1000s! [trinity:247]
[   20.854010] Modules linked in: nfnetlink xfrm_user xfrm_algo pppoe
pppox ppp_generic slhc atm bluetooth rfkill microcode cirrus ttm
sr_mod cdrom pcspkr drm_kms_helper drm syscopyarea sysfillrect
sysimgblt floppy evdev ipv6
[   20.854010] irq event stamp: 980768
[   20.854010] hardirqs last  enabled at (980767):
[<ffffffff814a425d>] __slab_alloc.constprop.65+0x3c9/0x408
[   20.854010] hardirqs last disabled at (980768):
[<ffffffff814adfaa>] apic_timer_interrupt+0x6a/0x80
[   20.854010] softirqs last  enabled at (978462):
[<ffffffff8103db1f>] __do_softirq+0x11f/0x170
[   20.854010] softirqs last disabled at (978457):
[<ffffffff814ae82c>] call_softirq+0x1c/0x30
[   20.854010] CPU 0
[   20.854010] Modules linked in: nfnetlink xfrm_user xfrm_algo pppoe
pppox ppp_generic slhc atm bluetooth rfkill microcode cirrus ttm
sr_mod cdrom pcspkr drm_kms_helper drm syscopyarea sysfillrect
sysimgblt floppy evdev ipv6

Could it possibly be that we get some sort of corruption somewhere
else while running trinity and load modules?

Kay
