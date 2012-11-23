Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab2KWJVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:21:44 -0500
Received: from gmmr7.centrum.cz ([46.255.225.249]:49402 "EHLO gmmr7.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab2KWJVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:21:40 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_memory=2Dcgroup_bug?=
Date: Fri, 23 Nov 2012 10:21:37 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>
References: <20121121200207.01068046@pobox.sk>, <20121122152441.GA9609@dhcp22.suse.cz>, <20121122190526.390C7A28@pobox.sk>, <20121122214249.GA20319@dhcp22.suse.cz>, <20121122233434.3D5E35E6@pobox.sk> <20121123074023.GA24698@dhcp22.suse.cz>
In-Reply-To: <20121123074023.GA24698@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121123102137.10D6D653@pobox.sk>
X-Maser: Georgo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Either use gdb YOUR_VMLINUX and disassemble mem_cgroup_handle_oom or
>use objdump -d YOUR_VMLINUX and copy out only mem_cgroup_handle_oom
>function.
If 'YOUR_VMLINUX' is supposed to be my kernel image:

# gdb vmlinuz-3.2.34-grsec-1 
GNU gdb (GDB) 7.0.1-debian
Copyright (C) 2009 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
"/root/bug/vmlinuz-3.2.34-grsec-1": not in executable format: File format not recognized


# objdump -d vmlinuz-3.2.34-grsec-1 
objdump: vmlinuz-3.2.34-grsec-1: File format not recognized


# file vmlinuz-3.2.34-grsec-1 
vmlinuz-3.2.34-grsec-1: Linux kernel x86 boot executable bzImage, version 3.2.34-grsec (root@server01) #1, RO-rootFS, swap_dev 0x3, Normal VGA

I'm probably doing something wrong :)



It, luckily, happend again so i have more info.

 - there wasn't any logs in kernel from OOM for that cgroup
 - there were 16 processes in cgroup
 - processes in cgroup were taking togather 100% of CPU (it was allowed to use only one core, so 100% of that core)
 - memory.failcnt was groving fast
 - oom_control:
oom_kill_disable 0
under_oom 0 (this was looping from 0 to 1)
 - limit_in_bytes was set to 157286400
 - content of stat (as you can see, the whole memory limit was used):
cache 0
rss 0
mapped_file 0
pgpgin 0
pgpgout 0
swap 0
pgfault 0
pgmajfault 0
inactive_anon 0
active_anon 0
inactive_file 0
active_file 0
unevictable 0
hierarchical_memory_limit 157286400
hierarchical_memsw_limit 157286400
total_cache 0
total_rss 157286400
total_mapped_file 0
total_pgpgin 10326454
total_pgpgout 10288054
total_swap 0
total_pgfault 12939677
total_pgmajfault 4283
total_inactive_anon 0
total_active_anon 157286400
total_inactive_file 0
total_active_file 0
total_unevictable 0


i also grabber oom_adj, oom_score_adj and stack of all processes, here it is:
http://www.watchdog.sk/lkml/memcg-bug.tar

Notice that stack is different for few processes. Stack for all processes were NOT chaging and was still the same.

Btw, don't know if it matters but i was several cgroup subsystems mounted and i'm also using them (i was not activating freezer in this case, don't know if it can be active automatically by kernel or what, didn't checked if cgroup was freezed but i suppose it wasn't):
none            /cgroups        cgroup  defaults,cpuacct,cpuset,memory,freezer,task,blkio 0 0

Thank you.

azur
