Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2LZMol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 07:44:41 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:33528 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab2LZMok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 07:44:40 -0500
Subject: [PATCH 0/3] fuse: fix accounting background requests
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Wed, 26 Dec 2012 16:44:23 +0400
Message-ID: <20121226124319.24502.41536.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The feature was added long time ago (commit 08a53cdc...) with the comment:

> A task may have at most one synchronous request allocated.  So these requests
> need not be otherwise limited.
> 
> However the number of background requests (release, forget, asynchronous
> reads, interrupted requests) can grow indefinitely.  This can be used by a
> malicous user to cause FUSE to allocate arbitrary amounts of unswappable
> kernel memory, denying service.
> 
> For this reason add a limit for the number of background requests, and block
> allocations of new requests until the number goes bellow the limit.

However, the implementation suffers from the following problems:

1. Latency of synchronous requests. As soon as fc->num_background hits the
limit, all allocations are blocked: both for synchronous and background
requests. This is unnecessary - as the comment cited above states, synchronous
requests need not be limited (by fuse). Moreover, sometimes it's very
inconvenient. For example, a dozen of tasks aggressively writing to mmap()-ed
area may block 'ls' for long while (>1min in my experiments).

2. Thundering herd problem. When fc->num_background falls below the limit,
request_end() calls wake_up_all(&fc->blocked_waitq). This wakes up all waiters
while it's not impossible that the first waiter getting new request will
immediately put it to background increasing fc->num_background again.
(experimenting with mmap()-ed writes I observed 2x slowdown as compared with
fuse after applying this patch-set)

The patch-set re-works fuse_get_req (and its callers) to throttle only requests
intended for background processing. Having this done, it becomes possible to
use exclusive wakeups in chained manner: request_end() wakes up a waiter,
the waiter allocates new request and submits it for background processing,
the processing ends in request_end() where another wakeup happens an so on.

Thanks,
Maxim

---

Maxim Patlasov (3):
      fuse: make request allocations for background processing explicit
      fuse: skip blocking on allocations of synchronous requests
      fuse: implement exclusive wakeup for blocked_waitq


 fs/fuse/cuse.c   |    2 +-
 fs/fuse/dev.c    |   60 +++++++++++++++++++++++++++++++++++++++++-------------
 fs/fuse/file.c   |    5 +++--
 fs/fuse/fuse_i.h |    3 +++
 fs/fuse/inode.c  |    1 +
 5 files changed, 54 insertions(+), 17 deletions(-)

-- 
Signature
