Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0IKXq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 19:46:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64985 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab0IKXqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 19:46:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=TEesCqPAJQ5W9YWVQT9+dDg9XNi5qA0NLVghS/ELgcL2BXe58lq5svMwzFEgfGhSYm
         IKLp4HkXRSirmZ1UZOG5wqgvdOx48W6r+bBAK5Ux7ERuxDXuMl3scs6WxmOqYhGCXVmn
         umux06ULvdYyjFMhgLm/bKQvi+8NNlFhSxNbE=
MIME-Version: 1.0
Date: Sat, 11 Sep 2010 19:46:38 -0400
Message-ID: <AANLkTiki4bNP83B2WEPcKnnDqHibxqYyi6V2CjiG9GEO@mail.gmail.com>
Subject: [PATCH] drivers/net/tulip/de4x5.c: prevent reading uninitialized
 stack memory
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
To: grundler@parisc-linux.org, kyle@mcmartin.ca
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DE4X5_GET_REG device ioctl allows unprivileged users to read 32
bytes of uninitialized stack memory, because it copies the
uninitialized "addr" member instead of the intended "lval" member.
This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

--- linux-2.6.35.4.orig/drivers/net/tulip/de4x5.c	2010-09-11
19:12:27.000000000 -0400
+++ linux-2.6.35.4/drivers/net/tulip/de4x5.c	2010-09-11 19:17:12.000000000 -0400
@@ -5474,7 +5474,7 @@ de4x5_ioctl(struct net_device *dev, stru
 	tmp.lval[6] = inl(DE4X5_STRR); j+=4;
 	tmp.lval[7] = inl(DE4X5_SIGR); j+=4;
 	ioc->len = j;
-	if (copy_to_user(ioc->data, tmp.addr, ioc->len)) return -EFAULT;
+	if (copy_to_user(ioc->data, tmp.lval, ioc->len)) return -EFAULT;
 	break;

 #define DE4X5_DUMP              0x0f /* Dump the DE4X5 Status */
