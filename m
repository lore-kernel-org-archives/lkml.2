Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1LNBOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 20:14:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38835 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab1LNBOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 20:14:03 -0500
X-Authority-Analysis: v=2.0 cv=HeWWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Sq825YaR5YAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=LjNjP9thxtKzdCPQ4CgA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323825240.23971.11.camel@gandalf.stny.rr.com>
Subject: [RFC][PATCH] writeback: Unduplicate writeback reason
From: Steven Rostedt <rostedt@goodmis.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Curt Wohlgemuth <curtw@google.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Dec 2011 20:14:00 -0500
In-Reply-To: <20111214003150.GA14520@localhost>
References: <20111214003150.GA14520@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Names of the writeback reasons are used in both the main kernel as well
as for parsing the tracepoint format file. Instead of duplicating the
names in two locations making it likely that they may become out of
sync, use some macro magic to make sure all the names stay in sync. Any
update only needs to happen in one spot for it to take place in all
locations.

Note, this is an RFC patch, and it probably needs much better comments
(well, it currently has no comments), and the C() macro probably should
have a different name too.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/fs/fs-writeback.c
===================================================================
--- linux-trace.git.orig/fs/fs-writeback.c
+++ linux-trace.git/fs/fs-writeback.c
@@ -47,15 +47,10 @@ struct wb_writeback_work {
 	struct completion *done;	/* set if the caller waits */
 };
 
+#undef C
+#define C(a, b) [a] = b
 const char *wb_reason_name[] = {
-	[WB_REASON_BACKGROUND]		= "background",
-	[WB_REASON_TRY_TO_FREE_PAGES]	= "try_to_free_pages",
-	[WB_REASON_SYNC]		= "sync",
-	[WB_REASON_PERIODIC]		= "periodic",
-	[WB_REASON_LAPTOP_TIMER]	= "laptop_timer",
-	[WB_REASON_FREE_MORE_MEM]	= "free_more_memory",
-	[WB_REASON_FS_FREE_SPACE]	= "fs_free_space",
-	[WB_REASON_FORKER_THREAD]	= "forker_thread"
+	WB_ENUM_REASONS
 };
 
 /*
Index: linux-trace.git/include/linux/writeback.h
===================================================================
--- linux-trace.git.orig/include/linux/writeback.h
+++ linux-trace.git/include/linux/writeback.h
@@ -38,21 +38,23 @@ enum writeback_sync_modes {
 	WB_SYNC_ALL,	/* Wait on every mapping */
 };
 
+#define WB_ENUM_REASONS							\
+		C(WB_REASON_BACKGROUND,		"background"),		\
+		C(WB_REASON_TRY_TO_FREE_PAGES,	"try_to_free_pages"),	\
+		C(WB_REASON_SYNC,		"sync"),		\
+		C(WB_REASON_PERIODIC,		"periodic"),		\
+		C(WB_REASON_LAPTOP_TIMER,	"laptop_timer"),	\
+		C(WB_REASON_FREE_MORE_MEM,	"free_more_memory"),	\
+		C(WB_REASON_FS_FREE_SPACE,	"fs_free_space"),	\
+		C(WB_REASON_FORKER_THREAD,	"forker_thread")
+
 /*
  * why some writeback work was initiated
  */
-enum wb_reason {
-	WB_REASON_BACKGROUND,
-	WB_REASON_TRY_TO_FREE_PAGES,
-	WB_REASON_SYNC,
-	WB_REASON_PERIODIC,
-	WB_REASON_LAPTOP_TIMER,
-	WB_REASON_FREE_MORE_MEM,
-	WB_REASON_FS_FREE_SPACE,
-	WB_REASON_FORKER_THREAD,
+#undef C
+#define C(a, b) a
+enum wb_reason { WB_ENUM_REASONS, WB_REASONS_MAX };
 
-	WB_REASON_MAX,
-};
 extern const char *wb_reason_name[];
 
 /*
Index: linux-trace.git/include/trace/events/writeback.h
===================================================================
--- linux-trace.git.orig/include/trace/events/writeback.h
+++ linux-trace.git/include/trace/events/writeback.h
@@ -21,16 +21,11 @@
 		{I_REFERENCED,		"I_REFERENCED"}		\
 	)
 
+#undef C
+#define C(a, b) {a, b}
 #define show_work_reason(reason)					\
 	__print_symbolic(reason,					\
-		{WB_REASON_BACKGROUND,		"background"},		\
-		{WB_REASON_TRY_TO_FREE_PAGES,	"try_to_free_pages"},	\
-		{WB_REASON_SYNC,		"sync"},		\
-		{WB_REASON_PERIODIC,		"periodic"},		\
-		{WB_REASON_LAPTOP_TIMER,	"laptop_timer"},	\
-		{WB_REASON_FREE_MORE_MEM,	"free_more_memory"},	\
-		{WB_REASON_FS_FREE_SPACE,	"fs_free_space"},	\
-		{WB_REASON_FORKER_THREAD,	"forker_thread"}	\
+			 WB_ENUM_REASONS				\
 	)
 
 struct wb_writeback_work;


