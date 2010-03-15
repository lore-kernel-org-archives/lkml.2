Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936636Ab0COTtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:49:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936593Ab0COTth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:49:37 -0400
Date: Mon, 15 Mar 2010 20:47:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 3/6] call_usermodehelper: no need to unblock signals
Message-ID: <20100315194739.GD10896@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315194609.GA10896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315194609.GA10896@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

____call_usermodehelper() correctly calls flush_signal_handlers()
to set SIG_DFL, but sigemptyset(->blocked) and recalc_sigpending()
are not needed.

This kthread was forked by workqueue thread, all signals must be
unblocked and ignored, no pending signal is possible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/kmod.c |    3 ---
 1 file changed, 3 deletions(-)

--- 34-rc1/kernel/kmod.c~3_DONT_UNBLOCK	2010-03-15 20:10:12.000000000 +0100
+++ 34-rc1/kernel/kmod.c	2010-03-15 20:17:47.000000000 +0100
@@ -134,11 +134,8 @@ static int ____call_usermodehelper(void 
 	struct subprocess_info *sub_info = data;
 	int retval;
 
-	/* Unblock all signals */
 	spin_lock_irq(&current->sighand->siglock);
 	flush_signal_handlers(current, 1);
-	sigemptyset(&current->blocked);
-	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
 	/* We can run anywhere, unlike our parent keventd(). */

