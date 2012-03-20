Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030746Ab2CTQbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:31:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53096 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab2CTQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:31:21 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] arm: fault.c: correct how the tsk->[maj|min]_flt gets incremented
Date: Tue, 20 Mar 2012 12:30:57 -0400
Message-Id: <1332261057-2399-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8878a539ff19a43cf3729e7562cd528f490246ae was done by me
to make the page fault handler retryable as well as interruptible.

Due to this commit, there is a mistake in the way in which
tsk->[maj|min]_flt counter gets incremented for VM_FAULT_ERROR:
If VM_FAULT_ERROR is returned in the fault flags by handle_mm_fault,
then either maj_flt or min_flt will get incremented. This is wrong
as in the case of a VM_FAULT_ERROR we need to be skip ahead to the
error handling code in do_page_fault.

Added a check after the call to __do_page_fault() to check for
(fault & VM_FAULT_ERROR).

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 arch/arm/mm/fault.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index bb7eac3..ec8c88b 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -318,7 +318,7 @@ retry:
 	 */
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+	if (!(fault & VM_FAULT_ERROR) && (flags & FAULT_FLAG_ALLOW_RETRY)) {
 		if (fault & VM_FAULT_MAJOR) {
 			tsk->maj_flt++;
 			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
-- 
1.7.5.4

