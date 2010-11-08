Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0KHJEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 04:04:34 -0500
Received: from thoth.sbs.de ([192.35.17.2]:18621 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0KHJEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 04:04:33 -0500
Message-ID: <4CD7BD00.2020703@siemens.com>
Date: Mon, 08 Nov 2010 10:04:00 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: kvm <kvm@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [kvm.git & 2.6.37-rc1] KVM deadlock with CONFIG_PREEMPT host
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm seeing lock-ups of the QEMU process on kvm.git as well as current
upstream kernels. This is a backtrace of the hanging VCPU thread:

[<ffffffff810a27bc>] __stop_cpus+0x184/0x1a7
[<ffffffff810a286f>] try_stop_cpus+0x40/0x59
[<ffffffff8103a30c>] synchronize_sched_expedited+0x84/0x9d
[<ffffffff810715a3>] __synchronize_srcu+0x33/0x72
[<ffffffff810715f7>] synchronize_srcu_expedited+0x15/0x17
[<ffffffffa06602ae>] __kvm_set_memory_region+0x6a3/0x782 [kvm]
[<ffffffffa06603c4>] kvm_set_memory_region+0x37/0x50 [kvm]
[<ffffffffa0661c30>] kvm_vm_ioctl_set_memory_region+0x18/0x1a [kvm]
[<ffffffffa0661e5f>] kvm_vm_ioctl+0x22d/0x3b1 [kvm]
[<ffffffff81143c26>] do_vfs_ioctl+0x5a1/0x5e2
[<ffffffff81143cbd>] sys_ioctl+0x56/0x79
[<ffffffff81002df2>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

This issue disappears when disabling CONFIG_PREEMPT on the host.
According to some rough bisecting, it was imported into kvm.git with
merge 146d3bb06b. Given that RCU is involved, I also tried
force-enabling non-preemptible CONFIG_TREE_RCU again, but that made no
difference as long as PREEMPT is on.

Can anyone confirm this or does someone have an idea what goes wrong? Of
course, .config will be provided if required.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
