Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1CVNbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:31:11 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46608 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab1CVNbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:31:08 -0400
Date: Tue, 22 Mar 2011 14:31:01 +0100
From: Borislav Petkov <bp@amd64.org>
To: Giorgio <mywing81@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux@brodo.de, dougthompson@xmission.com,
        mchehab@redhat.com
Subject: Re: Machine Check Exception and cpufreq
Message-ID: <20110322133101.GB24006@gere.osrc.amd.com>
References: <AANLkTim3gpBUtDQ=WnLRjzuwpNe=+m4wLK=maS1tLc8U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim3gpBUtDQ=WnLRjzuwpNe=+m4wLK=maS1tLc8U@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 22, 2011 at 12:27:31PM +0100, Giorgio wrote:
> Hello,
> 
> I have recently noticed the following problem on my machine. When I
> run something like "find dir/ -type f -exec md5sum {} \;" where dir/
> contains several Gb of data, 90% of the time I get a "Machine Check
> Exception" and a kernel panic. These are the logs that I have been
> able to capture using netconsole:
> 
> #1:
> [ 2586.090191]
> [ 2586.090194] HARDWARE ERROR
> [ 2586.090210] CPU 0: Machine Check Exception:                4 Bank
> 4: b200001000010c0f
> [ 2586.090214] TSC 4657e129df5
> [ 2586.090221] PROCESSOR 2:20fc2 TIME 1273577579 SOCKET 0 APIC 0
> [ 2586.090225] MC4_STATUS: Uncorrected error, report: yes, MiscV:
> invalid, CPU context corrupt: yes
> [ 2586.090236]  Northbridge Error, node 0
> [ 2586.090241] K8 ECC error.
> [ 2586.090246]  Transaction type: generic(generic), no timeout, Cache
> Level: L3/generic, Participating Processor: local node observed as 3rd
> party (OBS)
> [ 2586.090251] This is not a software problem!
> [ 2586.090254] Machine check: Processor context corrupt
> [ 2586.090259] Kernel panic - not syncing: Fatal machine check on current CPU
> [ 2586.090265] Pid: 48, comm: kondemand/0 Tainted: P   M
> 2.6.32-22-generic #33-Ubuntu
> [ 2586.090269] Call Trace:
> [ 2586.090274]  <#MC>  [<ffffffff8153e010>] panic+0x78/0x137
> [ 2586.090290]  [<ffffffff81024442>] mce_panic+0x1e2/0x210
> [ 2586.090297]  [<ffffffff81025803>] do_machine_check+0x7d3/0x820
> [ 2586.090304]  [<ffffffff815411bc>] machine_check+0x1c/0x30
> [ 2586.090311]  [<ffffffff81038be0>] ? native_read_msr_safe+0x10/0x30
> [ 2586.090315]  <<EOE>>  [<ffffffff8102999a>]
> query_current_values_with_pending_wait+0x5a/0xe0
> [ 2586.090327]  [<ffffffff8102a08a>] write_new_fid+0x7a/0x110
> [ 2586.090333]  [<ffffffff8102a20b>] core_frequency_transition+0xeb/0x180
> [ 2586.090338]  [<ffffffff8102a39a>] transition_fid_vid+0xfa/0x220
> [ 2586.090343]  [<ffffffff8102a5be>] transition_frequency_fidvid+0xbe/0x140
> [ 2586.090349]  [<ffffffff8102a81e>] powernowk8_target+0x1de/0x390
> [ 2586.090407]  [<ffffffff8143194a>] __cpufreq_driver_target+0x3a/0x40
> [ 2586.090413]  [<ffffffff81435bcb>] dbs_check_cpu+0x23b/0x240
> [ 2586.090418]  [<ffffffff81435ca8>] do_dbs_timer+0xd8/0x100
> [ 2586.090424]  [<ffffffff81435bd0>] ? do_dbs_timer+0x0/0x100
> [ 2586.090430]  [<ffffffff81080777>] run_workqueue+0xc7/0x1a0
> [ 2586.090436]  [<ffffffff810808f3>] worker_thread+0xa3/0x110
> [ 2586.090442]  [<ffffffff81085320>] ? autoremove_wake_function+0x0/0x40
> [ 2586.090448]  [<ffffffff81080850>] ? worker_thread+0x0/0x110
> [ 2586.090453]  [<ffffffff81084fa6>] kthread+0x96/0xa0
> [ 2586.090459]  [<ffffffff810141ea>] child_rip+0xa/0x20
> [ 2586.090464]  [<ffffffff81084f10>] ? kthread+0x0/0xa0
> [ 2586.090469]  [<ffffffff810141e0>] ? child_rip+0x0/0x20

..

> Note how the error is always the same and the call trace also seems identical.
> After many tests on my hardware (memtest, trying a different power
> suppy, trying different bios paramenters, cleaning memory
> contacts...), looking at the call trace I thought this could be
> related to cpu frequency scaling. So I did the same test again, but
> this time I used the 'performance' governor instead of the 'ondemand'
> one. And, surprisingly, the problem doesn't occur (not even if I start
> multiple heavy jobs,
> like one compilation of a big program and two md5sum jobs on different
> hard drives).
> Could this be a bug on cpufreq? At this point I don't think my
> hardware is faulty.
> Here's some info about my system:
> 
> http://mywing.altervista.org/tmp/info.log
> 
> I'm not following the list, so please CC me in all reaply. Thanks.

this is very interesting. Question: is it possible to retest with
a newer kernel from upstream (say 2.6.38) to see whether the issue
persists? I'd like to rule out the possibility that powernow-k8 is
not causing any trouble which has been fixed in newer kernels in the
meantime.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
