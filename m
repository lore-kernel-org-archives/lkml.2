Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945976Ab2KODKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 22:10:24 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:62013 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945909Ab2KODKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 22:10:23 -0500
Date: Wed, 14 Nov 2012 19:06:53 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>,
        Colin King <colin.king@canonical.com>
Subject: [GIT PULL] linux-pstore.git
Message-ID: <20121115030652.GA27185@lizard.sbx05977.paloaca.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull a small fixup for the persistent storage subsystem. A small
buglet can prevent kernel booting on a APEI-enabled machines w/
CONFIG_PSTORE_CONSOLE=y (this is N by default, though).

Thanks!

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.infradead.org/users/cbou/linux-pstore.git tags/for-v3.7-fixes

for you to fetch changes up to 70a6f46d7b0ec03653b9ab3f8063a9717a4a53ef:

  pstore: Fix NULL pointer dereference in console writes (2012-11-14 18:30:21 -0800)

----------------------------------------------------------------
A small fixup for the persistent storage subsystem. The bug can prevent
kernel booting on a APEI-enabled machines w/ CONFIG_PSTORE_CONSOLE=y (this
is N by default, though).

----------------------------------------------------------------
Colin Ian King (1):
      pstore: Fix NULL pointer dereference in console writes

 fs/pstore/platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


commit 70a6f46d7b0ec03653b9ab3f8063a9717a4a53ef
Author: Colin Ian King <colin.king@canonical.com>
Date:   Wed Nov 14 11:49:53 2012 +0000

    pstore: Fix NULL pointer dereference in console writes
    
    Passing a NULL id causes a NULL pointer deference in writers such as
    erst_writer and efi_pstore_write because they expect to update this id.
    Pass a dummy id instead.
    
    This avoids a cascade of oopses caused when the initial
    pstore_console_write passes a null which in turn causes writes to the
    console causing further oopses in subsequent pstore_console_write calls.
    
    Signed-off-by: Colin Ian King <colin.king@canonical.com>
    Acked-by: Kees Cook <keescook@chromium.org>
    Cc: stable@vger.kernel.org
    Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index a40da07..947fbe0 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -161,6 +161,7 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 
 	while (s < e) {
 		unsigned long flags;
+		u64 id;
 
 		if (c > psinfo->bufsize)
 			c = psinfo->bufsize;
@@ -172,7 +173,7 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 			spin_lock_irqsave(&psinfo->buf_lock, flags);
 		}
 		memcpy(psinfo->buf, s, c);
-		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, c, psinfo);
+		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, c, psinfo);
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 		s += c;
 		c = e - s;
