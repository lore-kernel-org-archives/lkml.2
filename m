Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab2KVV2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:28:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:49609 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab2KVSkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Colin Ian King <colin.king@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [ 32/83] pstore: Fix NULL pointer dereference in console writes
Date: Wed, 21 Nov 2012 16:41:54 -0800
Message-Id: <20121122004216.176580674@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

commit 70a6f46d7b0ec03653b9ab3f8063a9717a4a53ef upstream.

Passing a NULL id causes a NULL pointer deference in writers such as
erst_writer and efi_pstore_write because they expect to update this id.
Pass a dummy id instead.

This avoids a cascade of oopses caused when the initial
pstore_console_write passes a null which in turn causes writes to the
console causing further oopses in subsequent pstore_console_write calls.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/platform.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -161,12 +161,13 @@ static void pstore_console_write(struct
 
 	while (s < e) {
 		unsigned long flags;
+		u64 id;
 
 		if (c > psinfo->bufsize)
 			c = psinfo->bufsize;
 		spin_lock_irqsave(&psinfo->buf_lock, flags);
 		memcpy(psinfo->buf, s, c);
-		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, c, psinfo);
+		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, c, psinfo);
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 		s += c;
 		c = e - s;


