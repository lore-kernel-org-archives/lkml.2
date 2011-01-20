Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab1ATW6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:58:15 -0500
Received: from mailout06.t-online.de ([194.25.134.19]:60097 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab1ATW6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:58:13 -0500
Message-ID: <4D38BDF4.6040509@t-online.de>
Date: Thu, 20 Jan 2011 23:57:56 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: airlied@linux.ie, jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] 2.6.38-rc1-git1: hard lockup related to i915 / automated
 cgroup scheduling
References: <4D387109.9020207@t-online.de> <AANLkTi=GjnyE1_RosS_L_sn=QCTDSgO7v9EL+1bpJTu7@mail.gmail.com>
In-Reply-To: <AANLkTi=GjnyE1_RosS_L_sn=QCTDSgO7v9EL+1bpJTu7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: Ef1guyZL8hcYZTJq+JMQUwGGEcLURQn6B-emD2bwAdxB6xfZkGF5KH6qdt3xMSawL9
X-TOI-MSGID: 7b75f874-c5b8-4a86-a6fd-9d274ad60ca5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an additional problem: The video signal on the framebuffer
console is switched off at random(?) intervals and then switched on
again. Most of the time it's only for fractions of a second. No entries
in the logs for that.

I changed the kernel configuration to select SLUB and enabled
SLUB debugging. Result: No change, 100% reproducible lockup

Then I edited i915_gem.c the way you suggested. No lockup,
but X is unusable. Switching to framebuffer console works, switching
back to X still shows the framebuffer image ... and the X mouse cursor.
Switching back to framebuffer console works.

I verified the problem on a 2nd PC with an identical motherboard.

Let's have look at the lockup logs:

/var/log/boot.msg

<6>[    2.050143] Linux agpgart interface v0.103
<6>[    2.050244] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
<6>[    2.051099] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
<6>[    2.053815] agpgart-intel 0000:00:00.0: AGP aperture is 256M @
0xc0000000
<6>[    2.053972] [drm] Initialized drm 1.1.0 20060810
<6>[    2.054073] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
<7>[    2.054164] i915 0000:00:02.0: setting latency timer to 64
<6>[    2.766096] [drm] DAC-6: set mode 640x480 0
<6>[    3.240122] [drm] TV-12: set mode NTSC 480i 0
<3>[    3.473071] render error detected, EIR: 0x00000010
<3>[    3.473074] page table error
<3>[    3.473076]   PGTBL_ER: 0x00000010
<3>[    3.473079] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010,
masking
<3>[    3.473088] render error detected, EIR: 0x00000010
<3>[    3.473090] page table error
<3>[    3.473092]   PGTBL_ER: 0x00000010
<6>[    3.479417] [drm] TMDS-8: set mode 1280x1024 1b
<4>[    3.756503] Console: switching to colour frame buffer device 160x64
<6>[    3.762767] [drm] fb0: inteldrmfb frame buffer device
<6>[    3.762816] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0
on minor 0

/var/log/messages

an 20 23:22:29 golem kernel: [   64.838521] ------------[ cut here
]------------
Jan 20 23:22:29 golem kernel: [   64.838535] WARNING: at
drivers/gpu/drm/i915/i915_gem.c:3256 i915_gem_object_pin+0x4f/0x16c()
Jan 20 23:22:29 golem kernel: [   64.838538] Hardware name:
Jan 20 23:22:29 golem kernel: [   64.838540] Modules linked in: pppoe
pppox ip6t_LOG ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp ipt_LOG
xt_limit iptable_nat nf_nat af_packet ppp_generic slhc ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT
xt_state iptable_raw iptable_filter ip6table_mangle
nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
ip_tables ip6table_filter ip6_tables x_tables ipv6
Jan 20 23:22:29 golem kernel: [   64.838576] Pid: 2031, comm: Xorg Not
tainted 2.6.38-rc1-git1-kape #27
Jan 20 23:22:29 golem kernel: [   64.838578] Call Trace:
Jan 20 23:22:29 golem kernel: [   64.838586]  [<c0124dee>] ?
warn_slowpath_common+0x65/0x7a
Jan 20 23:22:29 golem kernel: [   64.838590]  [<c02f9264>] ?
i915_gem_object_pin+0x4f/0x16c
Jan 20 23:22:29 golem kernel: [   64.838594]  [<c0124e12>] ?
warn_slowpath_null+0xf/0x13
Jan 20 23:22:29 golem kernel: [   64.838598]  [<c02f9264>] ?
i915_gem_object_pin+0x4f/0x16c
Jan 20 23:22:29 golem kernel: [   64.838603]  [<c02fb1df>] ?
i915_gem_execbuffer_reserve+0x123/0x2ab
Jan 20 23:22:29 golem kernel: [   64.838607]  [<c02fb99a>] ?
i915_gem_do_execbuffer+0x3f4/0xea1
Jan 20 23:22:29 golem kernel: [   64.838614]  [<c018889a>] ?
check_object+0x147/0x19e
Jan 20 23:22:29 golem kernel: [   64.838619]  [<c0188e1e>] ?
alloc_debug_processing+0xd8/0x11b
Jan 20 23:22:29 golem kernel: [   64.838623]  [<c02fc864>] ?
i915_gem_execbuffer2+0x55/0x17d
Jan 20 23:22:29 golem kernel: [   64.838627]  [<c02fc907>] ?
i915_gem_execbuffer2+0xf8/0x17d
Jan 20 23:22:29 golem kernel: [   64.838633]  [<c02df12c>] ?
drm_ioctl+0x283/0x33d
Jan 20 23:22:29 golem kernel: [   64.838637]  [<c02fc80f>] ?
i915_gem_execbuffer2+0x0/0x17d
Jan 20 23:22:29 golem kernel: [   64.838642]  [<c018c009>] ?
do_sync_read+0x89/0xc4
Jan 20 23:22:29 golem kernel: [   64.838646]  [<c02deea9>] ?
drm_ioctl+0x0/0x33d
Jan 20 23:22:29 golem kernel: [   64.838651]  [<c0198c3b>] ?
do_vfs_ioctl+0x4a5/0x4d6
Jan 20 23:22:29 golem kernel: [   64.838657]  [<c023921c>] ?
security_file_permission+0x6f/0x7a
Jan 20 23:22:29 golem kernel: [   64.838662]  [<c013e3c4>] ?
ktime_get_ts+0xe2/0xec
Jan 20 23:22:29 golem kernel: [   64.838666]  [<c0198cad>] ?
sys_ioctl+0x41/0x64
Jan 20 23:22:29 golem kernel: [   64.838671]  [<c010270c>] ?
sysenter_do_call+0x12/0x22
Jan 20 23:22:29 golem kernel: [   64.838674] ---[ end trace
a26556fb5c34bd18 ]---

