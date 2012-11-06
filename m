Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab2KFGiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 01:38:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:62431 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2KFGiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 01:38:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,721,1344236400"; 
   d="scan'208";a="164945307"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Cc: eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V3 0/7] perf, x86: Haswell LBR call stack support
Date: Tue,  6 Nov 2012 14:38:11 +0800
Message-Id: <1352183898-5601-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Haswell has a new feature that utilizes the existing Last Branch Record
facility to record call chains. When the feature is enabled, function
call will be collected as normal, but as return instructions are executed
the last captured branch record is popped from the on-chip LBR registers.
The LBR call stack facility can help perf to get call chains of progam 
without frame pointer.

The LBR call stack feature is automatic enabled when user requests sampling
user callchain. perf_callchain_user() outputs the hardware recorded call
stack in case there is no frame pointer in user program. 

The LBR call stack has following known limitations
 1. Zero length calls are not filtered out by hardware
 2. Exception handing such as setjmp/longjmp will have calls/returns not
    match
 3. Pushing different return address onto the stack will have calls/returns
    not match

The patch series depends on Andi's "perf PMU support for Haswel" patches

---
Changes since v1
 - not expose PERF_SAMPLE_BRANCH_CALL_STACK to user space
 - save/restore LBR stack on context switch for all sampling branch modes
 - reduce lbr_sel_map size

Changes since v2
 - only enable LBR call stack when user requests sampling user callchain
