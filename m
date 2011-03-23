Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1CWL7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:59:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63499 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1CWL7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MBMPKC7ZdD32XNi9Oj9UTYOeM/qu7JnOtWSfLjs9jdmwBEM4r+tneUZvnV61LPpHlm
         jDk7Oc7bNuz8vf+kwasocKDRtcn74p2pKsgSP8Z88EHDOxQ8l7WduDx/PtWA/AardcFK
         NMvbSokrfiuZ1ePgkmlg46Smw5M0Y/BxvDofE=
From: Namhyung Kim <namhyung@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Subject: [PATCH] memcg: move page-freeing code out of lock
Date: Wed, 23 Mar 2011 20:59:18 +0900
Message-Id: <1300881558-13523-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <20110323133614.95553de8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110323133614.95553de8.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move page-freeing code out of swap_cgroup_mutex in the hope that it
could reduce few of theoretical contentions between swapons and/or
swapoffs.

This is just a cleanup, no functional changes.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org
---
 mm/page_cgroup.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 29951abc852e..17eb5eb95bab 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -463,8 +463,8 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
 		/* memory shortage */
 		ctrl->map = NULL;
 		ctrl->length = 0;
-		vfree(array);
 		mutex_unlock(&swap_cgroup_mutex);
+		vfree(array);
 		goto nomem;
 	}
 	mutex_unlock(&swap_cgroup_mutex);
@@ -479,7 +479,8 @@ nomem:
 
 void swap_cgroup_swapoff(int type)
 {
-	int i;
+	struct page **map;
+	unsigned long i, length;
 	struct swap_cgroup_ctrl *ctrl;
 
 	if (!do_swap_account)
@@ -487,17 +488,20 @@ void swap_cgroup_swapoff(int type)
 
 	mutex_lock(&swap_cgroup_mutex);
 	ctrl = &swap_cgroup_ctrl[type];
-	if (ctrl->map) {
-		for (i = 0; i < ctrl->length; i++) {
-			struct page *page = ctrl->map[i];
+	map = ctrl->map;
+	length = ctrl->length;
+	ctrl->map = NULL;
+	ctrl->length = 0;
+	mutex_unlock(&swap_cgroup_mutex);
+
+	if (map) {
+		for (i = 0; i < length; i++) {
+			struct page *page = map[i];
 			if (page)
 				__free_page(page);
 		}
-		vfree(ctrl->map);
-		ctrl->map = NULL;
-		ctrl->length = 0;
+		vfree(map);
 	}
-	mutex_unlock(&swap_cgroup_mutex);
 }
 
 #endif
-- 
1.7.4

