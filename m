Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab1DZCno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 22:43:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42902 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab1DZCnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 22:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QVttB1XJJ9tkhli1oKXkzUy/YCSweUvCaVVO/QLBy9WAuY/vg17ARJjwPwU/QRVl2M
         rNoXNV0ujIKlQUK3i86hzi/nI6Vf0DqUHN68q2mdvg8YLmCYfJbFCiY5f8R++/eiEEvc
         fIAuhDOVJ083iduk7HECfo4/HeB9u0QGYqOkY=
Date: Tue, 26 Apr 2011 10:54:29 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] use oom_killer_disabled in all oom pathes
Message-ID: <20110426025429.GA11812@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oom_killer_disable should be a global switch, also fit for oom paths
other than __alloc_pages_slowpath 

Here add it to mem_cgroup_handle_oom and pagefault_out_of_memory as well.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 mm/memcontrol.c |    2 +-
 mm/oom_kill.c   |    3 +++

 2 files changed, 4 insertions(+), 1 deletion(-)
--- linux-2.6.orig/mm/memcontrol.c	2011-04-20 15:49:10.336660690 +0800
+++ linux-2.6/mm/memcontrol.c	2011-04-26 10:41:04.746459757 +0800
@@ -1610,7 +1610,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	 * under OOM is always welcomed, use TASK_KILLABLE here.
 	 */
 	prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
-	if (!locked || mem->oom_kill_disable)
+	if (!locked || mem->oom_kill_disable || oom_killer_disabled)
 		need_to_kill = false;
 	if (locked)
 		mem_cgroup_oom_notify(mem);
--- linux-2.6.orig/mm/oom_kill.c	2011-04-20 15:49:10.353327356 +0800
+++ linux-2.6/mm/oom_kill.c	2011-04-26 10:41:04.753126423 +0800
@@ -747,6 +747,9 @@ out:
  */
 void pagefault_out_of_memory(void)
 {
+	if (oom_killer_disabled)
+		return;
+
 	if (try_set_system_oom()) {
 		out_of_memory(NULL, 0, 0, NULL);
 		clear_system_oom();
