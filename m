Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0C2Jj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:39:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54410 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0C2JjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:39:25 -0400
Date: Mon, 29 Mar 2010 11:39:22 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/macintosh: Correct potential double free
Message-ID: <Pine.LNX.4.64.1003291138520.21896@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The conditionals were testing different values, but then all freeing the
same one, which could result in a double free.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,e;
identifier f;
iterator I;
statement S;
@@

*kfree(x);
... when != &x
    when != x = e
    when != I(x,...) S
*x
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/macintosh/windfarm_pm91.c   |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/macintosh/windfarm_pm91.c b/drivers/macintosh/windfarm_pm91.c
index bea9916..3442732 100644
--- a/drivers/macintosh/windfarm_pm91.c
+++ b/drivers/macintosh/windfarm_pm91.c
@@ -687,12 +687,9 @@ static int __devexit wf_smu_remove(struct platform_device *ddev)
 		wf_put_control(cpufreq_clamp);
 
 	/* Destroy control loops state structures */
-	if (wf_smu_slots_fans)
-		kfree(wf_smu_cpu_fans);
-	if (wf_smu_drive_fans)
-		kfree(wf_smu_cpu_fans);
-	if (wf_smu_cpu_fans)
-		kfree(wf_smu_cpu_fans);
+	kfree(wf_smu_slots_fans);
+	kfree(wf_smu_drive_fans);
+	kfree(wf_smu_cpu_fans);
 
 	return 0;
 }
