Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2GCP1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:27:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab2GCP1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:27:16 -0400
Message-ID: <4FF30F48.3030702@redhat.com>
Date: Tue, 03 Jul 2012 11:27:04 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3][RFC] Potential fix for leapsecond caused futex issue
 (v3)
References: <1341281766-22722-1-git-send-email-johnstul@us.ibm.com> <4FF28CB1.7020304@us.ibm.com>
In-Reply-To: <4FF28CB1.7020304@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/03/2012 02:09 AM, John Stultz wrote:
> On 07/02/2012 07:16 PM, John Stultz wrote:
>> NOTE: Some reports have been of a hard hang right at or before
>> the leapsecond. I've not been able to reproduce or diagnose
>> this, so this fix does not likely address the reported hard
>> hangs (unless they end up being connected to the futex/hrtimer
>> issue). Please email lkml and me if you experienced this.
> 
> Since as noted above, I've seen some sporadic reports of hard hangs. Some seem
> connected to the hrtimer problem, where ksoftirq seems to go crazy and cause nmi
> watchdog lockups, but others are less clear.
> 
> I wanted to try to provide a way to stress both the kernel's leapsecond code as
> well as provide a way for folks to be able to test their application's
> robustness in the face of leapsecond inconsistencies.
> 
> Attached is my first attempt at such a test.
> 
> It is designed to be run on a server, where it will schedule a leapsecond every
> day at midnight GMT.  So every day, while it runs, the server will see a
> leapsecond.  This allows the the leap second, as well as any suspected timer
> related lockups that might happen when the leapsecond is scheduled to be stressed.
> 
> The test also outputs time samples right before, during and after the leapsecond
> is applied, so you can watch it happen.
> 
> Also since once a day is a fairly low frequency, if you pass a "-s" to the test,
> it will jump the system time forward to 10 seconds right before the scheduled
> leapsecond for that day. Allowing a leapsecond to occur every ~13 seconds. This
> mode may cause application disruption, as it also causes the system to advance a
> day every ~13 seconds.
> 
> The test additionally will note if it observes the hrtimer early expiration
> problem that was widely seen over the weekend.
> 
> Hopefully this will provide a mechanism to test and maintain the kernel's
> correct behaviour for these rare events, as well as allowing folks to get more
> comfortable with leapsecond behaviour and test how it might impact their
> applications.
> 
> If anyone who observed a hard hang is able to use this to reproduce the problem,
> I'd greatly like to hear about it.

> 
> Build instructions are in the test file.

Thanks John -- I moved to using this for testing and hit the following
softlockup when running latest + your patchset:

[ 1084.433362] BUG: soft lockup - CPU#17 stuck for 22s! [leap-a-day:1275]^M
[ 1084.440700] Modules linked in: nfs nfs_acl auth_rpcgss fscache lockd sunrpc
kvm_intel ixgbe coretemp kvm igb ptp pps_core mdio ioatdma lpc_ich crc32c_intel
joydev mfd_core i2c_i801 ghash_clmulni_intel tpm_tis wmi dca sb_edac microcode
edac_core pcspkr tpm tpm_bios hid_generic isci libsas scsi_transport_sas mgag200
i2c_algo_bit drm_kms_helper ttm drm i2c_core [last unloaded: scsi_wait_scan]^M
[ 1084.479183] CPU 17 ^M
[ 1084.481568] Modules linked in: nfs nfs_acl auth_rpcgss fscache lockd sunrpc
kvm_intel ixgbe coretemp kvm igb ptp pps_core mdio ioatdma lpc_ich crc32c_intel
joydev mfd_core i2c_i801 ghash_clmulni_intel tpm_tis wmi dca sb_edac microcode
edac_core pcspkr tpm tpm_bios hid_generic isci libsas scsi_transport_sas mgag200
i2c_algo_bit drm_kms_helper ttm drm i2c_core [last unloaded: scsi_wait_scan]^M
[ 1084.520061] ^M
[ 1084.521740] Pid: 1275, comm: leap-a-day Not tainted 3.5.0-rc4+ #1 Intel
Corporation S2600CP/S2600CP^M
[ 1084.531860] RIP: 0010:[<ffffffff810b3d57>]  [<ffffffff810b3d57>]
smp_call_function_many+0x1f7/0x260^M
[ 1084.541962] RSP: 0018:ffff88042769fdf8  EFLAGS: 00000202^M
[ 1084.547891] RAX: 0000000000000080 RBX: 0000000000000292 RCX: 0000000000000020^M
[ 1084.555858] RDX: 0000000000000080 RSI: 0000000000000080 RDI: 0000000000000292^M
[ 1084.563826] RBP: ffff88042769fe48 R08: ffffffff81cd7200 R09: 0000000000000080^M
[ 1084.571790] R10: ffff88042f7342f0 R11: 0000000000000216 R12: ffffffff8137cd43^M
[ 1084.579758] R13: ffff88042769fd88 R14: 0000000000000292 R15: ffff88042769fda8^M
[ 1084.587727] FS:  00007fba8d48b740(0000) GS:ffff88042f720000(0000)
knlGS:0000000000000000^M
[ 1084.596758] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
[ 1084.603174] CR2: 0000003d72e18c48 CR3: 0000000415d66000 CR4: 00000000000407e0^M
[ 1084.611141] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000^M
[ 1084.619120] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400^M
[ 1084.627092] Process leap-a-day (pid: 1275, threadinfo ffff88042769e000, task
ffff880425fd1720)^M
[ 1084.636694] Stack:^M
[ 1084.638950]  0000000000000003 0100000000000019 0000000000000000
ffffffff8107e960^M
[ 1084.647211]  ffff88042769fe58 ffff88042769ff58 ffffffff8107e960
0000000000000000^M
[ 1084.655479]  0000000000000000 0000000000000000 ffff88042769fe58
ffffffff810b3f12^M
[ 1084.663723] Call Trace:^M
[ 1084.666466]  [<ffffffff8107e960>] ? hrtimer_wakeup+0x30/0x30^M
[ 1084.672784]  [<ffffffff8107e960>] ? hrtimer_wakeup+0x30/0x30^M
[ 1084.679107]  [<ffffffff810b3f12>] smp_call_function+0x22/0x30^M
[ 1084.685530]  [<ffffffff810b3f78>] on_each_cpu+0x28/0x70^M
[ 1084.691371]  [<ffffffff8107ec1c>] do_clock_was_set+0x1c/0x30^M
[ 1084.697691]  [<ffffffff8107f005>] clock_was_set+0x55/0x60^M
[ 1084.703732]  [<ffffffff810a6a23>] do_settimeofday+0xd3/0xe0^M
[ 1084.709971]  [<ffffffff8105f4e5>] do_sys_settimeofday+0xb5/0x110^M
[ 1084.716677]  [<ffffffff8105f5c3>] sys_settimeofday+0x83/0xb0^M
[ 1084.723012]  [<ffffffff8160f129>] system_call_fastpath+0x16/0x1b^M
[ 1084.729782] Code: f7 ff 15 95 89 b6 00 80 7d bf 00 0f 84 9c fe ff ff 41 f6 47
20 01 0f 84 91 fe ff ff 0f 1f 84 00 00 00 00 00 f3 90 41 f6 47 20 01 <75> f7 e9
7b fe ff ff 66 90 4c 89 e2 4c 89 ee 89 df e8 53 8b 21 ^M

I'm taking a look now ... I'm not sure I believe the hrtimer_wakeup() calls on
the stack.

P.


> 
> thanks
> -john
