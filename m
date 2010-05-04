Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab0EDIhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 04:37:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab0EDIhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 04:37:40 -0400
Message-ID: <4BDFDCD1.70202@redhat.com>
Date: Tue, 04 May 2010 11:37:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: CaT <cat@zip.com.au>
CC: lkml@zip.com.au, mtosatti@redhat.com, kvm@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.3: possible recursive locking detected
References: <20100504070334.GN2657@zip.com.au>
In-Reply-To: <20100504070334.GN2657@zip.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 10:03 AM, CaT wrote:
> I'm currently running 2.6.33.3 in a KVM instance emulating a core2duo
> on 1 cpu with virtio HDs running on top of a core2duo host running 2.6.33.3.
> qemu-kvm version 0.12.3.

Doesn't appear to be related to kvm.  Copying lkml.

> When doing:
>
> echo noop>/sys/block/vdd/queue/scheduler
>
> I got:
>
> [ 1424.438241] =============================================
> [ 1424.439588] [ INFO: possible recursive locking detected ]
> [ 1424.440368] 2.6.33.3-moocow.20100429-142641 #2
> [ 1424.440960] ---------------------------------------------
> [ 1424.440960] bash/2186 is trying to acquire lock:
> [ 1424.440960]  (s_active){++++.+}, at: [<ffffffff811046b8>] sysfs_remove_dir+0x75/0x88
> [ 1424.440960]
> [ 1424.440960] but task is already holding lock:
> [ 1424.440960]  (s_active){++++.+}, at: [<ffffffff81104849>] sysfs_get_active_two+0x1f/0x46
> [ 1424.440960]
> [ 1424.440960] other info that might help us debug this:
> [ 1424.440960] 4 locks held by bash/2186:
> [ 1424.440960]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8110317f>] sysfs_write_file+0x39/0x126
> [ 1424.440960]  #1:  (s_active){++++.+}, at: [<ffffffff81104849>] sysfs_get_active_two+0x1f/0x46
> [ 1424.440960]  #2:  (s_active){++++.+}, at: [<ffffffff81104856>] sysfs_get_active_two+0x2c/0x46
> [ 1424.440960]  #3:  (&q->sysfs_lock){+.+.+.}, at: [<ffffffff8119c3f0>] queue_attr_store+0x44/0x85
> [ 1424.440960]
> [ 1424.440960] stack backtrace:
> [ 1424.440960] Pid: 2186, comm: bash Not tainted 2.6.33.3-moocow.20100429-142641 #2
> [ 1424.440960] Call Trace:
> [ 1424.440960]  [<ffffffff8105e775>] __lock_acquire+0xf9f/0x178e
> [ 1424.440960]  [<ffffffff8100d3ec>] ? save_stack_trace+0x2a/0x48
> [ 1424.440960]  [<ffffffff8105b46c>] ? lockdep_init_map+0x9f/0x52f
> [ 1424.440960]  [<ffffffff8105b46c>] ? lockdep_init_map+0x9f/0x52f
> [ 1424.440960]  [<ffffffff8105cb56>] ? trace_hardirqs_on+0xd/0xf
> [ 1424.440960]  [<ffffffff8105f02e>] lock_acquire+0xca/0xef
> [ 1424.440960]  [<ffffffff811046b8>] ? sysfs_remove_dir+0x75/0x88
> [ 1424.440960]  [<ffffffff8110458d>] sysfs_addrm_finish+0xc8/0x13a
> [ 1424.440960]  [<ffffffff811046b8>] ? sysfs_remove_dir+0x75/0x88
> [ 1424.440960]  [<ffffffff8105cb25>] ? trace_hardirqs_on_caller+0x110/0x134
> [ 1424.440960]  [<ffffffff811046b8>] sysfs_remove_dir+0x75/0x88
> [ 1424.440960]  [<ffffffff811ab312>] kobject_del+0x16/0x37
> [ 1424.440960]  [<ffffffff81195489>] elv_iosched_store+0x10a/0x214
> [ 1424.440960]  [<ffffffff8119c416>] queue_attr_store+0x6a/0x85
> [ 1424.440960]  [<ffffffff81103237>] sysfs_write_file+0xf1/0x126
> [ 1424.440960]  [<ffffffff810b747f>] vfs_write+0xae/0x14a
> [ 1424.440960]  [<ffffffff810b75df>] sys_write+0x47/0x6e
> [ 1424.440960]  [<ffffffff81002202>] system_call_fastpath+0x16/0x1b
>
> Original scheduler was cfq.
>
> Having rebooted and defaulted to noop I tried
>
> echo noop>/sys/block/vdd/queue/scheduler
>
> and got:
>
> [  311.294464] =============================================
> [  311.295820] [ INFO: possible recursive locking detected ]
> [  311.296603] 2.6.33.3-moocow.20100429-142641 #2
> [  311.296833] ---------------------------------------------
> [  311.296833] bash/2190 is trying to acquire lock:
> [  311.296833]  (s_active){++++.+}, at: [<ffffffff81104630>] remove_dir+0x31/0x39
> [  311.296833]
> [  311.296833] but task is already holding lock:
> [  311.296833]  (s_active){++++.+}, at: [<ffffffff81104849>] sysfs_get_active_two+0x1f/0x46
> [  311.296833]
> [  311.296833] other info that might help us debug this:
> [  311.296833] 4 locks held by bash/2190:
> [  311.296833]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8110317f>] sysfs_write_file+0x39/0x126
> [  311.296833]  #1:  (s_active){++++.+}, at: [<ffffffff81104849>] sysfs_get_active_two+0x1f/0x46
> [  311.296833]  #2:  (s_active){++++.+}, at: [<ffffffff81104856>] sysfs_get_active_two+0x2c/0x46
> [  311.296833]  #3:  (&q->sysfs_lock){+.+.+.}, at: [<ffffffff8119c3f0>] queue_attr_store+0x44/0x85
> [  311.296833]
> [  311.296833] stack backtrace:
> [  311.296833] Pid: 2190, comm: bash Not tainted 2.6.33.3-moocow.20100429-142641 #2
> [  311.296833] Call Trace:
> [  311.296833]  [<ffffffff8105e775>] __lock_acquire+0xf9f/0x178e
> [  311.296833]  [<ffffffff8105b46c>] ? lockdep_init_map+0x9f/0x52f
> [  311.296833]  [<ffffffff8105b46c>] ? lockdep_init_map+0x9f/0x52f
> [  311.296833]  [<ffffffff8105cb56>] ? trace_hardirqs_on+0xd/0xf
> [  311.296833]  [<ffffffff8105f02e>] lock_acquire+0xca/0xef
> [  311.296833]  [<ffffffff81104630>] ? remove_dir+0x31/0x39
> [  311.296833]  [<ffffffff8110458d>] sysfs_addrm_finish+0xc8/0x13a
> [  311.296833]  [<ffffffff81104630>] ? remove_dir+0x31/0x39
> [  311.296833]  [<ffffffff8105cb25>] ? trace_hardirqs_on_caller+0x110/0x134
> [  311.296833]  [<ffffffff81104630>] remove_dir+0x31/0x39
> [  311.296833]  [<ffffffff811046c0>] sysfs_remove_dir+0x7d/0x88
> [  311.296833]  [<ffffffff811ab312>] kobject_del+0x16/0x37
> [  311.296833]  [<ffffffff81195489>] elv_iosched_store+0x10a/0x214
> [  311.296833]  [<ffffffff8119c416>] queue_attr_store+0x6a/0x85
> [  311.296833]  [<ffffffff81103237>] sysfs_write_file+0xf1/0x126
> [  311.296833]  [<ffffffff810b747f>] vfs_write+0xae/0x14a
> [  311.296833]  [<ffffffff810b75df>] sys_write+0x47/0x6e
> [  311.296833]  [<ffffffff81002202>] system_call_fastpath+0x16/0x1b
>
> Changing back to noop (or, in the initial case to cfq) did not
> reproduce the message.
>
> This does not happen when the elevator is explicitly set on bootup as
> part of the kernel's commandline. Compiled-in default is cfq.
>
>    


-- 
error compiling committee.c: too many arguments to function

