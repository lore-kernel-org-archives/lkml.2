Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1ABT1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 14:27:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45290 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1ABT1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 14:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JPcUQeJ6+9qhpsVfm3LrlTVa3AjfN9olCk74uC5IGz/D50cb20NKVwYFwghHtHOUEv
         xaskIqv7iv/g/KQywoqtIOuo79srPZsVeVIZN/MsSX7KFgNrjl8FMBH7zJMuEi2P1FA+
         6zh+DjI9JqMu+R6MbxHtZFLGzq/v4hBNC1TFs=
From: Chris Ruffin <cmruffin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Chris Ruffin <cmruffin@gmail.com>
Subject: [PATCH] ihex: fix unused return value compiler warning.
Date: Sun,  2 Jan 2011 11:27:10 -0800
Message-Id: <1293996430-12598-1-git-send-email-cmruffin@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed unusued return value compiler warnings due to unchecked write() calls.

Signed-off-by: Chris Ruffin <cmruffin@gmail.com>
---
 firmware/ihex2fw.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/firmware/ihex2fw.c b/firmware/ihex2fw.c
index ba0cf0b..a079bdd 100644
--- a/firmware/ihex2fw.c
+++ b/firmware/ihex2fw.c
@@ -124,8 +124,7 @@ int main(int argc, char **argv)
 	if (process_ihex(data, st.st_size))
 		return 1;
 
-	output_records(outfd);
-	return 0;
+	return output_records(outfd);
 }
 
 static int process_ihex(uint8_t *data, ssize_t size)
@@ -269,11 +268,13 @@ static int output_records(int outfd)
 
 		p->addr = htonl(p->addr);
 		p->len = htons(p->len);
-		write(outfd, &p->addr, writelen);
+		if (write(outfd, &p->addr, writelen) != writelen)
+			return errno;
 		p = p->next;
 	}
 	/* EOF record is zero length, since we don't bother to represent
 	   the type field in the binary version */
-	write(outfd, zeroes, 6);
+	if (write(outfd, zeroes, 6) != 6)
+		return errno;
 	return 0;
 }
-- 
1.7.1

