Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab1B1EWC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 23:22:02 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58293 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab1B1EWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 23:22:00 -0500
Date: Mon, 28 Feb 2011 15:21:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>,
        Daniel Baluta <daniel.baluta@gmail.com>
Subject: linux-next: manual merge of the trivial tree with Linus' tree
Message-Id: <20110228152153.25e94457.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
fs/eventpoll.c between commit 22bacca48a1755f79b7e0f192ddb9fbb7fc6e64e
("epoll: prevent creating circular epoll structures") from Linus' tree
and commit bf6a41db7726e6c09b9c6ac993457b7260473406 ("fs/eventpoll.c: fix
spelling") from the trivial tree.

Just context.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/eventpoll.c
index 4a09af9,7513066..0000000
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@@ -62,14 -62,7 +62,14 @@@
   * This mutex is acquired by ep_free() during the epoll file
   * cleanup path and it is also acquired by eventpoll_release_file()
   * if a file has been pushed inside an epoll set and it is then
-  * close()d without a previous call toepoll_ctl(EPOLL_CTL_DEL).
+  * close()d without a previous call to epoll_ctl(EPOLL_CTL_DEL).
 + * It is also acquired when inserting an epoll fd onto another epoll
 + * fd. We do this so that we walk the epoll tree and ensure that this
 + * insertion does not create a cycle of epoll file descriptors, which
 + * could lead to deadlock. We need a global mutex to prevent two
 + * simultaneous inserts (A into B and B into A) from racing and
 + * constructing a cycle without either insert observing that it is
 + * going to.
   * It is possible to drop the "ep->mtx" and to use the global
   * mutex "epmutex" (together with "ep->lock") to have it working,
   * but having "ep->mtx" will make the interface more scalable.
