Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab2DMKFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:05:43 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:55895 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2DMKFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:05:41 -0400
Message-ID: <4F87FA69.5060106@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:05:29 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 00/16] KVM: MMU: fast page fault
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041310-2000-0000-0000-0000071A2DC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for Avi and Marcelo's review, i have simplified the whole things
in this version:
- it only fix the page fault with PFEC.P = 1 && PFEC.W = 0 that means
  unlock set_spte path can be dropped.

- it only fixes the page fault caused by dirty-log

In this version, all the information we need is from spte, the
SPTE_ALLOW_WRITE bit and SPTE_WRITE_PROTECT bit:
   - SPTE_ALLOW_WRITE is set if the gpte is writable and the pfn pointed
     by the spte is writable on host.
   - SPTE_WRITE_PROTECT is set if the spte is write-protected by shadow
     page table protection.

All these bits can be protected by cmpxchg, now, all the things is fairly
simple than before. :)

Performance test:

autotest migration:
(Host: Intel(R) Xeon(R) CPU           X5690  @ 3.47GHz * 12 + 32G)

- For ept:

Before:
                    smp2.Fedora.16.64.migrate
Times   .unix      .with_autotest.dbench.unix     total
 1       104           214                         323
 2       68            238                         310
 3       68            242                         314

After:
                    smp2.Fedora.16.64.migrate
Times   .unix      .with_autotest.dbench.unix     total
 1       101           190                         295
 2       67            188                         259
 3       66            217                         289


- For shadow mmu:

Before:
                    smp2.Fedora.16.64.migrate
Times   .unix      .with_autotest.dbench.unix     total
 1       103           235                         342
 2       64            219                         286
 3       68            234                         305

After:
                    smp2.Fedora.16.64.migrate
Times   .unix      .with_autotest.dbench.unix     total
 1       104           220                         328
 2       65            204                         273
 3       64            219                         286

