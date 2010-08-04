Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab0HDCPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:15:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39134 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab0HDCPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:15:13 -0400
Date: Wed, 4 Aug 2010 12:15:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: linux-next: build failure after merge of the rr tree
Message-Id: <20100804121511.a9b38b0d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

After merging the rr tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/sunrpc/auth.c:74: error: 'param_ops_hashtbl_sz' undeclared here (not in a function)

Caused by commit 0685652df0929cec7d78efa85127f6eb34962132
("param:param_ops") interacting with commit
f8f853ab19fcc415b6eadd273373edc424916212 ("SUNRPC: Make the credential
cache hashtable size configurable") from the nfs tree.

I added the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 4 Aug 2010 12:11:22 +1000
Subject: [PATCH] nfs: update for module_param_named API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/sunrpc/auth.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 880d0de..36cb660 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -39,7 +39,7 @@ static LIST_HEAD(cred_unused);
 static unsigned long number_cred_unused;
 
 #define MAX_HASHTABLE_BITS (10) 
-static int param_set_hashtbl_sz(const char *val, struct kernel_param *kp)
+static int param_set_hashtbl_sz(const char *val, const struct kernel_param *kp)
 {
 	unsigned long num;
 	unsigned int nbits;
@@ -61,7 +61,7 @@ out_inval:
 	return -EINVAL;
 }
 
-static int param_get_hashtbl_sz(char *buffer, struct kernel_param *kp)
+static int param_get_hashtbl_sz(char *buffer, const struct kernel_param *kp)
 {
 	unsigned int nbits;
 
@@ -71,6 +71,11 @@ static int param_get_hashtbl_sz(char *buffer, struct kernel_param *kp)
 
 #define param_check_hashtbl_sz(name, p) __param_check(name, p, unsigned int);
 
+static struct kernel_param_ops param_ops_hashtbl_sz = {
+	.set = param_set_hashtbl_sz,
+	.get = param_get_hashtbl_sz,
+};
+
 module_param_named(auth_hashtable_size, auth_hashbits, hashtbl_sz, 0644);
 MODULE_PARM_DESC(auth_hashtable_size, "RPC credential cache hashtable size");
 
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
