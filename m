Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966048Ab0GPQPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:15:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56693 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965990Ab0GPQPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:15:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Y/M2AYXAzdhNVZHNmaxpiQLlBC7sAFptOh2AqJmTg7SomDT62zP0ScI21sBXVlpzG/
         dT3qiLvGMBFiqOUCZSa6bj1NheygHRMKO7ZJ8ZPpuiuiaayWtkBe7fyIzZ8JvccJeFpR
         OQK7CYHH0AA+KY40wfhwcVwNK3ZY0BZEeAKW0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stefan Ringel <stefan.ringel@arcor.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/15] staging: tm6000: fix null dereference and memory leak
Date: Fri, 16 Jul 2010 20:14:49 +0400
Message-Id: <1279296889-25063-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not dereference ir_input_dev if it is NULL.

Also free ir_input_dev->input_dev on error path.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/tm6000/tm6000-input.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index 32f7a0a..5edf728 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -247,8 +247,10 @@ int tm6000_ir_init(struct tm6000_core *dev)
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	ir_input_dev = kzalloc(sizeof(*ir_input_dev), GFP_KERNEL);
+	if (!ir || !ir_input_dev)
+		goto err_out_free;
 	ir_input_dev->input_dev = input_allocate_device();
-	if (!ir || !ir_input_dev || !ir_input_dev->input_dev)
+	if (!ir_input_dev->input_dev)
 		goto err_out_free;
 
 	/* record handles to ourself */
@@ -330,6 +332,8 @@ int tm6000_ir_init(struct tm6000_core *dev)
 err_out_stop:
 	dev->ir = NULL;
 err_out_free:
+	if (ir_input_dev)
+		input_free_device(ir_input_dev->input_dev);
 	kfree(ir_input_dev);
 	kfree(ir);
 	return err;
-- 
1.7.0.4

