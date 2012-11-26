Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab2KZRCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:02:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47188 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2KZRCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 040/270] lockd: use rpc client's cl_nodename for id encoding
Date: Mon, 26 Nov 2012 14:55:30 -0200
Message-Id: <1353949160-26803-41-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 303a7ce92064c285a04c870f2dc0192fdb2968cb upstream.

Taking hostname from uts namespace if not safe, because this cuold be
performind during umount operation on child reaper death. And in this case
current->nsproxy is NULL already.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/lockd/mon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
index 7ef14b3..606a8dd 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -40,6 +40,7 @@ struct nsm_args {
 	u32			proc;
 
 	char			*mon_name;
+	char			*nodename;
 };
 
 struct nsm_res {
@@ -94,6 +95,7 @@ static int nsm_mon_unmon(struct nsm_handle *nsm, u32 proc, struct nsm_res *res,
 		.vers		= 3,
 		.proc		= NLMPROC_NSM_NOTIFY,
 		.mon_name	= nsm->sm_mon_name,
+		.nodename	= utsname()->nodename,
 	};
 	struct rpc_message msg = {
 		.rpc_argp	= &args,
@@ -430,7 +432,7 @@ static void encode_my_id(struct xdr_stream *xdr, const struct nsm_args *argp)
 {
 	__be32 *p;
 
-	encode_nsm_string(xdr, utsname()->nodename);
+	encode_nsm_string(xdr, argp->nodename);
 	p = xdr_reserve_space(xdr, 4 + 4 + 4);
 	*p++ = cpu_to_be32(argp->prog);
 	*p++ = cpu_to_be32(argp->vers);
-- 
1.7.9.5

