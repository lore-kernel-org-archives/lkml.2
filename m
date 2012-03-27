Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2C0OKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:10:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab2C0OKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:10:38 -0400
Date: Tue, 27 Mar 2012 10:05:10 -0400
From: Jason Baron <jbaron@redhat.com>
To: "Yurij M. Plotnikov" <Yurij.Plotnikov@oktetlabs.ru>
Cc: linux-kernel@vger.kernel.org,
        "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        akpm@linux-foundation.org
Subject: Re: Dead circle in epoll file descriptor causes soft lockup on
 kernel 3.2.12
Message-ID: <20120327140510.GA2419@redhat.com>
References: <4F717174.9090008@oktetlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F717174.9090008@oktetlabs.ru>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 11:51:16AM +0400, Yurij M. Plotnikov wrote:
> Adding epoll file descriptors in each other in circle causes soft
> lockup on kernel 3.2.12 (I'm using Debian kernel
> 3.2.0-0.bpo.1-amd64). The following steps describe the problem:
> 
> 1. epoll_create(1) -> 3
> 2. epoll_create(1) -> 4
> 3. socket(SOCK_STREAM) -> 5
> 4. bind(5, 0.0.0.0:0) -> 0
> 5. listen(5, 1) -> 0
> 6. epoll_ctl(3, ADD, 5, events = 0) -> 0
> 7. epoll_ctl(3, ADD, 4, events = EPOLLIN) -> 0
> 8. epoll_ctl(4, ADD, 3, events = EPOLLIN) -> -1(ELOOP)
> 9. close(3) -> 0
> 10. close(4) -> 0
> 11. close(5) -> 0
> 
> After repetaing this sequence 2-3 times soft lockup appers. In
> attachment c program to reproduce this problem.
> 

Good catch. The patch below should fix this - please verify. Thanks.


Make sure we clear the tfile_check_list on error.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 fs/eventpoll.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index c33b347..9af6e18 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1652,8 +1652,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
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

