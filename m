Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab2ASNWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 08:22:07 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:44405 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2ASNWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 08:22:03 -0500
X-manitu-Original-Sender-IP: 86.32.213.40
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Thu, 19 Jan 2012 14:21:57 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [kmemleak report 0/2] kernel 3.1.6, x86_64
Message-ID: <20120119132157.GA19789@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
References: <20120115222932.GA24330@mobil.systemanalysen.net>
 <CAHkRjk7MGGJE04dgETmqs_SBb8ju2BOiEmei3aV8MRcpof8-GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHkRjk7MGGJE04dgETmqs_SBb8ju2BOiEmei3aV8MRcpof8-GA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-17 Tue 16:53:10, Catalin Marinas wrote:
> On 15 January 2012 22:29, Roland Eggner <edvx1@systemanalysen.net> wrote:
> > It looks like memory leaks are “eating” 1G+ after only 1 week uptime … that's
> > not nice.
> 
> Does your system actually lose this memory or they are just be false
> positives?

Looks like lost memory.  More info will follow in my thread
“[kmemleak reports 1/2]”.

> We've known since around 3.1 that kmemleak has some issues
> with per-cpu memory allocations and reporting false positives. The
> patches just went in (to be visible in 3.3-rc1). Alternatively, you
> could cherry-pick them from here:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=shortlog;h=029aeff5db879afd7760f11214b6fea45f76b58e
> 
> (commit f528f0b8e5 "kmemleak: Handle percpu memory allocation" is the
> one you would need)

Cherry-picked “kmemleak: Handle percpu memory allocation” as suggested, it
applied without fuzz on 3.1.6 source.  The recompiled kernel has been running
22+ hours.  A wdiff between dmesg reports from the previous and the new kernel
shows nothing remarkable, kmemleak entries are similar.  3 entries in
/var/log/messages “comm: modprobe”, too:

grep -A8 '^2012-01-18T15.*kmemleak:' /var/log/messages
2012-01-18T15:07:58.888737+01:00 mobil kernel: [    5.082708] kmemleak: Kernel memory leak detector initialized
2012-01-18T15:07:58.888738+01:00 mobil kernel: [    5.082720] kmemleak: Automatic memory scanning thread started
2012-01-18T15:07:58.888739+01:00 mobil kernel: [    5.088103] rtc_cmos 00:06: setting system clock to 2012-01-18 14:07:34 UTC (1326895654)
2012-01-18T15:07:58.888740+01:00 mobil kernel: [    5.132408] XFS (sda21): Mounting Filesystem
2012-01-18T15:07:58.888740+01:00 mobil kernel: [    5.237157] XFS (sda21): Ending clean mount
2012-01-18T15:07:58.888741+01:00 mobil kernel: [    5.238499] VFS: Mounted root (xfs filesystem) readonly on device 259:5.
2012-01-18T15:07:58.888743+01:00 mobil kernel: [    5.275538] devtmpfs: mounted
2012-01-18T15:07:58.888922+01:00 mobil kernel: [    5.277644] Freeing unused kernel memory: 640k freed
2012-01-18T15:07:58.888924+01:00 mobil kernel: [    6.465105] grsec: mount of proc to /proc by /bin/mount[mount:1093] uid/euid:0/0 gid/egid:0/0, parent /bin/bash[bash:1092] uid/euid:0/0 gid/egid:0/0
2012-01-18T15:07:58.888925+01:00 mobil kernel: [    6.521311] grsec: mount of sysfs to /sys by /bin/mount[mount:1110] uid/euid:0/0 gid/egid:0/0, parent /bin/bash[bash:1109] uid/euid:0/0 gid/egid:0/0
--
2012-01-18T15:21:05.610350+01:00 mobil kernel: [  814.170102] kmemleak: Adding scan area to unknown object at 0xffffffffa0028280
2012-01-18T15:21:05.610370+01:00 mobil kernel: [  814.170110] Pid: 5266, comm: modprobe Not tainted 3.1.6-grsecurity.roland.1 #2
2012-01-18T15:21:05.610374+01:00 mobil kernel: [  814.170114] Call Trace:
2012-01-18T15:21:05.610380+01:00 mobil kernel: [  814.170125]  [<ffffffff81672f56>] kmemleak_scan_area+0x136/0x1a0
2012-01-18T15:21:05.610384+01:00 mobil kernel: [  814.170134]  [<ffffffff810bcb87>] load_module+0x687/0x1e40
2012-01-18T15:21:05.610388+01:00 mobil kernel: [  814.170143]  [<ffffffff81307d67>] ? gr_is_capable+0x27/0x40
2012-01-18T15:21:05.610392+01:00 mobil kernel: [  814.170149]  [<ffffffff810be3a0>] sys_init_module+0x60/0x1f0
2012-01-18T15:21:05.610396+01:00 mobil kernel: [  814.170157]  [<ffffffff81688e8d>] system_call_fastpath+0x18/0x1d
2012-01-18T15:21:05.622252+01:00 mobil kernel: [  814.181353] snd_hda_intel 0000:01:00.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
--
2012-01-18T15:21:06.005328+01:00 mobil kernel: [  814.563803] kmemleak: Adding scan area to unknown object at 0xffffffffa002a5a0
2012-01-18T15:21:06.005355+01:00 mobil kernel: [  814.563811] Pid: 5280, comm: modprobe Not tainted 3.1.6-grsecurity.roland.1 #2
2012-01-18T15:21:06.005359+01:00 mobil kernel: [  814.563815] Call Trace:
2012-01-18T15:21:06.005365+01:00 mobil kernel: [  814.563827]  [<ffffffff81672f56>] kmemleak_scan_area+0x136/0x1a0
2012-01-18T15:21:06.005369+01:00 mobil kernel: [  814.563836]  [<ffffffff810bcb87>] load_module+0x687/0x1e40
2012-01-18T15:21:06.005374+01:00 mobil kernel: [  814.563845]  [<ffffffff81307d67>] ? gr_is_capable+0x27/0x40
2012-01-18T15:21:06.005378+01:00 mobil kernel: [  814.563851]  [<ffffffff810be3a0>] sys_init_module+0x60/0x1f0
2012-01-18T15:21:06.005382+01:00 mobil kernel: [  814.563859]  [<ffffffff81688e8d>] system_call_fastpath+0x18/0x1d
2012-01-18T15:21:06.070291+01:00 mobil kernel: [  814.628812] kmemleak: Adding scan area to unknown object at 0xffffffffa00e1220
2012-01-18T15:21:06.070314+01:00 mobil kernel: [  814.628820] Pid: 5286, comm: modprobe Not tainted 3.1.6-grsecurity.roland.1 #2
2012-01-18T15:21:06.070317+01:00 mobil kernel: [  814.628824] Call Trace:
2012-01-18T15:21:06.070323+01:00 mobil kernel: [  814.628835]  [<ffffffff81672f56>] kmemleak_scan_area+0x136/0x1a0
2012-01-18T15:21:06.070327+01:00 mobil kernel: [  814.628844]  [<ffffffff810bcb87>] load_module+0x687/0x1e40
2012-01-18T15:21:06.070358+01:00 mobil kernel: [  814.628852]  [<ffffffff81307d67>] ? gr_is_capable+0x27/0x40
2012-01-18T15:21:06.070362+01:00 mobil kernel: [  814.628858]  [<ffffffff810be3a0>] sys_init_module+0x60/0x1f0
2012-01-18T15:21:06.070366+01:00 mobil kernel: [  814.628867]  [<ffffffff81688e8d>] system_call_fastpath+0x18/0x1d
2012-01-18T15:21:08.683225+01:00 mobil kernel: [  817.234669] ADDRCONF(NETDEV_UP): eth0: link is not ready
--
2012-01-18T15:28:41.805266+01:00 mobil kernel: [ 1269.223947] kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
…


