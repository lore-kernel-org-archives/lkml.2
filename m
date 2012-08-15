Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2HOVd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:33:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34449 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab2HOVdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:33:20 -0400
From: Mathias Krause <minipli@googlemail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 14/14] net: fix info leak in compat dev_ifconf()
Date: Wed, 15 Aug 2012 23:31:57 +0200
Message-Id: <1345066317-22512-15-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
References: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation of dev_ifconf() for the compat ioctl interface uses
an intermediate ifc structure allocated in userland for the duration of
the syscall. Though, it fails to initialize the padding bytes inserted
for alignment and that for leaks four bytes of kernel stack. Add an
explicit memset(0) before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 net/socket.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/socket.c b/net/socket.c
index dfe5b66..a5471f8 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2657,6 +2657,7 @@ static int dev_ifconf(struct net *net, struct compat_ifconf __user *uifc32)
 	if (copy_from_user(&ifc32, uifc32, sizeof(struct compat_ifconf)))
 		return -EFAULT;
 
+	memset(&ifc, 0, sizeof(ifc));
 	if (ifc32.ifcbuf == 0) {
 		ifc32.ifc_len = 0;
 		ifc.ifc_len = 0;
-- 
1.7.10.4

