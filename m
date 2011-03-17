Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab1CQSJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:09:31 -0400
Received: from fieldses.org ([174.143.236.118]:52986 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927Ab1CQSJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:09:29 -0400
Date: Thu, 17 Mar 2011 14:09:28 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the nfsd tree
Message-ID: <20110317180928.GF30180@fieldses.org>
References: <20110310115331.10a95d57.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310115331.10a95d57.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 11:53:31AM +1100, Stephen Rothwell wrote:
> Hi Bruce,
> 
> After merging the nfsd tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> net/sunrpc/svcauth_unix.c: In function 'unix_domain_find':
> net/sunrpc/svcauth_unix.c:58: warning: passing argument 1 of 'svcauth_unix_domain_release' from incompatible pointer type
> net/sunrpc/svcauth_unix.c:41: note: expected 'struct auth_domain *' but argument is of type 'struct unix_domain *'
> 
> Introduced by commit 8b3e07ac908d ("svcrpc: fix rare race on unix_domain
> creation").

Should be fixed, thanks for the report.

--b.

commit 352b5d13c0684ba8cd103aa20cb74f105334562a
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Wed Mar 9 22:40:30 2011 -0500

    svcrpc: fix bad argument in unix_domain_find
    
    "After merging the nfsd tree, today's linux-next build (powerpc
    ppc64_defconfig) produced this warning:
    
    net/sunrpc/svcauth_unix.c: In function 'unix_domain_find':
    net/sunrpc/svcauth_unix.c:58: warning: passing argument 1 of
    +'svcauth_unix_domain_release' from incompatible pointer type
    net/sunrpc/svcauth_unix.c:41: note: expected 'struct auth_domain *' but
    argument
    +is of type 'struct unix_domain *'
    
    Introduced by commit 8b3e07ac908d ("svcrpc: fix rare race on unix_domain
    creation")."
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index d100bf2..c8e1021 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -55,7 +55,7 @@ struct auth_domain *unix_domain_find(char *name)
 	while(1) {
 		if (rv) {
 			if (new && rv != &new->h)
-				svcauth_unix_domain_release(new);
+				svcauth_unix_domain_release(&new->h);
 
 			if (rv->flavour != &svcauth_unix) {
 				auth_domain_put(rv);
