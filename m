Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2DNPda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 11:33:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51432 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab2DNPd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 11:33:29 -0400
Date: Sat, 14 Apr 2012 17:33:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/lockdep.c:2592
 trace_hardirqs_on_caller+0x1a4/0x1b0()
Message-ID: <20120414153323.GA21242@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	lkml <linux-kernel@vger.kernel.org>
References: <20120404044003.GA28344@liondog.tnic>
 <1334407517.2528.93.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1334407517.2528.93.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 02:45:17PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-04-04 at 06:40 +0200, Borislav Petkov wrote:
> > Hi guys,
> > 
> > I get the following after resuming on 3.4-rc1. Any ideas how to debug this?
> > 
> > [  100.962703] Enabling non-boot CPUs ...
> > [  100.971361] lockdep: fixing up alternatives.
> > [  100.971383] Booting Node 0 Processor 1 APIC 0x1
> > [  100.982448] LVT offset 0 assigned for vector 0x400
> > [  100.984636] ------------[ cut here ]------------
> > [  100.984648] WARNING: at kernel/lockdep.c:2592 trace_hardirqs_on_caller+0x1a4/0x1b0()
> > [  100.984652] Hardware name: 30515QG
> > [  100.984654] Modules linked in: tun cpufreq_stats cpufreq_conservative cpufreq_powersave cpufreq_userspace binfmt_misc uinput kvm_amd kvm fuse dm_crypt dm_mod ipv6 vfat fat loop snd_hda_codec_conexant snd_hda_codec_hdmi snd_hda_intel arc4 snd_hda_codec rtl8192ce rtl8192c_common rtlwifi snd_hwdep snd_pcm mac80211 thinkpad_acpi radeon snd_seq cfg80211 snd_timer snd_seq_device ttm snd nvram video ohci_hcd pcspkr ehci_hcd soundcore powernow_k8 mperf microcode k10temp rfkill thermal evdev button battery processor drm_kms_helper snd_page_alloc thermal_sys ac
> > [  100.984739] Pid: 0, comm: swapper/1 Not tainted 3.4.0-rc1 #1
> > [  100.984743] Call Trace:
> > [  100.984751]  [<ffffffff8103588f>] warn_slowpath_common+0x7f/0xc0
> > [  100.984758]  [<ffffffff814296f0>] ? start_secondary+0x1ab/0x205
> > [  100.984764]  [<ffffffff810358ea>] warn_slowpath_null+0x1a/0x20
> > [  100.984769]  [<ffffffff8108d3f4>] trace_hardirqs_on_caller+0x1a4/0x1b0
> > [  100.984774]  [<ffffffff8108d40d>] trace_hardirqs_on+0xd/0x10
> > [  100.984779]  [<ffffffff814296f0>] start_secondary+0x1ab/0x205
> > [  100.984785] ---[ end trace c9b3d3b86e472b29 ]---
> > [  100.986201] CPU1 is up
> 
> Curious, it seems to think start_secondary is running from hardirq
> context. We fork the idle thread from a worker thread, and all that is
> process context, so I've no clue how current->hardirq_context gets set
> there.
> 
> How reproducable is this for you? And does it also happen on regular
> hotplug?

Well, let me look... yeah, it happened only once on -rc1 when I reported
it. This box runs plain -rc2 now and there are no more hickups. And no,
regular hotplug looks ok too.

What happened, though, while playing with this a bit is that I offlined
cpu 1 (box is a dual core) and suspended to disk. The box hung itself
while resuming with only cpu 0 online, at the end of resume where it
says "Suspending console(s) (use no_console_suspend to debug)."

And yes, this is reproducible after I rebooted and tried the same deal
again.

Oh well, I don't know whether this is related to ->hardirq_context thing
being set above but in any case, it looks b0rked.

Thanks.

-- 
Regards/Gruss,
    Boris.
