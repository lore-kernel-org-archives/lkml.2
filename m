Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0LMAIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:08:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36262 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab0LLXrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:06 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: eparis@redhat.com, kaber@trash.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [124/223] netfilter: NF_HOOK_COND has wrong conditional
Message-Id: <20101212234705.D256CB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Eric Paris <eparis@redhat.com>

commit ac5aa2e3332ec04889074afdbd1479424d0227a5 upstream.

The NF_HOOK_COND returns 0 when it shouldn't due to what I believe to be an
error in the code as the order of operations is not what was intended.  C will
evalutate == before =.  Which means ret is getting set to the bool result,
rather than the return value of the function call.  The code says

if (ret = function() == 1)
when it meant to say:
if ((ret = function()) == 1)

Normally the compiler would warn, but it doesn't notice it because its
a actually complex conditional and so the wrong code is wrapped in an explict
set of () [exactly what the compiler wants you to do if this was intentional].
Fixing this means that errors when netfilter denies a packet get propagated
back up the stack rather than lost.

Problem introduced by commit 2249065f (netfilter: get rid of the grossness
in netfilter.h).

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/netfilter.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/linux/netfilter.h
===================================================================
--- linux.orig/include/linux/netfilter.h
+++ linux/include/linux/netfilter.h
@@ -215,7 +215,7 @@ NF_HOOK_COND(uint8_t pf, unsigned int ho
 	int ret;
 
 	if (!cond ||
-	    (ret = nf_hook_thresh(pf, hook, skb, in, out, okfn, INT_MIN) == 1))
+	    ((ret = nf_hook_thresh(pf, hook, skb, in, out, okfn, INT_MIN)) == 1))
 		ret = okfn(skb);
 	return ret;
 }
