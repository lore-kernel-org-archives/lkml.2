Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0J3JEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 05:04:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42409 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0J3JEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 05:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BIdR2UK4OPmVVog2pPeINJ/VWcRCDnen5x8DIwON3/uLdSYPEAUXb8CqE4+VarXjkh
         imyIdpiSSjmt3gAD2cUtzb+hyV23An9Yv8YtyDt0/EUzW9g3r6c/viZ/wWbTpQ+XAQvW
         lgwjtHtd5bVo/TUPLTb0TBfq+WNl6DW1rH7WU=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Helge Deller <deller@gmx.de>, David Howells <dhowells@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ipc: shm: fix information leak to userland
Date: Sat, 30 Oct 2010 13:04:37 +0400
Message-Id: <1288429477-21920-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure shmid_ds is copied to userland with shm_unused{,2,3}
fields unitialized.  It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 ipc/shm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index fd658a1..7d3bb22 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -479,6 +479,7 @@ static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_
 	    {
 		struct shmid_ds out;
 
+		memset(&out, 0, sizeof(out));
 		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
 		out.shm_segsz	= in->shm_segsz;
 		out.shm_atime	= in->shm_atime;
-- 
1.7.0.4

