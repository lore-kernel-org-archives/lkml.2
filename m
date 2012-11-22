Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab2KVVLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:11:52 -0500
Received: from aserp1050.oracle.com ([141.146.126.70]:38817 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab2KVVLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:11:49 -0500
Message-ID: <50AE5D79.8040803@oracle.com>
Date: Thu, 22 Nov 2012 12:14:33 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121112 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Is augmented rbtree propagation broken?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michel,

I've noticed a bug regarding search of ioports in the KVM tool. Since the KVM tool is
using kernel's augmented rbtree implementation to represent an interval rbtree I dug a
bit into the new implementation in the kernel, and noticed the following odd behaviour.

Let's take a simple case where we have 2 intervals with the 3rd parameter being the
'max_high' field used by interval rbtrees: (1,2,0) , (3,4,0). Let's add them one by one:

1.		 (1,2,2)
		/	\
	     NULL	NULL

2.		 (1,2,4)
		/	\
	     NULL	(3,4,4)

On the 2nd stage we'd expect that the new (3,4) interval will be added to the right
subtree (which happens correctly), and that the insertion will be propagated to the
root of the tree to update max_high (which doesn't happen).

Basically, at stage 2, the tree we're left with is:

		 (1,2,2)
		/	\
	     NULL	(3,4,4)

Which is wrong.

I suspect that this happens because we never propagate upon insertion, which sounds
quite odd to me, but I might be missing something.

The following patch fixed the problem for me:

diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
index 214caa3..5cfdca6 100644
--- a/include/linux/rbtree_augmented.h
+++ b/include/linux/rbtree_augmented.h
@@ -47,6 +47,7 @@ rb_insert_augmented(struct rb_node *node, struct rb_root *root,
                    const struct rb_augment_callbacks *augment)
 {
        __rb_insert_augmented(node, root, augment->rotate);
+       augment->propagate(node, NULL);
 }


Thanks,
Sasha
