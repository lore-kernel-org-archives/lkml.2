Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0HDEyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:54:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35997 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab0HDEyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:54:09 -0400
Date: Wed, 4 Aug 2010 14:54:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (nfs tree
 related)
Message-Id: <20100804145406.f0fc5ea4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

After merging the final tree, today's linux-next build (sparc
defconfig) failed like this:

`rpc_destroy_authunix' referenced in section `.init.text' of net/built-in.o: defined in discarded section `.exit.text' of net/built-in.o

Caused by commit 4c09a3aef02ef9bfab8322fadde269290563ede2 ("NFS: Ensure
the AUTH_UNIX credcache is allocated dynamically").

It also caused these warnings:

WARNING: vmlinux.o(.init.text+0x1e3b4): Section mismatch in reference from the f
unction rpcauth_init_module() to the function .exit.text:rpc_destroy_authunix()
The function __init rpcauth_init_module() references
a function __exit rpc_destroy_authunix().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
rpc_destroy_authunix() so it may be used outside an exit section.

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 4 Aug 2010 14:48:54 +1000
Subject: [PATCH] nfs: remove __exit from rpc_destroy_authunix

since it is referenced from an __init function.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/sunrpc/auth.h |    2 +-
 net/sunrpc/auth_unix.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
index d9d1402..652f2da 100644
--- a/include/linux/sunrpc/auth.h
+++ b/include/linux/sunrpc/auth.h
@@ -124,7 +124,7 @@ int __init		rpc_init_generic_auth(void);
 int __init		rpcauth_init_module(void);
 void __exit		rpcauth_remove_module(void);
 void __exit		rpc_destroy_generic_auth(void);
-void __exit		rpc_destroy_authunix(void);
+void			rpc_destroy_authunix(void);
 
 struct rpc_cred *	rpc_lookup_cred(void);
 struct rpc_cred *	rpc_lookup_machine_cred(void);
diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index 6385af7..4cb70dc 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -207,7 +207,7 @@ int __init rpc_init_authunix(void)
 	return rpcauth_init_credcache(&unix_auth);
 }
 
-void __exit rpc_destroy_authunix(void)
+void rpc_destroy_authunix(void)
 {
 	rpcauth_destroy_credcache(&unix_auth);
 }
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
