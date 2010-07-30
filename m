Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab0G3SlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:41:25 -0400
Received: from kroah.org ([198.145.64.141]:57850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667Ab0G3RyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:19 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:34 2010
Message-Id: <20100730175134.854667631@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <jbeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [014/205] fix mis-applied upstream commit ac9721f3f54b27a16c7e1afb2481e7ee95a70318
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Beulich <JBeulich@novell.com>

For some reason one of the changes to sys_perf_event_open() got
mis-applied, thus breaking (at least) error handling paths (pointed
out by means of a compiler warning).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4870,6 +4870,15 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (event_fd < 0)
 		return event_fd;
 
+	/*
+	 * Get the target context (task or percpu):
+	 */
+	ctx = find_get_context(pid, cpu);
+	if (IS_ERR(ctx)) {
+		err = PTR_ERR(ctx);
+		goto err_fd;
+	}
+
 	if (group_fd != -1) {
 		group_leader = perf_fget_light(group_fd, &fput_needed);
 		if (IS_ERR(group_leader)) {
@@ -4884,15 +4893,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	/*
-	 * Get the target context (task or percpu):
-	 */
-	ctx = find_get_context(pid, cpu);
-	if (IS_ERR(ctx)) {
-		err = PTR_ERR(ctx);
-		goto err_fd;
-	}
-
-	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */
 	if (group_leader) {


