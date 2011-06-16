Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1FPHgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:36:09 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34904 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab1FPHA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:59 -0400
X-Sasl-enc: 5ERBXnNuFDCqlQbvihg40fF5j9i8fdWrnorbmoSYlazq 1308207658
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:33 2011
Message-Id: <20110616000232.900784361@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [40/89] xen: off by one errors in multicalls.c
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit f124c6ae59e193705c9ddac57684d50006d710e6 upstream.

b->args[] has MC_ARGS elements, so the comparison here should be
">=" instead of ">".  Otherwise we read past the end of the array
one space.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/multicalls.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -189,10 +189,10 @@ struct multicall_space __xen_mc_entry(si
 	unsigned argidx = roundup(b->argidx, sizeof(u64));
 
 	BUG_ON(preemptible());
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 
 	if (b->mcidx == MC_BATCH ||
-	    (argidx + args) > MC_ARGS) {
+	    (argidx + args) >= MC_ARGS) {
 		mc_stats_flush(b->mcidx == MC_BATCH ? FL_SLOTS : FL_ARGS);
 		xen_mc_flush();
 		argidx = roundup(b->argidx, sizeof(u64));
@@ -206,7 +206,7 @@ struct multicall_space __xen_mc_entry(si
 	ret.args = &b->args[argidx];
 	b->argidx = argidx + args;
 
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 	return ret;
 }
 
@@ -216,7 +216,7 @@ struct multicall_space xen_mc_extend_arg
 	struct multicall_space ret = { NULL, NULL };
 
 	BUG_ON(preemptible());
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 
 	if (b->mcidx == 0)
 		return ret;
@@ -224,14 +224,14 @@ struct multicall_space xen_mc_extend_arg
 	if (b->entries[b->mcidx - 1].op != op)
 		return ret;
 
-	if ((b->argidx + size) > MC_ARGS)
+	if ((b->argidx + size) >= MC_ARGS)
 		return ret;
 
 	ret.mc = &b->entries[b->mcidx - 1];
 	ret.args = &b->args[b->argidx];
 	b->argidx += size;
 
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 	return ret;
 }
 


