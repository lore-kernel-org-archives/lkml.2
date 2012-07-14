Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2GNQoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 12:44:20 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:31940
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127Ab2GNQnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 12:43:24 -0400
X-IronPort-AV: E=Sophos;i="4.77,584,1336341600"; 
   d="scan'208";a="150655457"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 4/6] drivers/cpuidle/sysfs.c: ensure a consistent return value in error case
Date: Sat, 14 Jul 2012 18:43:06 +0200
Message-Id: <1342284188-19176-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1342284188-19176-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1342284188-19176-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Typically, the return value desired for the failure of a function with an
integer return value is a negative integer.  In these cases, the return
value is sometimes a negative integer and sometimes 0, due to a subsequent
initialization of the return variable within the loop.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

//<smpl>
@r exists@
identifier ret;
position p;
constant C;
expression e1,e3,e4;
statement S;
@@

ret = -C
... when != ret = e3
    when any
if@p (...) S
... when any
if (\(ret != 0\|ret < 0\|ret > 0\) || ...) { ... return ...; }
... when != ret = e3
    when any
*if@p (...)
{
  ... when != ret = e4
  return ret;
}
//</smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/cpuidle/sysfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 5f809e3..06df57c 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -361,15 +361,17 @@ static inline void cpuidle_free_state_kobj(struct cpuidle_device *device, int i)
  */
 int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 {
-	int i, ret = -ENOMEM;
+	int i, ret;
 	struct cpuidle_state_kobj *kobj;
 	struct cpuidle_driver *drv = cpuidle_get_driver();
 
 	/* state statistics */
 	for (i = 0; i < device->state_count; i++) {
 		kobj = kzalloc(sizeof(struct cpuidle_state_kobj), GFP_KERNEL);
-		if (!kobj)
+		if (!kobj) {
+			ret = -ENOMEM;
 			goto error_state;
+		}
 		kobj->state = &drv->states[i];
 		kobj->state_usage = &device->states_usage[i];
 		init_completion(&kobj->kobj_unregister);

