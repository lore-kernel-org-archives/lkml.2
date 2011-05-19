Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1ESWY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:24:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab1ESWYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:24:24 -0400
Date: Thu, 19 May 2011 18:24:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Paul Bolle <pebolle@tiscali.nl>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Mysterious CFQ crash and RCU
Message-ID: <20110519222404.GG12600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Few people have reported hard to reproduce CFQ crash time to time. Most of
the people could not reproduce the issue consistently hence we could not
debug it further. Now for the first time, Paul Bolle, can reproduce this issue
reliably on his machine, so I am hopeful that we can get to bottom of this
long time pending mysterious issue.

There might be many bz tracking this issue but one of the bzs is 577968 in
bugzilla.redhat.com

BUG: unable to handle kernel paging request at 6b6b6b6b
IP: [<c05e859d>] call_for_each_cic+0x29/0x44
*pde = 00000000 
Oops: 0000 [#1] SMP 
last sysfs file:
/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/energy_full
Modules linked in: bnep bluetooth fuse cpufreq_ondemand acpi_cpufreq mperf
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_netbios_ns
ip6table_filter nf_conntrack_broadcast ip6_tables snd_intel8x0m
snd_intel8x0
arc4 snd_ac97_codec ath5k ac97_bus snd_seq ath snd_seq_device mac80211
snd_pcm
ppdev thinkpad_acpi cfg80211 microcode snd_timer parport_pc e1000 snd
rfkill
parport iTCO_wdt soundcore snd_page_alloc iTCO_vendor_support joydev
i2c_i801
pcspkr uinput ipv6 yenta_socket video radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]

Pid: 11397, comm: mandb Not tainted 2.6.39-0.rc5.git0.0.local.fc16.i686 #1
IBM 
      /       
EIP: 0060:[<c05e859d>] EFLAGS: 00010202 CPU: 0
EIP is at call_for_each_cic+0x29/0x44
EAX: 00000001 EBX: 6b6b6b6b ECX: 00000246 EDX: c0ad4a98
ESI: ecfd0980 EDI: c05e88a4 EBP: c670bf18 ESP: c670bf0c
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process mandb (pid: 11397, ti=c670a000 task=d40769f0 task.ti=c670a000)
Stack:
 ecfd0980 d40769f0 d4076dc0 c670bf20 c05e85ca c670bf2c c05ddc86 ecfd0980
 c670bf40 c05ddd16 d40769f0 00000012 c670bf74 c670bf8c c0440813 f2a182e8
 d401ac08 c670bf70 c04f48da 00000001 d4076bf4 d40769e8 d4076bf4 00000001
Call Trace:
 [<c05e85ca>] cfq_free_io_context+0x12/0x14
 [<c05ddc86>] put_io_context+0x34/0x5c
 [<c05ddd16>] exit_io_context+0x68/0x6d
 [<c0440813>] do_exit+0x63e/0x661
 [<c04f48da>] ? fsnotify_modify+0x64/0x6c
 [<c0440a4d>] do_group_exit+0x63/0x86
 [<c0440a88>] sys_exit_group+0x18/0x18
 [<c082551f>] sysenter_do_call+0x12/0x38
Code: 5d c3 55 89 e5 57 56 53 3e 8d 74 26 00 89 c6 89 d7 e8 3a ec ff ff 8b
5e
4c e8 00 b1 e6 ff 85 c0 74 05 e8 b7 ff ff ff 85 db 74 11 <8b> 03 0f 18 00
90 8d
53 d8 89 f0 ff d7 8b 1b eb dd e8 49 ec ff 
EIP: [<c05e859d>] call_for_each_cic+0x29/0x44 SS:ESP 0068:c670bf0c
CR2: 000000006b6b6b6b
---[ end trace 70dea08ef41fda48 ]---

In summary once in a while people notice CFQ crash. Debugging shows that
we have a rcu protected hlist of elements of type cfq_io_context. Head of
the list is at ioc->cic_list. We crash while traversing ioc->cic_list
under rcu.

Looks like an element which we are trying to fetch the next pointer from got
freed to slab, and the object got poisoned with 0x6b6b6b6b.. and then we
tried to fetch the next object pointer and ended up dereferencing a
freed object and CFQ crashes.

The function in question here is call_for_each_cic() in block/cfq-iosched.c

We free the cfq_io_context object using call_rcu(). So on the surface
it looks like that we decoupled a cfq_io_context object from the hash
list and scheduled a call_rcu() so that it is freed after rcu grace
period but somehow object got freed earlier and got released to slab
and got poisoned.

Is it possible? We have looked at the code many a times and we think
that rcu locking around it is fine. Is it possible that a call_rcu()
can fire before rcu grace period is over.

I had put a debug patch in CFQ (details are in bugzilla) and I can
see that after decoupling the object from the hash list, it got
freed while we were still under rcu_read_lock().

Is there any known issue or is there any quick tip on how can I 
go about debugging it further from rcu point of view.

Thanks
Vivek
