Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2ANLNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 06:13:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45813 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab2ANLNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 06:13:31 -0500
Message-ID: <4F116350.6090704@gmail.com>
Date: Sat, 14 Jan 2012 19:13:20 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: davidel@xmailserver.org
Subject: The thundering herd like problem when multi epolls on one fd
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

	My buddy reported a thundering herd problem about using epoll 
on TCP listen sockets. He said their usage like below:

	1. sk = new tcp_listen_socket();
	2. create many child processes or threads.
	3. in new created processes (threads), use epoll API on listen
sk to provide HTTP service.

	Such using pattern means we have multi wait queues when 
accepting one socket, and it is not exclusive waking up, so we get a 
thundering herd like problem. And, so I heard many popular applications
can use such pattern, which includes nginx, lighttpd, haproxy at least.
So should we change this waking up behavior to exclusive too ? 

	Below is a simple patch (tested and works) for epoll() to do it,
of course, we also should fix select() and poll() syscalls if it is right.

	Thanks.

Yu	

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 828e750..a3d6ab4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -898,7 +899,7 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
                init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
                pwq->whead = whead;
                pwq->base = epi;
-               add_wait_queue(whead, &pwq->wait);
+               add_wait_queue_exclusive(whead, &pwq->wait);
                list_add_tail(&pwq->llink, &epi->pwqlist);
                epi->nwait++;
        } else {
