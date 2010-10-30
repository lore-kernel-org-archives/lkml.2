Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab0J3O0y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:26:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51790 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab0J3O0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mDY8RoPKyoRg5QsODGSIbETOvBlQpnFVv1pCm/VEzzlTqzcS9mQ3qZ+JMSU9nFzbW3
         rC5LpWfTfASie86afgi9WVcb1uxON48q7etxYhXZDgA3LY8MdIpPuWWfM9cyoUnzSPba
         Y9tPMByALsCif+F+k9u4T6E5kKgTFaScWx4T8=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: core: scm: fix information leak to userland
Date: Sat, 30 Oct 2010 18:26:35 +0400
Message-Id: <1288448796-6147-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure cmsghdr is copied to userland with padding bytes
unitialized on architectures where __kernel_size_t is unsigned long.
It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 net/core/scm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index 413cab8..a4a9b70 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -233,6 +233,7 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 		msg->msg_flags |= MSG_CTRUNC;
 		cmlen = msg->msg_controllen;
 	}
+	memset(&cmhdr, 0, sizeof(cmhdr));
 	cmhdr.cmsg_level = level;
 	cmhdr.cmsg_type = type;
 	cmhdr.cmsg_len = cmlen;
-- 
1.7.0.4

