Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2GWBpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:45:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54526 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753560Ab2GWBnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:53 -0400
Message-Id: <20120723010655.027064805@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Baron <jbaron@redhat.com>,
        "Yurij M. Plotnikov" <Yurij.Plotnikov@oktetlabs.ru>,
        Nelson Elhage <nelhage@nelhage.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
Subject: [ 023/108] epoll: clear the tfile_check_list on -ELOOP
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/eventpoll.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 739b098..c0b3c70 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1663,8 +1663,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
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


