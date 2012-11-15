Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992617Ab2KOBsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:48:19 -0500
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49667 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992531Ab2KOBsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:48:17 -0500
From: David Sharp <dhsharp@google.com>
To: Steven Rostedt <rostedt@goodmis.net>, linux-kernel@vger.kernel.org
Cc: Venkatesh Pallipadi <venki@google.com>, David Sharp <dhsharp@google.com>
Subject: [PATCH 1/4] kernelshark: Fix bug with Plot CPU filtering
Date: Wed, 14 Nov 2012 17:48:05 -0800
Message-Id: <1352944088-21333-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venkatesh Pallipadi <venki@google.com>

Plot CPU filtering in kernelshark has the following bug:
1) Deselect CPU A from Plot CPU list
2) Plot gets updated with no CPU A
3) Deselect CPU B
4) Plot continues to have CPU B

This is due to a bug in graph_plot_cpus_update_callback(),
which seems to be checking old_all_cpus != new_all_cpus before doing any
update. This condition is true on 1, but false on 2.
Removing that check fixes the problem.

Tested:
Above sequence now does expected filtering.

Google-bug-id: 4258610
Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: David Sharp <dhsharp@google.com>
---
 trace-plot-cpu.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/trace-plot-cpu.c b/trace-plot-cpu.c
index 630d6c2..bb767d3 100644
--- a/trace-plot-cpu.c
+++ b/trace-plot-cpu.c
@@ -498,9 +498,8 @@ void graph_plot_cpus_update_callback(gboolean accept,
 	/* Get the current status */
 	graph_plot_cpus_plotted(ginfo, &old_all_cpus, &old_cpu_mask);
 
-	if (old_all_cpus == all_cpus ||
-	    (selected_cpu_mask &&
-	     cpus_equal(old_cpu_mask, selected_cpu_mask, ginfo->cpus))) {
+	if (selected_cpu_mask &&
+	     cpus_equal(old_cpu_mask, selected_cpu_mask, ginfo->cpus)) {
 		/* Nothing to do */
 		g_free(old_cpu_mask);
 		return;
-- 
1.7.7.3

