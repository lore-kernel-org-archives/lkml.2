Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031551Ab2CITvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:51:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031488Ab2CITvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:51:45 -0500
Message-Id: <20120309190216.265758327@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@hack.frob.com>
Subject: [ 16/68] regset: Prevent null pointer reference on readonly regsets
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@zytor.com>

commit c8e252586f8d5de906385d8cf6385fee289a825e upstream.

The regset common infrastructure assumed that regsets would always
have .get and .set methods, but not necessarily .active methods.
Unfortunately people have since written regsets without .set methods.

Rather than putting in stub functions everywhere, handle regsets with
null .get or .set methods explicitly.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/binfmt_elf.c        |    2 +-
 include/linux/regset.h |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1422,7 +1422,7 @@ static int fill_thread_core_info(struct
 	for (i = 1; i < view->n; ++i) {
 		const struct user_regset *regset = &view->regsets[i];
 		do_thread_regset_writeback(t->task, regset);
-		if (regset->core_note_type &&
+		if (regset->core_note_type && regset->get &&
 		    (!regset->active || regset->active(t->task, regset))) {
 			int ret;
 			size_t size = regset->n * regset->size;
--- a/include/linux/regset.h
+++ b/include/linux/regset.h
@@ -335,6 +335,9 @@ static inline int copy_regset_to_user(st
 {
 	const struct user_regset *regset = &view->regsets[setno];
 
+	if (!regset->get)
+		return -EOPNOTSUPP;
+
 	if (!access_ok(VERIFY_WRITE, data, size))
 		return -EIO;
 
@@ -358,6 +361,9 @@ static inline int copy_regset_from_user(
 {
 	const struct user_regset *regset = &view->regsets[setno];
 
+	if (!regset->set)
+		return -EOPNOTSUPP;
+
 	if (!access_ok(VERIFY_READ, data, size))
 		return -EIO;
 


