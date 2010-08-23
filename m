Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0HWKWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab0HWKW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:22:26 -0400
Message-ID: <4C724BDB.8020604@redhat.com>
Date: Mon, 23 Aug 2010 13:22:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4 v2] kvm: rework KVM mmu_shrink() code
References: <20100820011054.GA11297@tpepper-t61p.dolavim.us>
In-Reply-To: <20100820011054.GA11297@tpepper-t61p.dolavim.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/20/2010 04:10 AM, Tim Pepper wrote:
> The following series is the four patches Dave Hansen had queued for test
> as mentioned last week in the thread:
>    "[PATCH] kvm: make mmu_shrink() fit shrinker's requirement"
> Last week just before leaving for vacation Dave had noted in that thread
> that these four were ready to merge based on our perf team's testing
> finally having wrapped up.  But it turns out he hadn't actually posted
> them after refactoring in response to comments back in June...
>
> I'm covering for him in his absence and had previously reviewed this set.
> This version contains fixes in response to the comments in June.  The
> patches are pulled straight from Dave's development tree, as tested, with
> a minor build/merge change to patch #3 which was otherwise inadvertantly
> re-introducing an (unused) variable that Avi more recently had removed.
>
> Compared to the previous version from June:
> - patch #3 addresses Marcelo's comment about a double deaccounting
>    of kvm->arch.n_used_mmu_pages
> - patch #4 includes protection of the used mmu page counts in response to
>    Avi's comments
>
> Avi: if Dave's use of a per cpu counter in the refactored patch #4 is
> acceptable to you, then the series is for merging.
>

I see a lot of soft lockups with this patchset:


BUG: soft lockup - CPU#0 stuck for 61s! [qemu:1917]
Modules linked in: netconsole configfs p4_clockmod freq_table 
speedstep_lib kvm_intel kvm e1000e i2c_i801 i2c_core microcode serio_raw 
[last unloaded: mperf]
CPU 0
Modules linked in: netconsole configfs p4_clockmod freq_table 
speedstep_lib kvm_intel kvm e1000e i2c_i801 i2c_core microcode serio_raw 
[last unloaded: mperf]

Pid: 1917, comm: qemu Not tainted 2.6.35 #253 
TYAN-Tempest-i5000VS-S5372/TYAN Transport GT20-B5372
RIP: 0010:[<ffffffffa007c1cd>]  [<ffffffffa007c1cd>] 
kvm_mmu_prepare_zap_page+0xb7/0x262 [kvm]
RSP: 0018:ffff880129c8dab8  EFLAGS: 00000202
RAX: fffffffffffff001 RBX: ffff880129c8daf8 RCX: ffff880128cd0278
RDX: fffffffffffff001 RSI: ffff88012a2a7140 RDI: ffff880128cd0000
RBP: ffffffff8100a40e R08: 0000000000000004 R09: 0000000000000004
R10: dead000000100100 R11: ffffffffa0067422 R12: 0000000000000010
R13: ffffffff813a0246 R14: ffffffffffffff10 R15: ffff880128cd0004
FS:  00007f9901018710(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000123400000000 CR3: 0000000128cf1000 CR4: 00000000000026f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process qemu (pid: 1917, threadinfo ffff880129c8c000, task ffff88012a0dc530)
Stack:
  ffff880129c8db08 000000ad2a2a7140 ffff880128cd0000 ffff8801287bc000
<0> ffff880129c8db08 0000000000000002 0000000000000000 0000000000000001
<0> ffff880129c8db28 ffffffffa007ca37 ffff88010893b3c0 ffff88012a2a7be0
Call Trace:
  [<ffffffffa007ca37>] ? __kvm_mmu_free_some_pages+0x2b/0x6a [kvm]
  [<ffffffffa007ca93>] ? kvm_mmu_free_some_pages+0x1d/0x1f [kvm]
  [<ffffffffa0080e81>] ? paging64_page_fault+0x18c/0x1c3 [kvm]
  [<ffffffffa007d427>] ? reset_rsvds_bits_mask+0x12/0x150 [kvm]
  [<ffffffffa007d70e>] ? init_kvm_mmu+0x1a9/0x33b [kvm]
  [<ffffffffa007d8cf>] ? kvm_mmu_reset_context+0x24/0x28 [kvm]
  [<ffffffffa0074e00>] ? emulate_instruction+0x291/0x2db [kvm]
  [<ffffffffa008108c>] ? kvm_mmu_page_fault+0x1a/0x70 [kvm]
  [<ffffffffa00bfff8>] ? handle_exception+0x191/0x2ec [kvm_intel]
  [<ffffffffa00c0328>] ? vmx_handle_exit+0x1d5/0x207 [kvm_intel]
  [<ffffffffa007674c>] ? kvm_arch_vcpu_ioctl_run+0x861/0xb09 [kvm]
  [<ffffffffa0075834>] ? kvm_arch_vcpu_load+0x86/0xd2 [kvm]
  [<ffffffffa0069c8a>] ? kvm_vcpu_ioctl+0x10d/0x4eb [kvm]
  [<ffffffff810f9b3a>] ? do_sync_write+0xc6/0x103
  [<ffffffff810c1f7d>] ? lru_cache_add_lru+0x22/0x24
  [<ffffffff811061fb>] ? vfs_ioctl+0x2d/0xa1
  [<ffffffff8110674e>] ? do_vfs_ioctl+0x468/0x4a1
  [<ffffffff810f9925>] ? fsnotify_modify+0x67/0x6f
  [<ffffffff811067c9>] ? sys_ioctl+0x42/0x65
  [<ffffffff81009a42>] ? system_call_fastpath+0x16/0x1b

Something's wrong, probably some variable went negative.

-- 
error compiling committee.c: too many arguments to function

