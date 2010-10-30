Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0J3O0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:26:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40880 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab0J3O01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=icZ2U91fOgfz5ZPlujjOGMwp6+uA0dUS57FqaprB4zoH03q0uopDvbFks9ZHJW74R1
         FLMu2MLgAU2Ue83PdDmxFvpikd8fFnjO/rO9L9v8AP+B9+tDh7CswomWOsB55LWUozqe
         UNSN7g7MJ70zWkIVlOaoO90LebZTU/zxy7EwM=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bluetooth: bnep: fix information leak to userland
Date: Sat, 30 Oct 2010 18:26:21 +0400
Message-Id: <1288448782-5582-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure bnep_conninfo is copied to userland with the field "device"
that has the last elements unitialized.  It leads to leaking of
contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 net/bluetooth/bnep/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index f10b41f..5868597 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -648,6 +648,7 @@ int bnep_del_connection(struct bnep_conndel_req *req)
 
 static void __bnep_copy_ci(struct bnep_conninfo *ci, struct bnep_session *s)
 {
+	memset(ci, 0, sizeof(*ci));
 	memcpy(ci->dst, s->eh.h_source, ETH_ALEN);
 	strcpy(ci->device, s->dev->name);
 	ci->flags = s->flags;
-- 
1.7.0.4

