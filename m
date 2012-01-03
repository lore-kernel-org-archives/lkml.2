Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab2ACURa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:17:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:34957 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051Ab2ACUR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:17:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="91991268"
Message-Id: <cover.1325620195.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Tue, 3 Jan 2012 11:49:55 -0800
Subject: [PATCH 0/6] x86, mce: machine check recovery for applications
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds code to recognise the machine check signature for
a recoverable error in the data path (Advanced SKUs of "Sandy Bridge"
server processors are the first to be able to allow s/w recovery for
this case), save the required information in the machine check handler
and then call to the generic memory_failure() code to try for
graceful error recovery (sending SIGBUS to affected process(es)).

Updates since last version (December 15th)

Part1-4: unchanged

Part5: Changed stub function for CONFIG_MEMORY_FAILURE=n case to BUG_ON
if it is handed an MF_ACTION_REQUIRED case (this indicates an error in
severity calculation). Drop "Memory error recovered" message (enough
chatter already).

Part6: Only pass back an ACTION_REQUIRED severity to a kernel if it is built
with CONFIG_MEMORY_FAILURE=y (i.e. has the code to take the action).

Whole series is available in:

	git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-recovery

Tony Luck (6):
  HWPOISON: clean up memory_failure() vs. __memory_failure()
  HWPOISON: Add code to handle "action required" errors.
  x86, mce: create helper function to save addr/misc when needed
  x86, mce: Add mechanism to safely save information in MCE handler
  x86, mce: handle "action required" errors
  x86, mce: Recognise machine check bank signature for data path error

 arch/x86/kernel/cpu/mcheck/mce-severity.c |   16 +++-
 arch/x86/kernel/cpu/mcheck/mce.c          |  179 ++++++++++++++++++++---------
 drivers/base/memory.c                     |    2 +-
 include/linux/mm.h                        |    4 +-
 mm/hwpoison-inject.c                      |    4 +-
 mm/madvise.c                              |    2 +-
 mm/memory-failure.c                       |   96 ++++++++--------
 7 files changed, 197 insertions(+), 106 deletions(-)

-- 
1.7.3.1

