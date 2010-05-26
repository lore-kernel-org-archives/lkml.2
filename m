Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0EZBvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:51:20 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:42954 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933282Ab0EZBvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:51:18 -0400
Date: Wed, 26 May 2010 11:51:10 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning in Linus' tree
Message-ID: <20100526015110.GA21587@gondor.apana.org.au>
References: <20100526114306.5fa6fa0e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526114306.5fa6fa0e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 11:43:06AM +1000, Stephen Rothwell wrote:
> Hi Dave,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> net/core/sock.c: In function 'sock_update_classid':
> include/net/cls_cgroup.h:42: warning: 'classid' may be used uninitialized in this function
> include/net/cls_cgroup.h:42: note: 'classid' was declared here
> 
> In the case that rcu_dereference() returns a value < 0, classid will not
> be assigned in task_cls_classid().  I don't know if this is possible - if
> not, then why is the test there?

This is a genuine bug.  I don't know why my gcc didn't warn about
it.

cls_cgroup: Initialise classid when module is absent

When the cls_cgroup module is not loaded, task_cls_classid will
return an uninitialised classid instead of zero.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index 6cf4486..726cc35 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -39,7 +39,7 @@ extern int net_cls_subsys_id;
 static inline u32 task_cls_classid(struct task_struct *p)
 {
 	int id;
-	u32 classid;
+	u32 classid = 0;
 
 	if (in_interrupt())
 		return 0;

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
