Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1G1BzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 21:55:05 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41535 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1G1By4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 21:54:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1107271446460.406@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1107221210160.21367@cl320.eecs.utk.edu>
	<alpine.DEB.2.00.1107271446460.406@cl320.eecs.utk.edu>
Date: Thu, 28 Jul 2011 09:54:55 +0800
Message-ID: <CAF1ivSZkC71V+ownS+k0Qmi3S_HfETBkK3D+U4FYFZ=cojmoGg@mail.gmail.com>
Subject: Re: [perf] overflow/perf_count_sw_cpu_clock crashes recent kernels
From: Lin Ming <minggr@gmail.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        ming.m.lin@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 2:51 AM, Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> Hello
>
>> With 3.0.0 the PAPI "overflow_allcounters" test reliably locks up my
>> Nehalem system.
>
> I finally managed to narrow this down to a small test, which is attached.
>
> Basically measuring overflow on the perf::perf_count_sw_cpu_clock
> event will potentially *lock up* your system from user-space.
>
> This seems to be a long standing bug.  It will quickly lock solid
> my Nehalem test box on 3.0, 2.6.39 and 2.6.38.
>
> On a Core2 2.6.32 box the crash testing program will wedge and become
> unkillable, but it doesn't actually kill the machine.

Tried on my Nehalem machine, the testing program also becomes unkillable.

[147868.734111] WARNING: at
/home/zhyan/sources/linux-2.6/kernel/smp.c:320
smp_call_function_single+0x68/0x104()
[147868.734113] Hardware name: Studio XPS 8000
[147868.734115] Modules linked in: ebtable_nat ebtables ipt_MASQUERADE
iptable_nat nf_nat bridge stp llc rmd160 crypto_null camellia lzo
cast6 cast5 deflate zlib_deflate cts ctr gcm ccm serpent blowfish
twofish_generic twofish_i586 twofish_common ecb xcbc cbc
sha256_generic sha512_generic des_generic aes_i586 geode_aes
aes_generic ah6 ah4 esp6 esp4 xfrm4_mode_beet xfrm4_tunnel tunnel4
xfrm4_mode_tunnel xfrm4_mode_transport xfrm6_mode_transport
xfrm6_mode_ro xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6
xfrm_ipcomp xfrm6_tunnel tunnel6 af_key sunrpc ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6
kvm_intel kvm uinput snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device radeon
snd_pcm snd_timer ttm drm_kms_helper drm snd broadcom tg3
firewire_ohci firewire_core crc_itu_t i2c_i801 i2c_algo_bit soundcore
serio_raw i2c_core snd_page_alloc usb_storage iTCO_wdt
iTCO_vendor_support joydev dcdbas microcod
e pcspkr [last unloaded: mperf]
[147868.734175] Pid: 12152, comm: oflo_sw_cpu_clo Not tainted 3.0.0 #38
[147868.734176] Call Trace:
[147868.734180]  [<c043b29f>] warn_slowpath_common+0x6a/0x7f
[147868.734183]  [<c0464440>] ? smp_call_function_single+0x68/0x104
[147868.734186]  [<c04a5bc8>] ? perf_event_tid+0x21/0x21
[147868.734189]  [<c043b2c8>] warn_slowpath_null+0x14/0x18
[147868.734191]  [<c0464440>] smp_call_function_single+0x68/0x104
[147868.734193]  [<c04a5c3c>] task_function_call+0x37/0x40
[147868.734196]  [<c04a68e7>] ? __perf_event_exit_context+0x7e/0x7e
[147868.734199]  [<c04a5cf0>] perf_event_disable+0x38/0x75
[147868.734201]  [<c04a9e13>] __perf_event_overflow+0x15a/0x209
[147868.734205]  [<c0432f5e>] ? get_parent_ip+0xb/0x31
[147868.734209]  [<c0457fc8>] ? local_clock+0x22/0x2b
[147868.734211]  [<c04aa461>] perf_event_overflow+0x11/0x13
[147868.734214]  [<c04aa4f8>] perf_swevent_hrtimer+0x95/0xed
[147868.734218]  [<c05d1291>] ? timerqueue_del+0x49/0x56
[147868.734221]  [<c0455a8c>] ? __remove_hrtimer+0x58/0x75
[147868.734223]  [<c0455cea>] __run_hrtimer+0xb0/0x12f
[147868.734226]  [<c04aa463>] ? perf_event_overflow+0x13/0x13
[147868.734228]  [<c0456691>] hrtimer_interrupt+0xe9/0x1ce
[147868.734233]  [<c04198cb>] smp_apic_timer_interrupt+0x5d/0x70
[147868.734236]  [<c07cf1ad>] apic_timer_interrupt+0x31/0x38
[147868.734238] ---[ end trace a164f652f8bfd400 ]---
[147928.569073] INFO: rcu_preempt_state detected stalls on CPUs/tasks:
{ 6} (detected by 7, t=60002 jiffies)
[147930.784928] INFO: rcu_bh_state detected stalls on CPUs/tasks: { 6}
(detected by 4, t=60002 jiffies)

Lin Ming
