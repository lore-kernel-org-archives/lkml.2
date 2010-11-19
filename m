Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab0KSWeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:34:05 -0500
Received: from kroah.org ([198.145.64.141]:44948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932534Ab0KSV6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:25 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:39 2010
Message-Id: <20101119215639.489255808@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Ingo Molnar <mingo@elte.hu>
Subject: [09/82] sched: Fix string comparison in /proc/sched_features
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 7740191cd909b75d75685fb08a5d1f54b8a9d28b upstream.

Fix incorrect handling of the following case:

 INTERACTIVE
 INTERACTIVE_SOMETHING_ELSE

The comparison only checks up to each element's length.

Changelog since v1:
 - Embellish using some Rostedtisms.
  [ mingo:                 ^^ == smaller and cleaner ]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Lindgren <tony@atomide.com>
LKML-Reference: <20100913214700.GB16118@Krystal>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -721,7 +721,7 @@ sched_feat_write(struct file *filp, cons
 		size_t cnt, loff_t *ppos)
 {
 	char buf[64];
-	char *cmp = buf;
+	char *cmp;
 	int neg = 0;
 	int i;
 
@@ -732,6 +732,7 @@ sched_feat_write(struct file *filp, cons
 		return -EFAULT;
 
 	buf[cnt] = 0;
+	cmp = strstrip(buf);
 
 	if (strncmp(buf, "NO_", 3) == 0) {
 		neg = 1;
@@ -739,9 +740,7 @@ sched_feat_write(struct file *filp, cons
 	}
 
 	for (i = 0; sched_feat_names[i]; i++) {
-		int len = strlen(sched_feat_names[i]);
-
-		if (strncmp(cmp, sched_feat_names[i], len) == 0) {
+		if (strcmp(cmp, sched_feat_names[i]) == 0) {
 			if (neg)
 				sysctl_sched_features &= ~(1UL << i);
 			else


