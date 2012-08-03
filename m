Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2HCMOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:14:25 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46829 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2HCMOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:14:15 -0400
From: microcai <microcai@fedoraproject.org>
To: linux-kernel@vger.kernel.org
Cc: kernel@vger.linux-kernel.cn, microcai <microcai@fedoraproject.org>
Subject: [PATCH] [ipc/shm] make shmget with IPC_PRIVATE initially created with SHM_DEST
Date: Fri,  3 Aug 2012 20:13:10 +0800
Message-Id: <1343995990-1358-1-git-send-email-microcai@fedoraproject.org>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is SysV SHM is that , it will cause kernel resource leak.
Initailly set shm  mode to SHM_DEST when create with key_t IPC_PRIVATE,
then the resource leak is fixed.

If program want the shmid live longer, they will probably use non
IPC_PRIVATE nor call shmctl that remove SHM_DEST bit.
---
 ipc/shm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 41c1285..1abc031 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -480,6 +480,8 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 
 	shp->shm_perm.key = key;
 	shp->shm_perm.mode = (shmflg & S_IRWXUGO);
+	if(key == IPC_PRIVATE)
+		shp->shm_perm.mode |= SHM_DEST;
 	shp->mlock_user = NULL;
 
 	shp->shm_perm.security = NULL;
-- 
1.7.8.6

