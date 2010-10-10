Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab0JJR2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:28:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38797 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab0JJR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:28:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Djce0aqk/ny/dHk2EAoP9RrY21iuQuM7BE1/9V9cj6KGS1TCJ24vGi1bdGsP0A8QTT
         uOvPqq7I51W91UXEV2hav2eAMxQjps2nc+E0m5mPoxACZeF3zTDZzeQu0CxZORxmKG9+
         QiNZZVjy/gUQmaGz8hLRL3uDTwnbSTECaufPI=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: cpia: fix camera file owner in cpia_open()
Date: Sun, 10 Oct 2010 21:28:39 +0400
Message-Id: <1286731719-17953-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use effective UID instead of real UID for camera owner.
There is no need to check for pending signals just before successfull
return.  Exit in case of pending signal also leaved camera in open state.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/staging/cpia/cpia.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/cpia/cpia.c b/drivers/staging/cpia/cpia.c
index 933ae4c..0e740b8 100644
--- a/drivers/staging/cpia/cpia.c
+++ b/drivers/staging/cpia/cpia.c
@@ -3184,13 +3184,9 @@ static int cpia_open(struct file *file)
 		goto oops;
 	}
 
-	err = -EINTR;
-	if(signal_pending(current))
-		goto oops;
-
 	/* Set ownership of /proc/cpia/videoX to current user */
 	if(cam->proc_entry)
-		cam->proc_entry->uid = current_uid();
+		cam->proc_entry->uid = current_euid();
 
 	/* set mark for loading first frame uncompressed */
 	cam->first_frame = 1;
-- 
1.7.0.4

