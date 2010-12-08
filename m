Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0LHA5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:57:00 -0500
Received: from kroah.org ([198.145.64.141]:58511 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab0LHArq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:46 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:32 2010
Message-Id: <20101208004432.710416139@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Newton <will.newton@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Jeff Dike <jdike@addtoit.com>
Subject: [084/127] uml: disable winch irq before freeing handler data
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Will Newton <will.newton@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/drivers/line.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -727,6 +727,9 @@ struct winch {
 
 static void free_winch(struct winch *winch, int free_irq_ok)
 {
+	if (free_irq_ok)
+		free_irq(WINCH_IRQ, winch);
+
 	list_del(&winch->list);
 
 	if (winch->pid != -1)
@@ -735,8 +738,6 @@ static void free_winch(struct winch *win
 		os_close_file(winch->fd);
 	if (winch->stack != 0)
 		free_stack(winch->stack, 0);
-	if (free_irq_ok)
-		free_irq(WINCH_IRQ, winch);
 	kfree(winch);
 }
 


