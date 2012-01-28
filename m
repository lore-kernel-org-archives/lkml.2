Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2A1Pdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:33:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab2A1Pc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:32:59 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv2 16/16] edac: Add an error scope logic
Date: Sat, 28 Jan 2012 13:32:51 -0200
Message-Id: <1327764771-28649-17-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
References: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is currently incomplete, but the idea here is to
change the EDAC error calls to handle a scope var, that will
be used when providing the error traces to userspace, and
to increment a per-location counter.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/linux/edac.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/edac.h b/include/linux/edac.h
index 5876675..879116e 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -72,6 +72,33 @@ enum hw_event_mc_err_type {
 	HW_EVENT_ERR_FATAL,
 };
 
+/**
+ * enum hw_event_error_scope - escope of a memory error
+ * @HW_EVENT_ERR_MC:		error can be anywhere inside the MC
+ * @HW_EVENT_SCOPE_MC_BRANCH:	error can be on any DIMM inside the branch
+ * @HW_EVENT_SCOPE_MC_CHANNEL:	error can be on any DIMM inside the MC channel
+ * @HW_EVENT_SCOPE_MC_CSROW:	error can be on any DIMM inside the csrow
+ * @HW_EVENT_SCOPE_MC_DIMM:	error is on a specific DIMM
+ *
+ * Depending on the error detection algorithm, the memory topology and even
+ * the MC capabilities, some errors can't be attributed to just one DIMM, but
+ * to a group of memory sockets. Depending on where the error occurs, the
+ * EDAC core will increment the corresponding error count for that entity,
+ * and the upper entities. For example, assuming a system with 1 memory
+ * controller 2 branches, 2 MC channels and 4 DIMMS on it, if an error
+ * happens at channel 0, the error counts for channel 0, for branch 0 and
+ * for the memory controller 0 will be incremented. The DIMM error counts won't
+ * be incremented, as, in this example, the driver can't be 100% sure on what
+ * memory the error actually occurred.
+ */
+enum hw_event_error_scope {
+	HW_EVENT_SCOPE_MC,
+	HW_EVENT_SCOPE_MC_BRANCH,
+	HW_EVENT_SCOPE_MC_CHANNEL,
+	HW_EVENT_SCOPE_MC_CSROW,
+	HW_EVENT_SCOPE_MC_CSROW_CHANNEL,
+};
+
 /* memory types */
 enum mem_type {
 	MEM_EMPTY = 0,		/* Empty csrow */
-- 
1.7.8

