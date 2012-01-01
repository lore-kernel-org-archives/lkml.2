Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab2AAHba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 02:31:30 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58079 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2AAHaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 02:30:55 -0500
From: kosaki.motohiro@gmail.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 2/2] sysvshm: SHM_LOCK use lru_add_drain_all_async()
Date: Sun,  1 Jan 2012 02:30:25 -0500
Message-Id: <1325403025-22688-2-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <CAHGf_=qA3Pnb00n_smhJVKDDCDDr0d-a3E03Rrhnb-S4xK8_fQ@mail.gmail.com>
References: <CAHGf_=qA3Pnb00n_smhJVKDDCDDr0d-a3E03Rrhnb-S4xK8_fQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

shmctl also don't need synchrounous pagevec drain. This patch replace it with
lru_add_drain_all_async().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 ipc/shm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 02ecf2c..1eb25f0 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -872,8 +872,6 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 	{
 		struct file *uninitialized_var(shm_file);
 
-		lru_add_drain_all();  /* drain pagevecs to lru lists */
-
 		shp = shm_lock_check(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
@@ -911,6 +909,8 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 			shp->mlock_user = NULL;
 		}
 		shm_unlock(shp);
+		/* prevent user visible mismatch of unevictable accounting */
+		lru_add_drain_all_async();
 		goto out;
 	}
 	case IPC_RMID:
-- 
1.7.1

