Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab1KHVQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:16:51 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:59038 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab1KHVQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:16:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, len.brown@intel.com,
        tglx@linutronix.de, jeremy@goop.org, hpa@zytor.com, bp@alien8.de,
        tj@kernel.org, trenn@suse.de
Cc: mingo@redhat.com, xen-devel@lists.xensource.com
Subject: [PATCH] x86/acpi fixes for 3.2 (v1) impacting distributions.
Date: Tue,  8 Nov 2011 16:15:11 -0500
Message-Id: <1320786914-10541-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4EB99BF8.00E2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am posting three patches that are impacting distributions (both Ubuntu
and Fedora Core 16) when running the Linux v3.1 (or later) under Xen.

The first one is a regression:
 [PATCH 1/3] cpuidle: If disable_cpuidle() is called, set pm_idle to

In 3.1 we set pm_idle to something else besides the default_idle which
is not good. We want to use the default_halt as it does a yield hypercall, while
the other pm_idle do not. Worst yet, when we would migrate a guest we could
be using the wrong pm_idle code (on AMD boxes).

The two other ones are more controversial and I am not sure if the path
I had choosen is the "best" to fix the corruption problem. The "Right Way"
would be to wrap pte_flags with a pvops call, but that has serious performance
drawback implications. Ad nauseum details are in the patch:

 [PATCH 2/3] x86/cpa: Use pte_attrs instead of pte_flags on

and the last one is not that important, but nonethless if somebody is running
CONFIG_CPA_DEBUG and with a radeon or nouveau card they might get sporadic:
"CPA (x) bad PTE" messages. This patch fixes that.

 [PATCH 3/3] x86/paravirt: Use pte_val instead of pte_flags on CPA

The patches are also located in 

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-x86

 arch/x86/include/asm/pgtable.h |    5 +++++
 arch/x86/kernel/process.c      |    5 +++++
 arch/x86/mm/pageattr-test.c    |    6 +++++-
 arch/x86/mm/pageattr.c         |    2 +-
 include/linux/cpuidle.h        |    2 ++
 5 files changed, 18 insertions(+), 2 deletions(-)
