Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0JYGBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 02:01:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64045 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab0JYGBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 02:01:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uPxaiyGsMrqd+h9Sqzbg+mClHaeRnpmEop8g0yBuNTgx7qJnG70aehjcXj3Ix5cqCQ
         RP9WmCiZvpPOHSBZCGPwYJeZ9M1QlWREd4Vwv6FVZ9TrXIj/3mrYLhlerUHAYFMlH5p9
         Mf1KTmRwGrZmaoMGGSrRDm1ZNHLnywqR3VsZk=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] fs/buffer.c: call __block_write_begin() if we have page
Date: Mon, 25 Oct 2010 15:01:12 +0900
Message-Id: <1287986472-4814-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287850314-13663-1-git-send-email-namhyung@gmail.com>
References: <1287850314-13663-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have the appropriate page already, call __block_write_begin()
directly instead of releasing and regrabbing it inside of
block_write_begin().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
Shared error path.

 fs/buffer.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 7f0b9b0..a132c2b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2466,11 +2466,10 @@ int nobh_write_begin(struct address_space *mapping,
 	*fsdata = NULL;
 
 	if (page_has_buffers(page)) {
-		unlock_page(page);
-		page_cache_release(page);
-		*pagep = NULL;
-		return block_write_begin(mapping, pos, len, flags, pagep,
-					 get_block);
+		ret = __block_write_begin(page, pos, len, get_block);
+		if (unlikely(ret))
+			goto out_release;
+		return ret;
 	}
 
 	if (PageMappedToDisk(page))
-- 
1.7.0.4

