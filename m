Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab1FPHLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:11:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57682 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756974Ab1FPHLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:09 -0400
X-Sasl-enc: v98tNADuMLYH0p3Ks8HLb7re88753/uwVghExYS6Gmga 1308208268
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:10 2011
Message-Id: <20110616002909.937245351@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [61/85] lockdep: Fix lock_is_held() on recursion
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d upstream.

The main lock_is_held() user is lockdep_assert_held(), avoid false
assertions in lockdep_off() sections by unconditionally reporting the
lock is taken.

[ the reason this is important is a lockdep_assert_held() in ttwu()
  which triggers a warning under lockdep_off() as in printk() which
  can trigger another wakeup and lock up due to spinlock
  recursion, as reported and heroically debugged by Arne Jansen ]

Reported-and-tested-by: Arne Jansen <lists@die-jansens.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1307398759.2497.966.camel@laptop
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/lockdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3252,7 +3252,7 @@ int lock_is_held(struct lockdep_map *loc
 	int ret = 0;
 
 	if (unlikely(current->lockdep_recursion))
-		return ret;
+		return 1; /* avoid false negative lockdep_assert_held() */
 
 	raw_local_irq_save(flags);
 	check_flags(flags);


