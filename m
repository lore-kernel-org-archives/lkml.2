Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1GZLWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 07:22:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55256 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab1GZLWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 07:22:14 -0400
Message-ID: <4E2EA3DB.7040403@cn.fujitsu.com>
Date: Tue, 26 Jul 2011 19:24:11 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 0/11] KVM: x86: optimize for guest page written
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 19:21:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 19:21:18,
	Serialize complete at 2011-07-26 19:21:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Too keep shadow page consistency, we should write-protect the guest page if
if it is a page structure. Unfortunately, even if the guest page structure is
tear-down and is used for other usage, we still write-protect it and cause page
fault if it is written, in this case, we need to zap the corresponding shadow
page and let the guest page became normal as possible, that is just what
kvm_mmu_pte_write does, however, sometimes, it does not work well:
- kvm_mmu_pte_write is unsafe since we need to alloc pte_list_desc in the
  function when spte is prefetched, unfortunately, we can not know how many
  spte need to be prefetched on this path, that means we can use out of the
  free  pte_list_desc object in the cache, and BUG_ON() is triggered, also some
  path does not fill the cache, such as INS instruction emulated that does not
  trigger page fault.


- we usually use repeat string instructions to clear the page, for example,
  we call memset to clear a page table, 'stosb' is used in this function, and 
  repeated for 1024 times, that means we should occupy mmu lock for 1024 times
  and walking shadow page cache for 1024 times, it is terrible.

- Sometimes, we only modify the last one byte of a pte to update status bit,
  for example, clear_bit is used to clear r/w bit in linux kernel and 'andb'
  instruction is used in this function, in this case, kvm_mmu_pte_write will
  treat it as misaligned access, and the shadow page table is zapped.

- detecting write-flooding does not work well, when we handle page written, if
  the last speculative spte is not accessed, we treat the page is
  write-flooding, however, we can speculative spte on many path, such as pte
  prefetch, page synced, that means the last speculative spte may be not point
  to the written page and the written page can be accessed via other sptes, so
  depends on the Accessed bit of the last speculative spte is not enough.


In this patchset, we fixed/avoided these issues:
- instead of filling the cache in page fault path, we do it in
  kvm_mmu_pte_write, and do not prefetch the spte if it dose not have free
  pte_list_desc object in the cache.

- if it is the repeat string instructions emulated and it is not a IO/MMIO
  access, we can zap all the corresponding shadow pages and return to the guest
  then, the mapping can became writable and directly write the page

- do not zap the shadow page if it only modify the last byte of pte.

- Instead of detected page accessed, we can detect whether the spte is accessed
  or not, if the spte is not accessed but it is written frequently, we treat is
  not a page table or it not used for a long time.


Performance test result:
the performance is obvious improved tested by kernebench:

Before patchset      After patchset
3m0.094s               2m50.177s
3m1.813s               2m52.774s
3m6.239                2m51.512




