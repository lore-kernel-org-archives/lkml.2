Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742Ab1FXPhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 11:37:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759705Ab1FXPhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 11:37:07 -0400
Date: Fri, 24 Jun 2011 17:34:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        pedro@codesourcery.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ptrace: wait_consider_task:
	s/same_thread_group/ptrace_reparented/
Message-ID: <20110624153439.GD9346@redhat.com>
References: <20110624153330.GA9346@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110624153330.GA9346@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_consider_task() checks same_thread_group(parent, real_parent),
this is the open-coded ptrace_reparented().

__ptrace_detach() remains the only function which has to check this by
hand, although we could reorganize the code to delay __ptrace_unlink.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- ptrace/kernel/exit.c~11_p_r_more_users	2011-06-23 19:11:34.000000000 +0200
+++ ptrace/kernel/exit.c	2011-06-24 17:10:07.000000000 +0200
@@ -1598,8 +1598,7 @@ static int wait_consider_task(struct wai
 		 * own children, it should create a separate process which
 		 * takes the role of real parent.
 		 */
-		if (likely(!ptrace) && p->ptrace &&
-		    same_thread_group(p->parent, p->real_parent))
+		if (likely(!ptrace) && p->ptrace && !ptrace_reparented(p))
 			return 0;
 
 		/*