Xorg.0.log

[    53.085] (II) intel(0): EDID vendor "ENC", prod id 5769
[    53.085] (II) intel(0): Using hsync ranges from config file
[    53.085] (II) intel(0): Using vrefresh ranges from config file
[    53.085] (II) intel(0): Printing DDC gathered Modelines:
[    53.085] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328
1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    53.085] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968
1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    53.085] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752
800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    53.085] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846
900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    53.085] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048
1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    54.013] (II) intel(0): EDID vendor "ENC", prod id 5769
[    54.013] (II) intel(0): Using hsync ranges from config file
[    54.013] (II) intel(0): Using vrefresh ranges from config file
[    54.013] (II) intel(0): Printing DDC gathered Modelines:
[    54.013] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328
1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    54.013] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968
1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    54.014] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752
800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    54.014] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846
900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    54.014] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048
1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    64.838] (WW) intel(0): flip queue failed: Cannot allocate memory
[    64.838] (WW) intel(0): Page flip failed: Cannot allocate memory
[    64.838] (EE) intel(0): Failed to submit batch buffer, expect
rendering corruption or even a frozen display: Cannot allocate memory.
[    64.843] (WW) intel(0): flip queue failed: Cannot allocate memory
[    64.843] (WW) intel(0): Page flip failed: Cannot allocate memory
[    64.843] (EE) intel(0): Failed to submit batch buffer, expect
rendering corruption or even a frozen display: Cannot allocate memory.
[    64.846] (WW) intel(0): flip queue failed: Cannot allocate memory
[    64.846] (WW) intel(0): Page flip failed: Cannot allocate memory
[    64.846] (EE) intel(0): Failed to submit batch buffer, expect
rendering corruption or even a frozen display: Cannot allocate memory.
[    64.853] (WW) intel(0): flip queue failed: Cannot allocate memory
[    64.853] (WW) intel(0): Page flip failed: Cannot allocate memory
[    64.853] (EE) intel(0): Failed to submit batch buffer, expect
rendering corruption or even a frozen display: Cannot allocate memory.
[    64.859] (WW) intel(0): flip queue failed: Cannot allocate memory
[    64.859] (WW) intel(0): Page flip failed: Cannot allocate memory
[    64.859] (EE) intel(0): Failed to submit batch buffer, expect
rendering corruption or even a frozen display: Cannot allocate memory.
[    64.866] (WW) intel(0): flip queue failed: Cannot allocate memory





> On Thu, Jan 20, 2011 at 9:29 AM, Knut Petersen
> <Knut_Petersen@t-online.de> wrote:
>   
>> Kernel 2.6.38-rc1 and -git1 will lock my AOpen i915GMm-HFS
>> at the end of  KDE startup if automatic process group scheduling
>> is actived in kernel config. A hard reset is necessary.
>> Without automatic process group scheduling everything is ok.
>>     
> Interesting. Most likely timing-related, but maybe there's some actual
> memory corruption. Adding the scheduler guys just in case.
>
> It might be interesting to see if enabling SLUB debugging makes any
> difference. Interesting for two reasons:
>
>  - it may just make the problem go away because it changes timings
> radically enough (which is the bad case, since that doesn't really
> help us very much)
>
>  - maybe it's not timing-related, and instead shows some slab misuse
> and corruption that explains the problem.
>
> I dunno.
>
>   
>> Reproducibility of bug: 100 %
>> System: AOpen i915GMm-Hfs, 2GB, Pentium M
>> Distribution: openSuSE 11.3
>>
>> cu,
>>  Knut
>>
>> Jan 20 17:57:07 golem kernel: [   58.087054] ------------[ cut here ]------------
>> Jan 20 17:57:07 golem kernel: [   58.087117] kernel BUG at drivers/gpu/drm/i915/i915_gem.c:3254!
>>     
> Grr. Hate people who do BUG_ON() calls that kill the machine and make
> things harder to debug.
>
> What happens if you replace that
>
>   BUG_ON(obj->pin_count == DRM_I915_GEM_OBJECT_MAX_PIN_COUNT);
>
> with a
>
>   if (WARN_ON_ONCE(obj->pin_count == DRM_I915_GEM_OBJECT_MAX_PIN_COUNT))
>     return -ENOMEM;
>
> or similar? Does it limp along? I'm not suggesting that as a fix
> (obviously), but I do think that we have way too many BUG_ON's, and
> too few people thinking about "how can I make the machine possibly
> limp on so that the oops is easier to see and report"
>
>                      Linus
>
>   

