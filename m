Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2JUKwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 06:52:24 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:62022
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401Ab2JUKwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 06:52:14 -0400
X-IronPort-AV: E=Sophos;i="4.80,625,1344204000"; 
   d="scan'208";a="159799681"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] arch/powerpc/kernel/rtas_flash.c: eliminate possible double free
Date: Sun, 21 Oct 2012 12:52:05 +0200
Message-Id: <1350816727-1381-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1350816727-1381-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1350816727-1381-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The function initialize_flash_pde_data is only called four times.  All four
calls are in the function rtas_flash_init, and on the failure of any of the
calls, remove_flash_pde is called on the third argument of each of the
calls.  There is thus no need for initialize_flash_pde_data to call
remove_flash_pde on the same argument.  remove_flash_pde kfrees the data
field of its argument, and does not clear that field, so this amounts ot a
possible double free.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier f,free,a;
parameter list[n] ps;
type T;
expression e;
@@

f(ps,T a,...) {
  ... when any
      when != a = e
  if(...) { ... free(a); ... return ...; }
  ... when any
}

@@
identifier r.f,r.free;
expression x,a;
expression list[r.n] xs;
@@

* x = f(xs,a,...);
  if (...) { ... free(a); ... return ...; }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 arch/powerpc/kernel/rtas_flash.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index 20b0120..8329190 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -650,10 +650,8 @@ static int initialize_flash_pde_data(const char *rtas_call_name,
 	int token;
 
 	dp->data = kzalloc(buf_size, GFP_KERNEL);
-	if (dp->data == NULL) {
-		remove_flash_pde(dp);
+	if (dp->data == NULL)
 		return -ENOMEM;
-	}
 
 	/*
 	 * This code assumes that the status int is the first member of the

