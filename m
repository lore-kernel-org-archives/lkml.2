Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab1F2Xex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:34:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45463 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab1F2Xe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:34:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Sam Liao <phyomh@gmail.com>
Subject: [PATCH 6/6] perf tools: Only display parent field if explictly sorted
Date: Thu, 30 Jun 2011 01:34:08 +0200
Message-Id: <1309390448-9160-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
References: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to display the parent field if the parent
sorting machinery is only used for parent filtering
(as in "-p foo").

However if parent filtering is used in combination with
explicit parent sorting ( -s parent), we want to
display it.

Result with:

  perf report -p kernel_thread -s parent

Before:

 # Overhead  Parent symbol
 # ........  .............
 #
     0.07%
            |
            --- ioread8
                ata_sff_check_status
                ata_sff_tf_load
                ata_sff_qc_issue
                ata_bmdma_qc_issue
                ata_qc_issue
                ata_scsi_translate
                ata_scsi_queuecmd
                scsi_dispatch_cmd
                scsi_request_fn
                __blk_run_queue
                __make_request
                generic_make_request
                submit_bio
                submit_bh
                journal_submit_commit_record
                jbd2_journal_commit_transaction
                kjournald2
                kthread
                kernel_thread_helpe

After:

 # Overhead  Parent symbol
 # ........  .............
 #
     0.07%  kernel_thread_helper
            |
            --- ioread8
                ata_sff_check_status
                ata_sff_tf_load
                ata_sff_qc_issue
                ata_bmdma_qc_issue
                ata_qc_issue
                ata_scsi_translate
                ata_scsi_queuecmd
                scsi_dispatch_cmd
                scsi_request_fn
                __blk_run_queue
                __make_request
                generic_make_request
                submit_bio
                submit_bh
                journal_submit_commit_record
                jbd2_journal_commit_transaction
                kjournald2
                kthread
                kernel_thread_helper

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Sam Liao <phyomh@gmail.com>
---
 tools/perf/builtin-report.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 271e252..5d43d01 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -525,7 +525,14 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	if (parent_pattern != default_parent_pattern) {
 		if (sort_dimension__add("parent") < 0)
 			return -1;
-		sort_parent.elide = 1;
+
+		/*
+		 * Only show the parent fields if we explicitly
+		 * sort that way. If we only use parent machinery
+		 * for filtering, we don't want it.
+		 */
+		if (!strstr(sort_order, "parent"))
+			sort_parent.elide = 1;
 	} else
 		symbol_conf.exclude_other = false;
 
-- 
1.7.5.4

