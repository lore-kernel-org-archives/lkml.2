Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1CJX5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:57:34 -0500
Received: from kroah.org ([198.145.64.141]:46895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab1CJX52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:38 2011
Message-Id: <20110310235538.006843870@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [patch 20/29] netfilter: arpt_mangle: fix return values of checkentry
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 9d0db8b6b1da9e3d4c696ef29449700c58d589db upstream.

In 135367b "netfilter: xtables: change xt_target.checkentry return type",
the type returned by checkentry was changed from boolean to int, but the
return values where not adjusted.

arptables: Input/output error

This broke arptables with the mangle target since it returns true
under success, which is interpreted by xtables as >0, thus
returning EIO.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/arpt_mangle.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -60,12 +60,12 @@ static int checkentry(const struct xt_tg
 
 	if (mangle->flags & ~ARPT_MANGLE_MASK ||
 	    !(mangle->flags & ARPT_MANGLE_MASK))
-		return false;
+		return -EINVAL;
 
 	if (mangle->target != NF_DROP && mangle->target != NF_ACCEPT &&
 	   mangle->target != XT_CONTINUE)
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static struct xt_target arpt_mangle_reg __read_mostly = {


