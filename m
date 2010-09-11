Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0IKXrD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 19:47:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64985 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab0IKXqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 19:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=TdDjPGw66JOcae0+IFyzgraFUlGWDI+y5m5clAL3Yw6GlQ3S6Kc+u16qTgIG6J92R7
         xEXREJ8qzCttVGgfED2OVC8IhXB0PP6G7RyMkxC/nLSC63hX84nLBSw3meHm8CBLAt2O
         cxFVVozDIMuL0jXMoKYLgU713EgAN2LOsGhMM=
MIME-Version: 1.0
Date: Sat, 11 Sep 2010 19:46:47 -0400
Message-ID: <AANLkTindAZ4hem7OHo1ffwZcK6Ud4urp50qPFEDfhM-Z@mail.gmail.com>
Subject: [PATCH] drivers/net/eql.c: prevent reading uninitialized stack memory
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EQL_GETMASTRCFG device ioctl allows unprivileged users to read 16
bytes of uninitialized stack memory, because the "master_name" member
of the master_config_t struct declared on the stack in
eql_g_master_cfg() is not altered or zeroed before being copied back
to the user.  This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

--- linux-2.6.35.4.orig/drivers/net/eql.c	2010-09-11 19:13:04.000000000 -0400
+++ linux-2.6.35.4/drivers/net/eql.c	2010-09-11 19:17:55.000000000 -0400
@@ -555,6 +555,8 @@ static int eql_g_master_cfg(struct net_d
 	equalizer_t *eql;
 	master_config_t mc;

+	memset(&mc, 0, sizeof(master_config_t));
+
 	if (eql_is_master(dev)) {
 		eql = netdev_priv(dev);
 		mc.max_slaves = eql->max_slaves;
