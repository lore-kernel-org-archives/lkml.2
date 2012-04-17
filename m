Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2DQOfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:35:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab2DQOfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:35:02 -0400
Date: Tue, 17 Apr 2012 10:34:52 -0400
From: Jason Baron <jbaron@redhat.com>
Message-Id: <201204171434.q3HEYqrq007242@int-mx09.intmail.prod.int.phx2.redhat.com>
To: akpm@linux-foundation.org
Cc: Yurij.Plotnikov@oktetlabs.ru, Alexandra.Kossovsky@oktetlabs.ru,
        davidel@xmailserver.org, nelhage@nelhage.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] epoll: clear the tfile_check_list on -ELOOP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An epoll_ctl(,EPOLL_CTL_ADD,,) operation can return '-ELOOP' to prevent
circular epoll dependencies from being created. However, in that case
we do not properly clear the 'tfile_check_list'. Thus, add a call to
clear_tfile_check_list() for the -ELOOP case.

Reported-by: Yurij M. Plotnikov <Yurij.Plotnikov@oktetlabs.ru>
Tested-by: Alexandra N. Kossovsky <Alexandra.Kossovsky@oktetlabs.ru>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 fs/eventpoll.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

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
-- 
1.7.7.6

