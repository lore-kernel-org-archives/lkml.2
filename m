Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0LMP3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:29:01 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39509 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab0LMP3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tZcxFVq1AejR2NnuxOX3dWXsQh0azqim5zJE1q2W0ErA0USnGWRterKjrpxWqb16IW
         pCJVHVg9+BasN1t7Qx4me5KZOb4Kr+5ygfvJYf3x/b88GsOps+h4vx5YAlkX3ZnkT15z
         QDlnUgqIC04pwUBt3OBPsz4G5a0v3JzlrR+Z0=
From: Namhyung Kim <namhyung@gmail.com>
To: Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH] dlm: sanitize work_start() in lowcomms.c
Date: Tue, 14 Dec 2010 00:28:25 +0900
Message-Id: <1292254105-3952-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The create_workqueue() returns NULL if failed rather than ERR_PTR().
Fix error checking and remove unnecessary variable 'error'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
---
 fs/dlm/lowcomms.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 37a34c2c622a..ea04e87b8666 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1430,20 +1430,18 @@ static void work_stop(void)
 
 static int work_start(void)
 {
-	int error;
 	recv_workqueue = create_workqueue("dlm_recv");
-	error = IS_ERR(recv_workqueue);
-	if (error) {
-		log_print("can't start dlm_recv %d", error);
-		return error;
+	if (!recv_workqueue) {
+		log_print("can't start dlm_recv");
+		return -ENOMEM;
 	}
 
 	send_workqueue = create_singlethread_workqueue("dlm_send");
-	error = IS_ERR(send_workqueue);
-	if (error) {
-		log_print("can't start dlm_send %d", error);
+	if (!send_workqueue) {
+		log_print("can't start dlm_send");
 		destroy_workqueue(recv_workqueue);
-		return error;
+		recv_workqueue = NULL;
+		return -ENOMEM;
 	}
 
 	return 0;
-- 
1.7.3.3.400.g93cef

