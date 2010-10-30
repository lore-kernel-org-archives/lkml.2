Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0J3O0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:26:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40880 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab0J3O0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=T9w/cBSDClPLflX1NwxTwvmxkjmvqsP3abEIG9oLBg7GdXuHl4CR0icFu1CSiOmCdW
         zlPrmcG+Gc+JUlD3Sb1hnHgaAGx0V5cdYZ6V9782M645GGgLFh7CkmInrOpGLbvba5jh
         4y6adJ9svvjVVOnzvXvh1pvupcF72kZc/x/DQ=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
        Michael Poole <mdpoole@troilus.org>,
        Bastien Nocera <hadess@hadess.net>, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bluetooth: hidp: fix information leak to userland
Date: Sat, 30 Oct 2010 18:26:31 +0400
Message-Id: <1288448791-6009-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure hidp_conninfo is copied to userland with version, product,
vendor and name fields unitialized if both session->input and session->hid
are NULL.  It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 net/bluetooth/hidp/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index c0ee8b3..29544c2 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -107,6 +107,7 @@ static void __hidp_unlink_session(struct hidp_session *session)
 
 static void __hidp_copy_session(struct hidp_session *session, struct hidp_conninfo *ci)
 {
+	memset(ci, 0, sizeof(*ci));
 	bacpy(&ci->bdaddr, &session->bdaddr);
 
 	ci->flags = session->flags;
@@ -115,7 +116,6 @@ static void __hidp_copy_session(struct hidp_session *session, struct hidp_connin
 	ci->vendor  = 0x0000;
 	ci->product = 0x0000;
 	ci->version = 0x0000;
-	memset(ci->name, 0, 128);
 
 	if (session->input) {
 		ci->vendor  = session->input->id.vendor;
-- 
1.7.0.4

