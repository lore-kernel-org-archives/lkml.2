Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987Ab2JAXVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:21:49 -0400
Received: from 1wt.eu ([62.212.114.60]:35371 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932887Ab2JAXB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:29 -0400
Message-Id: <20121001225204.097102622@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jason Baron <jbaron@redhat.com>, Nelson Elhage <nelhage@nelhage.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 153/180] epoll: clear the tfile_check_list on -ELOOP
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Baron <jbaron@redhat.com>

commit 13d518074a952d33d47c428419693f63389547e9 upstream.

An epoll_ctl(,EPOLL_CTL_ADD,,) operation can return '-ELOOP' to prevent
circular epoll dependencies from being created.  However, in that case we
do not properly clear the 'tfile_check_list'.  Thus, add a call to
clear_tfile_check_list() for the -ELOOP case.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Reported-by: Yurij M. Plotnikov <Yurij.Plotnikov@oktetlabs.ru>
Cc: Nelson Elhage <nelhage@nelhage.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Tested-by: Alexandra N. Kossovsky <Alexandra.Kossovsky@oktetlabs.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/eventpoll.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 802b28d..ff57421 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1577,8 +1577,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	if (op == EPOLL_CTL_ADD) {
 		if (is_file_epoll(tfile)) {
 			error = -ELOOP;
-			if (ep_loop_check(ep, tfile) != 0)
+			if (ep_loop_check(ep, tfile) != 0) {
+				clear_tfile_check_list();
 				goto error_tgt_fput;
+			}
 		} else
 			list_add(&tfile->f_tfile_llink, &tfile_check_list);
 	}
-- 
1.7.2.1.45.g54fbc



