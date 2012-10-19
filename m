Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab2JSDRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:17:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:54303 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab2JSDRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 02/37] lockd: use rpc clients cl_nodename for id encoding
Date: Thu, 18 Oct 2012 20:16:25 -0700
Message-Id: <20121019031303.167008948@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019031302.789593147@linuxfoundation.org>
References: <20121019031302.789593147@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 303a7ce92064c285a04c870f2dc0192fdb2968cb upstream.

Taking hostname from uts namespace if not safe, because this cuold be
performind during umount operation on child reaper death. And in this case
current->nsproxy is NULL already.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/mon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -40,6 +40,7 @@ struct nsm_args {
 	u32			proc;
 
 	char			*mon_name;
+	char			*nodename;
 };
 
 struct nsm_res {
@@ -93,6 +94,7 @@ static int nsm_mon_unmon(struct nsm_hand
 		.vers		= 3,
 		.proc		= NLMPROC_NSM_NOTIFY,
 		.mon_name	= nsm->sm_mon_name,
+		.nodename	= utsname()->nodename,
 	};
 	struct rpc_message msg = {
 		.rpc_argp	= &args,
@@ -429,7 +431,7 @@ static void encode_my_id(struct xdr_stre
 {
 	__be32 *p;
 
-	encode_nsm_string(xdr, utsname()->nodename);
+	encode_nsm_string(xdr, argp->nodename);
 	p = xdr_reserve_space(xdr, 4 + 4 + 4);
 	*p++ = cpu_to_be32(argp->prog);
 	*p++ = cpu_to_be32(argp->vers);


