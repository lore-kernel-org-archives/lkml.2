Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1EKCXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 22:23:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59603 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab1EKCXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 22:23:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Nm0S6U5QnbvtlZ4P2HxI7TkcQHwIINVRwsjoJztIkw1BBtTyVD/AgorasPIRwdWo+C
         DtN4i+oETf/BvYqhJXQgjg/Mv8v6XK7FpR0MieOmyhvIH39uK14zgQ/ftn4vj3bIn2x5
         vNXgW+eRc/zmIgdU4QrRINM87sRcyMC/mn45U=
MIME-Version: 1.0
Date: Wed, 11 May 2011 10:23:16 +0800
Message-ID: <BANLkTi=yWrPiz9Wp0H46at4NVfMSJ8n1uw@mail.gmail.com>
Subject: [PATCH] touchscreen: check kzalloc memory for data first
From: Steven Liu <lingjiujianke@gmail.com>
To: jy0922.shim@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, liuqi@thunderst.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonyoung Shim ,

            Can this patch be fixed in?


if kzalloc memroy for data was faild, it will multi free data
memory space. so check the data memory first, is it kzalloc faild
for data, it should goto end and do nothing.

Signed-off-by: LiuQi <lingjiujianke@gmail.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c
b/drivers/input/touchscreen/atmel_mxt_ts.c
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1039,8 +1039,15 @@ static int __devinit mxt_probe(struct i2c_client *client,
 		return -EINVAL;

 	data = kzalloc(sizeof(struct mxt_data), GFP_KERNEL);
+
+	if(!data){
+		dev_err(&client->dev, "Failed to allocate memory\n");
+		error = -ENOMEM;
+		goto err_alloc_data_mem_faild;
+	}
+
 	input_dev = input_allocate_device();
-	if (!data || !input_dev) {
+	if (!input_dev) {
 		dev_err(&client->dev, "Failed to allocate memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
@@ -1107,9 +1114,10 @@ err_free_irq:
 	free_irq(client->irq, data);
 err_free_object:
 	kfree(data->object_table);
-err_free_mem:
 	input_free_device(input_dev);
+err_free_mem:
 	kfree(data);
+err_alloc_data_mem_faild:
 	return error;
 }







Best Regards

Steven Liu
