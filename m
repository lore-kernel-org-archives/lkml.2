Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0IXQwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:52:51 -0400
Received: from kroah.org ([198.145.64.141]:38379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697Ab0IXQ2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:30 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:18 2010
Message-Id: <20100924162618.617822417@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [43/80] Prevent freeing uninitialized pointer in compat_do_readv_writev
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 767b68e96993e29e3480d7ecdd9c4b84667c5762 upstream.

In 32-bit compatibility mode, the error handling for
compat_do_readv_writev() may free an uninitialized pointer, potentially
leading to all sorts of ugly memory corruption.  This is reliably
triggerable by unprivileged users by invoking the readv()/writev()
syscalls with an invalid iovec pointer.  The below patch fixes this to
emulate the non-compat version.

Introduced by commit b83733639a49 ("compat: factor out
compat_rw_copy_check_uvector from compat_do_readv_writev")

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1150,7 +1150,7 @@ static ssize_t compat_do_readv_writev(in
 {
 	compat_ssize_t tot_len;
 	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov;
+	struct iovec *iov = iovstack;
 	ssize_t ret;
 	io_fn_t fn;
 	iov_fn_t fnv;


