Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab0JVSl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:41:29 -0400
Received: from kroah.org ([198.145.64.141]:45936 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab0JVSl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:41:28 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:40:32 2010
Message-Id: <20101022184032.582380063@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:39:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [01/17] aio: check for multiplication overflow in do_io_submit
In-Reply-To: <20101022184048.GA25391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/aio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1677,6 +1677,9 @@ SYSCALL_DEFINE3(io_submit, aio_context_t
 	if (unlikely(nr < 0))
 		return -EINVAL;
 
+	if (unlikely(nr > LONG_MAX/sizeof(*iocbpp)))
+		nr = LONG_MAX/sizeof(*iocbpp);
+
 	if (unlikely(!access_ok(VERIFY_READ, iocbpp, (nr*sizeof(*iocbpp)))))
 		return -EFAULT;
 


