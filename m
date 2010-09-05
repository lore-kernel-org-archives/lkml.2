Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab0IELFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 07:05:32 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:59728 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0IELFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 07:05:31 -0400
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH][kernelshark] trace-graph: Fix trace_seq free-before-use
Date: Sun,  5 Sep 2010 12:05:04 +0100
Message-Id: <1283684704-5650-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e892161f731e958980fa977e2d7980f3cf0819ce changed trace_seq to
dynamically expand its buffer.  In two instances the destroy function
was called too early, causing a freed s.buffer to be used.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
 trace-graph.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/trace-graph.c b/trace-graph.c
index 44c1273..4e91fe8 100644
--- a/trace-graph.c
+++ b/trace-graph.c
@@ -1666,14 +1666,17 @@ static gint draw_event_label(struct graph_info *ginfo, gint i,
 	 */
 	ret = trace_graph_plot_display_last_event(ginfo, plot, &s,
 						  convert_x_to_time(ginfo, p2-1));
-	trace_seq_destroy(&s);
-	if (!ret)
+	if (!ret) {
+		trace_seq_destroy(&s);
 		return p2;
+	}
 
 	layout = gtk_widget_create_pango_layout(ginfo->draw, s.buffer);
 	pango_layout_set_font_description(layout, font);
 	pango_layout_get_pixel_size(layout, &text_width, &text_height);
 
+	trace_seq_destroy(&s);
+
 	/* Lets see if we can print this info */
 	if (p2 < text_width)
 		start = 1;
@@ -1967,7 +1970,6 @@ static void draw_timeline(struct graph_info *ginfo, gint width)
 		convert_nano(time, &sec, &usec);
 		trace_seq_init(&s);
 		trace_seq_printf(&s, "%lu.%06lu", sec, usec);
-		trace_seq_destroy(&s);
 
 		gdk_draw_line(ginfo->curr_pixmap, ginfo->draw->style->black_gc,
 			      mid, height, mid, height + 5);
@@ -1978,6 +1980,7 @@ static void draw_timeline(struct graph_info *ginfo, gint width)
 		gdk_draw_layout(ginfo->curr_pixmap, ginfo->draw->style->black_gc,
 				mid - (w / 2), height+10, layout);
 		g_object_unref(layout);
+		trace_seq_destroy(&s);
 	}
 }
 
-- 
1.7.1

