Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985Ab1JFOuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 10:50:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964946Ab1JFOt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 10:49:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=aRNS/dYdzwDKHq4MBJGqJSSl1oHsh4Nnikdn8hlqIvVPdjwba17lkvSty7fPFum3z
	POptd/Knc4b/HSmvPfUOg==
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        andi@firstfloor.org, robert.richter@amd.com, ravitillo@lbl.gov
Subject: [PATCH 04/12] perf_events: sync branch stack sampling with X86 precise_sampling
Date: Thu,  6 Oct 2011 16:49:07 +0200
Message-Id: <1317912555-9559-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1317912555-9559-1-git-send-email-eranian@google.com>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If precise sampling is enabled on Intel X86, then perf_event uses PEBS.
To correct for the off-by-one error of PEBS, perf_event uses LBR when
precise_sample > 1.

On Intel X86 PERF_SAMPLE_BRANCH_STACK is implemented using LBR,
therefore both features must be coordinated as they may not
configure LBR the same way.

For PEBS, LBR needs to capture all branches at all priv levels.
This patch sets this up.

The configuration of PERF_SAMPLE_BRANCH_STACK may not be compatible
in which case an error must be returned.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6fecd36..711cbaf 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -654,6 +654,7 @@ static int x86_setup_perfctr(struct perf_event *event)
 static int x86_pmu_hw_config(struct perf_event *event)
 {
 	if (event->attr.precise_ip) {
+		u64 *br_type, br_sel;
 		int precise = 0;
 
 		/* Support for constant skid */
@@ -667,6 +668,27 @@ static int x86_pmu_hw_config(struct perf_event *event)
 
 		if (event->attr.precise_ip > precise)
 			return -EOPNOTSUPP;
+		/*
+		 * check that PEBS LBR correction does not conflict with
+		 * whatever the user is asking with attr->branch_sample_type
+		 */
+		if (event->attr.precise_ip > 1) {
+
+			br_type = &event->attr.branch_sample_type;
+
+			if (has_branch_stack(event)) {
+				br_sel = *br_type & PERF_SAMPLE_BRANCH_ANY;
+				if (br_sel != PERF_SAMPLE_BRANCH_ANY)
+					return -EOPNOTSUPP;
+			} else {
+				/*
+				 * For PEBS fixups, we capture all
+				 * the branches at all priv levels
+				 */
+				*br_type = PERF_SAMPLE_BRANCH_ANY
+					 | PERF_SAMPLE_BRANCH_PLM_ALL;
+			}
+		}
 	}
 
 	/*
-- 
1.7.4.1

