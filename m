Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076Ab2B1BIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:08:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965060Ab2B1BIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:08:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.194.8 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010430.922187212@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 17/72] NFSv4: fix server_scope memory leak
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@netapp.com>

commit abe9a6d57b4544ac208401f9c0a4262814db2be4 upstream.

server_scope would never be freed if nfs4_check_cl_exchange_flags() returned
non-zero

Signed-off-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4876,8 +4876,10 @@ int nfs4_proc_exchange_id(struct nfs_cli
 				clp->cl_rpcclient->cl_auth->au_flavor);
 
 	res.server_scope = kzalloc(sizeof(struct server_scope), GFP_KERNEL);
-	if (unlikely(!res.server_scope))
-		return -ENOMEM;
+	if (unlikely(!res.server_scope)) {
+		status = -ENOMEM;
+		goto out;
+	}
 
 	status = rpc_call_sync(clp->cl_rpcclient, &msg, RPC_TASK_TIMEOUT);
 	if (!status)
@@ -4894,12 +4896,13 @@ int nfs4_proc_exchange_id(struct nfs_cli
 			clp->server_scope = NULL;
 		}
 
-		if (!clp->server_scope)
+		if (!clp->server_scope) {
 			clp->server_scope = res.server_scope;
-		else
-			kfree(res.server_scope);
+			goto out;
+		}
 	}
-
+	kfree(res.server_scope);
+out:
 	dprintk("<-- %s status= %d\n", __func__, status);
 	return status;
 }


