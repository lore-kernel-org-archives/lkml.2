Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab1BVIHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:07:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62184 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1BVIHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:07:33 -0500
Message-ID: <4D636EF8.60800@cn.fujitsu.com>
Date: Tue, 22 Feb 2011 16:08:24 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 0/7] KVM: optimize memslots searching and cache GPN to GFN
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:06:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:06:25,
	Serialize complete at 2011-02-22 16:06:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed paging64/32_walk_addr_generic and gfn_to_memslot are very hot in kvm
modules:

# perf report
# Events: 38K cycles
#
# Overhead          Command       Shared Object  Symbol
# ........  ...............  ..................  ......
#
     6.73%  qemu-system-x86  [kernel.kallsyms]   [k] native_read_tsc
     4.51%  qemu-system-x86  [kernel.kallsyms]   [k] delay_tsc
     3.93%  qemu-system-x86  [kvm]               [k] paging64_walk_addr_generic
     3.91%  qemu-system-x86  [kernel.kallsyms]   [k] arch_local_irq_restore
     3.28%  qemu-system-x86  [kvm_intel]         [k] vmx_vcpu_run
     3.12%  qemu-system-x86  [kernel.kallsyms]   [k] lock_acquire
     3.10%  qemu-system-x86  [kernel.kallsyms]   [k] paravirt_read_tsc
     2.70%  qemu-system-x86  [kernel.kallsyms]   [k] copy_user_generic_string
     2.30%  qemu-system-x86  [kernel.kallsyms]   [k] check_flags
     2.15%  qemu-system-x86  [kernel.kallsyms]   [k] do_raw_spin_lock
     2.03%  qemu-system-x86  [kvm]               [k] gfn_to_memslot

The aim of this patchset is to reduce the overload of these two functions, it
does:
- sort memslots by ->base_gfn and use binary search to search the right slot
  which is implemented by patch 1 ~ patch 7
- cache guest page number to frame number to reduce *_walk_addr_generic called,
  and patch 7 does it.

After the patchset:
# Events: 36K cycles
#
# Overhead          Command       Shared Object  Symbol
# ........  ...............  ..................  ......
#
     5.64%  qemu-system-x86  [kernel.kallsyms]   [k] native_read_tsc
     4.27%  qemu-system-x86  [kvm_intel]         [k] vmx_vcpu_run
     3.85%  qemu-system-x86  [kernel.kallsyms]   [k] delay_tsc
     3.32%  qemu-system-x86  [kernel.kallsyms]   [k] arch_local_irq_restore
     2.68%  qemu-system-x86  [kernel.kallsyms]   [k] paravirt_read_tsc
     2.41%  qemu-system-x86  [kernel.kallsyms]   [k] lock_acquire
     2.25%  qemu-system-x86  [kernel.kallsyms]   [k] copy_user_generic_string
     2.14%  qemu-system-x86  [kvm]               [k] kvm_mmu_pte_write
     1.82%  qemu-system-x86  [kernel.kallsyms]   [k] check_flags
     1.80%  qemu-system-x86  [kvm]               [k] paging64_walk_addr_generic
[......]
[......] 
     0.81%  qemu-system-x86  [kvm]               [k] gfn_to_memslot

There is the Unixbecn(the parameter is -c 10 fsdisk) test report:
Before patchset:
	2090.5
	1882.5
	1845.2

After vtlb patch:
	2237.4
	2151.8
	2118.0

After memslots sorted patches:
	2392.5
	2485.9
	2416.1
