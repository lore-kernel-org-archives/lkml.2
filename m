Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1ABHX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:35899 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1ABHXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 135/260] aio: check for multiplication overflow in do_io_submit
Date: Sun,  2 Jan 2011 02:17:11 -0500
Message-Id: <1293952756-15010-136-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jan 2011 07:22:37.0962 (UTC) FILETIME=[D565E6A0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Moyer <jmoyer@redhat.com>

commit 75e1c70fc31490ef8a373ea2a4bea2524099b478 upstream.

Tavis Ormandy pointed out that do_io_submit does not do proper bounds
checking on the passed-in iocb array:

       if (unlikely(nr < 0))
               return -EINVAL;

       if (unlikely(!access_ok(VERIFY_READ, iocbpp, (nr*sizeof(iocbpp)))))
               return -EFAULT;                      ^^^^^^^^^^^^^^^^^^

The attached patch checks for overflow, and if it is detected, the
number of iocbs submitted is scaled down to a number that will fit in
the long.  This is an ok thing to do, as sys_io_submit is documented as
returning the number of iocbs submitted, so callers should handle a
return value of less than the 'nr' argument passed in.

Reported-by: Tavis Ormandy <taviso@cmpxchg8b.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/aio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 48fdeeb..94b6cd6 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1659,6 +1659,9 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 	if (unlikely(nr < 0))
 		return -EINVAL;
 
+	if (unlikely(nr > LONG_MAX/sizeof(*iocbpp)))
+		nr = LONG_MAX/sizeof(*iocbpp);
+
 	if (unlikely(!access_ok(VERIFY_READ, iocbpp, (nr*sizeof(*iocbpp)))))
 		return -EFAULT;
 
-- 
1.7.3.3

