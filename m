Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025Ab0JGALT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 20:11:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55894 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab0JGALS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 20:11:18 -0400
Date: Wed, 6 Oct 2010 17:10:31 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>, stable@kernel.org
Subject: [PATCH] ipc: initialize structure memory to zero for shmctl
Message-ID: <20101007001031.GX14666@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old shm interface will leak a few bytes of stack contents. Explicitly
initialize the structure to zero-fill the untouched fields.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 ipc/shm.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 52ed77e..d2ee426 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -471,16 +471,17 @@ static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_
 		return copy_to_user(buf, in, sizeof(*in));
 	case IPC_OLD:
 	    {
-		struct shmid_ds out;
+		struct shmid_ds out = {
+			.shm_segsz	= in->shm_segsz,
+			.shm_atime	= in->shm_atime,
+			.shm_dtime	= in->shm_dtime,
+			.shm_ctime	= in->shm_ctime,
+			.shm_cpid	= in->shm_cpid,
+			.shm_lpid	= in->shm_lpid,
+			.shm_nattch	= in->shm_nattch,
+		};
 
 		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
-		out.shm_segsz	= in->shm_segsz;
-		out.shm_atime	= in->shm_atime;
-		out.shm_dtime	= in->shm_dtime;
-		out.shm_ctime	= in->shm_ctime;
-		out.shm_cpid	= in->shm_cpid;
-		out.shm_lpid	= in->shm_lpid;
-		out.shm_nattch	= in->shm_nattch;
 
 		return copy_to_user(buf, &out, sizeof(out));
 	    }
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
