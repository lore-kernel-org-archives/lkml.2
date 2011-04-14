Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab1DNRrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:47:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:38480 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab1DNRrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Will Newton <will.newton@gmail.com>,
        Jeff Dike <jdike@addtoit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 091/209] uml: disable winch irq before freeing handler data
Date: Thu, 14 Apr 2011 13:42:01 -0400
Message-Id: <1302803039-9400-92-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 69e83dad5207f8f03c9699e57e1febb114383cb8 upstream.

Disable the winch irq early to make sure we don't take an interrupt part
way through the freeing of the handler data, resulting in a crash on
shutdown:

  winch_interrupt : read failed, errno = 9
  fd 13 is losing SIGWINCH support
  ------------[ cut here ]------------
  WARNING: at lib/list_debug.c:48 list_del+0xc6/0x100()
  list_del corruption, next is LIST_POISON1 (00100100)
  082578c8:  [<081fd77f>] dump_stack+0x22/0x24
  082578e0:  [<0807a18a>] warn_slowpath_common+0x5a/0x80
  08257908:  [<0807a23e>] warn_slowpath_fmt+0x2e/0x30
  08257920:  [<08172196>] list_del+0xc6/0x100
  08257940:  [<08060244>] free_winch+0x14/0x80
  08257958:  [<080606fb>] winch_interrupt+0xdb/0xe0
  08257978:  [<080a65b5>] handle_IRQ_event+0x35/0xe0
  08257998:  [<080a8717>] handle_edge_irq+0xb7/0x170
  082579bc:  [<08059bc4>] do_IRQ+0x34/0x50
  082579d4:  [<08059e1b>] sigio_handler+0x5b/0x80
  082579ec:  [<0806a374>] sig_handler_common+0x44/0xb0
  08257a68:  [<0806a538>] sig_handler+0x38/0x50
  08257a78:  [<0806a77c>] handle_signal+0x5c/0xa0
  08257a9c:  [<0806be28>] hard_handler+0x18/0x20
  08257aac:  [<00c14400>] 0xc14400

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/um/drivers/line.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 7a656bd..3aa33a7 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -728,6 +728,9 @@ struct winch {
 
 static void free_winch(struct winch *winch, int free_irq_ok)
 {
+	if (free_irq_ok)
+		free_irq(WINCH_IRQ, winch);
+
 	list_del(&winch->list);
 
 	if (winch->pid != -1)
@@ -736,8 +739,6 @@ static void free_winch(struct winch *winch, int free_irq_ok)
 		os_close_file(winch->fd);
 	if (winch->stack != 0)
 		free_stack(winch->stack, 0);
-	if (free_irq_ok)
-		free_irq(WINCH_IRQ, winch);
 	kfree(winch);
 }
 
-- 
1.7.4.4

