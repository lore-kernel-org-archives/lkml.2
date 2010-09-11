Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab0IKXrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 19:47:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64985 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab0IKXqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 19:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=vWQPKd3pDD0E1RZrxxDFPMsBadn4UtrncunOf8lbOwNOGqr/4tEMY7cGh68bw4wguV
         XGdIJbohpNAFDJ34GR/p7SJC5ecDjy7kgqvYClgqhAlRuYxhiTaaspyGlwqV8R28x6eg
         FlnQTNiDM5odDabRECNNcIkuKOiSMT74dybdc=
MIME-Version: 1.0
Date: Sat, 11 Sep 2010 19:46:43 -0400
Message-ID: <AANLkTimR48NwOCgB81RhNbCz=YzZmcCcyb0qsYg_dHuq@mail.gmail.com>
Subject: [PATCH] drivers/net/cxgb3/cxgb3_main.c: prevent reading uninitialized
 stack memory
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
To: divy@chelsio.com
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CHELSIO_GET_QSET_NUM device ioctl allows unprivileged users to
read 4 bytes of uninitialized stack memory, because the "addr" member
of the ch_reg struct declared on the stack in cxgb_extension_ioctl()
is not altered or zeroed before being copied back to the user.  This
patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

--- linux-2.6.35.4.orig/drivers/net/cxgb3/cxgb3_main.c	2010-09-11
19:12:43.000000000 -0400
+++ linux-2.6.35.4/drivers/net/cxgb3/cxgb3_main.c	2010-09-11
19:18:42.000000000 -0400
@@ -2296,6 +2296,8 @@ static int cxgb_extension_ioctl(struct n
 	case CHELSIO_GET_QSET_NUM:{
 		struct ch_reg edata;

+		memset(&edata, 0, sizeof(struct ch_reg));
+
 		edata.cmd = CHELSIO_GET_QSET_NUM;
 		edata.val = pi->nqsets;
 		if (copy_to_user(useraddr, &edata, sizeof(edata)))
