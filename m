Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab0E0Cl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 22:41:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39997 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab0E0Cl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 22:41:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4BFDDBA9.4010702@np.css.fujitsu.com>
Date: Thu, 27 May 2010 11:40:41 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [Patch-next] Remove notify_die in do_machine_check functioin
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes do_machine_check() failure caused by DIE_NMI.

I do MCE tests on my machine. When I inject Uncorrected Error(UE) into
kernel, the messages of test failure are always gotten. This problem
is caused by the notification of DIE_NMI in the front of do_machine_check().
Because there are some notifications used DIE_NMI, and when they finish their
own work and return NOTIFY_STOP as a result. The result makes
do_machine_check() return at that time.

So we decide to delete the notification of DIE_NMI. It is because when UE error
happens, if one of the cpu is down caused by the error of hook function of
DIE_NMI, the error type of UE may be different with the real one. For example,

        CPU0                                  CPU1
UE      do_machine_check()                    do_machine_check()
        |                                     |
        cpu down(hook error of DIE_NMI)       cpu OK(no hook error of DIE_NMI)
                                              |
                                              wait CPU0 timeout
                                              |
                                              Fatal Error
                                              (Timeout synchronizing machine
                                               check over CPUs)

And I test this patch on x86_64. It works well.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 18cc425..5ed9df3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -955,9 +955,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	percpu_inc(mce_exception_count);
 
-	if (notify_die(DIE_NMI, "machine check", regs, error_code,
-			   18, SIGKILL) == NOTIFY_STOP)
-		goto out;
 	if (!banks)
 		goto out;
 
-- 
1.7.0.3

