Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab2DPRUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:20:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17730 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2DPRUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:20:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] auto balloon initial domain and fix dom0_mem=X inconsistencies (v5).
Date: Mon, 16 Apr 2012 13:15:31 -0400
Message-Id: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F8C54EB.0027,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog v5 [since v4]:
 - used populate_physmap, fixed bugs.
[v2-v4: not posted]
 - reworked the code in setup.c to work properly.
[v1: https://lkml.org/lkml/2012/3/30/492]
 - initial patchset


These patches that did not change between the first posting and this one are:

      xen/p2m: Move code around to allow for better re-usage.
      xen/p2m: Allow alloc_p2m_middle to call reserve_brk depending on argument
      xen/p2m: Collapse early_alloc_p2m_middle redundant checks.
      xen/p2m: An early bootup variant of set_phys_to_machine

so if you read them before - you can skip them.

The purpose of these patches is three-fold:
 1) Fix the case where dom0_mem=X is not used and the machine boots with less
    memory than it should. A subsequent 'xl mem-set 0 X' is required to balloon up
    to the right amount. Here is an example of what it looks like with the older
    kernels and with a pvops (and the patches):

	2.6.32 SLES:
	Memory: 7538688k/8079432k available (3971k kernel code, 8192k absent, 532300k reserved, 2491k data, 348k init)
	MemTotal:        8063140 kB
	MemFree:         7421504 kB
	DirectMap4k:     8071240 kB
	Domain-0                                     0  7873     4     r-----     20.3

	3.3:
	Memory: 6486452k/9208688k available (5825k kernel code, 1136060k absent, 1586176k reserved, 2890k data, 692k init)
	MemTotal:        6716156 kB
	MemFree:         6365696 kB
	DirectMap4k:     8078192 kB
	Domain-0                                     0  6774     4     r-----     26.0

	3.3+patches:
	Memory: 7621460k/9208688k available (5817k kernel code, 1136060k absent, 451168k reserved, 2899k data, 692k init)
	MemTotal:        7849924 kB
	MemFree:         7500748 kB
	DirectMap4k:     8078192 kB
	Domain-0                                     0  7883     4     r-----     11.9

    This is implemented in:
    [PATCH 7/8] xen/setup: Populate freed MFNs from non-RAM E820 entries

 2). Fix where dom0_mem=XXXG is used (so the 'max' parameter is not involved). The
     bug is that we would ignore it:

	With dom0_mem=1G
	2.6.32 SLES:
	Memory: 650240k/1056768k available (3971k kernel code, 8192k absent, 397852k reserved, 2491k data, 348k init)
	3.3:
	Memory: 610884k/9435136k available (5817k kernel code, 1136060k absent, 7688192k reserved, 2899k data, 696k init)
	3.3+patches:
	Memory: 724184k/1053064k available (5817k kernel code, 4552k absent, 324328k reserved, 2899k data, 696k init)

   This is implemented in:
   [PATCH 6/8] xen/setup: Work properly with 'dom0_mem=X' or with not


Note, that the combination of 'dom0_mem=XXXG,max:YYYG' is perfectly fine, so there is no
need to fix that:

	With dom0_mem=1G,max:3G

	2.6.32 SLES:
	Memory: 650240k/1056768k available (3971k kernel code, 8192k absent, 397852k reserved, 2491k data, 348k init)
	3.3:
	Memory: 690324k/4281724k available (5826k kernel code, 1136060k absent, 2455340k reserved, 2891k data, 692k init)
	3.3+patches:
	Memory: 690960k/4281724k available (5824k kernel code, 1136060k absent, 2454704k reserved, 2893k data, 692k init)


Konrad Rzeszutek Wilk (8):
      xen/p2m: Move code around to allow for better re-usage.
      xen/p2m: Allow alloc_p2m_middle to call reserve_brk depending on argument
      xen/p2m: Collapse early_alloc_p2m_middle redundant checks.
      xen/p2m: An early bootup variant of set_phys_to_machine
      xen/setup: Only print "Freeing XXX-YYY pfn range: Z pages freed" if Z > 0
      xen/setup: Work properly with 'dom0_mem=X' or with not dom0_mem.
      xen/setup: Populate freed MFNs from non-RAM E820 entries and gaps to E820 RAM
      xen/setup: Combine the two hypercall functions - since they are quite similar.

 arch/x86/include/asm/xen/page.h |    1 +
 arch/x86/xen/p2m.c              |  104 ++++++++++++++++-----------
 arch/x86/xen/setup.c            |  152 +++++++++++++++++++++++++++++++++------
 3 files changed, 193 insertions(+), 64 deletions(-)