So far no significant change in frequency or backtraces of kmemleak reports
related to both of my issues.  Instead, I got a third issue:

At 00:30:14 rsyslog wrote a line “kmemleak: 11 new suspected memory leaks”.
At 01:16:42 the corresponding reports could not be retrieved,
/sys/kernel/debug/kmemleak appeared like an empty file:

grep '^2012-01-19.*kmemleak' /var/log/messages
2012-01-19T00:30:14.912242+01:00 mobil kernel: [33681.088527] kmemleak: 11 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
2012-01-19T04:00:19.577597+01:00 mobil kernel: [44744.609118] kmemleak: 18 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
2012-01-19T06:34:24.835594+01:00 mobil kernel: [53966.751077] kmemleak: 282 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
2012-01-19T06:55:06.005658+01:00 mobil kernel: [55204.817278] kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
2012-01-19T08:59:18.146598+01:00 mobil kernel: [62638.325944] kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

history 60 | grep "clear"
 7249  2012-01-18 16:50:57  bzip2 -c9 < /sys/kernel/debug/kmemleak > .tmp/"kmemleak $( date '+%F %a %T' ).bz2"  && echo "clear" >> /sys/kernel/debug/kmemleak
 7265  2012-01-19 01:16:42  bzip2 -c9 < /sys/kernel/debug/kmemleak > .tmp/"kmemleak $( date '+%F %a %T' ).bz2"  && echo "clear" >> /sys/kernel/debug/kmemleak
 7273  2012-01-19 04:15:05  bzip2 -c9 < /sys/kernel/debug/kmemleak > .tmp/"kmemleak $( date '+%F %a %T' ).bz2"  && echo "clear" >> /sys/kernel/debug/kmemleak
 7282  2012-01-19 09:16:34  bzip2 -c9 < /sys/kernel/debug/kmemleak > .tmp/"kmemleak $( date '+%F %a %T' ).bz2"  && echo "clear" >> /sys/kernel/debug/kmemleak

ls -l .tmp/"kmemleak 2012-01-19"*.bz2
-rw-r--r-- 1 root root   14 2012-01-19 01:16:42 .tmp/kmemleak 2012-01-19 Do 01:16:42.bz2
-rw-r--r-- 1 root root 1598 2012-01-19 04:15:06 .tmp/kmemleak 2012-01-19 Do 04:15:05.bz2
-rw-r--r-- 1 root root 4041 2012-01-19 09:16:51 .tmp/kmemleak 2012-01-19 Do 09:16:34.bz2


Maybe, the cherry-picked patch depends on an other part of your git commit?

Thanks for your work.
-- 
Roland Eggner
