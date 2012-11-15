Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab2KOW2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:28:23 -0500
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64800 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2KOW2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:28:21 -0500
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] kernel-shark: Allow unsetting of all CPUs in filter
Date: Thu, 15 Nov 2012 14:28:18 -0800
Message-Id: <1353018498-3828-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The button "All CPUs" in CPU filter dialog allows setting of all CPUs
but doesn't clear CPUs when it is unchecked. Make sure that when the
"All CPUs" button is unchecked, all the CPUs get unchecked.

Tested: In kernelshark, go to Filter->list CPUs and uncheck "All CPUs"
button. All the CPUs should be unchecked at that point.

Change-Id: If7852cc3452177165adf78c42eb1ebc39a253e86

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 cpu.h          |   11 +++++++++++
 trace-filter.c |   37 ++++++++++++++++++++++---------------
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/cpu.h b/cpu.h
index 1c2b0d9..05c7f17 100644
--- a/cpu.h
+++ b/cpu.h
@@ -29,6 +29,17 @@ static inline int cpu_isset(guint64 *cpu_mask, gint cpu)
 	return mask & (1ULL << (cpu & ((1ULL << 6) - 1)));
 }
 
+static inline gboolean cpu_allset(guint64 *cpu_mask, gint max_cpus)
+{
+	gint cpu;
+
+	for (cpu = 0; cpu < max_cpus; cpu++) {
+		if (!cpu_isset(cpu_mask, cpu))
+			return FALSE;
+	}
+	return TRUE;
+}
+
 static inline void cpu_set(guint64 *cpu_mask, gint cpu)
 {
 	guint64 *mask;
diff --git a/trace-filter.c b/trace-filter.c
index c657a18..0d50ef9 100644
--- a/trace-filter.c
+++ b/trace-filter.c
@@ -1723,29 +1723,36 @@ void cpu_toggle(gpointer data, GtkWidget *widget)
 
 	if (strcmp(label, CPU_ALL_CPUS_STR) == 0) {
 		cpu_helper->allcpus = active;
-		if (active) {
-			/* enable all toggles */
-			for (cpu = 0; cpu < cpu_helper->cpus; cpu++)
-				gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu]),
-							     TRUE);
-		}
+		/* enable/disable all toggles */
+		for (cpu = 0; cpu < cpu_helper->cpus; cpu++)
+			gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu]),
+						     active ? TRUE : FALSE);
 		return;
 	}
 
 	/* Get the CPU # from the label. Pass "CPU " */
 	cpu = atoi(label + 4);
-	if (active) {
+	if (active)
 		cpu_set(cpu_helper->cpu_mask, cpu);
-		return;
-	}
-
-	cpu_clear(cpu_helper->cpu_mask, cpu);
-
-	if (!cpu_helper->allcpus)
-		return;
+	else
+		cpu_clear(cpu_helper->cpu_mask, cpu);
+
+	cpu_helper->allcpus = cpu_allset(cpu_helper->cpu_mask,
+					 cpu_helper->cpus);
+	/*
+	 * Deactivate sending 'toggled' signal for "All CPUs"
+	 * while we adjust its state
+	 */
+	g_signal_handlers_block_by_func(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu_helper->cpus]),
+				        G_CALLBACK (cpu_toggle),
+				        (gpointer) cpu_helper);
 
 	gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu_helper->cpus]),
-				     FALSE);
+				     cpu_helper->allcpus);
+
+	g_signal_handlers_unblock_by_func(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu_helper->cpus]),
+					  G_CALLBACK (cpu_toggle),
+					  (gpointer) cpu_helper);
 }
 
 /**
-- 
1.7.7.3

