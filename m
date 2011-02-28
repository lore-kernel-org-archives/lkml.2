Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1B1UgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:36:03 -0500
Received: from mail09.linbit.com ([212.69.161.110]:54759 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1B1UgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:36:00 -0500
Date: Mon, 28 Feb 2011 21:35:59 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Holger Eitzenberger <holger@eitzenberger.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, stable@kernel.org
Subject: [patch] fix nla_policy_len to actually _iterate_ over the policy
Message-ID: <20110228203559.GD8906@barkeeper1-xen.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently nla_policy_len always returns n * NLA_HDRLEN:
It loops, but does not advance it's iterator.
NLA_UNSPEC == 0 does not contain a .len in any policy.

Trivially fixed by adding p++.

Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 5021cbc..ac09f22 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -148,7 +148,7 @@ nla_policy_len(const struct nla_policy *p, int n)
 {
 	int i, len = 0;
 
-	for (i = 0; i < n; i++) {
+	for (i = 0; i < n; i++, p++) {
 		if (p->len)
 			len += nla_total_size(p->len);
 		else if (nla_attr_minlen[p->type])
