Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2AHVog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 16:44:36 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17308 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2AHVof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 16:44:35 -0500
Date: Sun, 8 Jan 2012 22:44:29 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Subject: [PATCH] audit: always follow va_copy() with va_end()
In-Reply-To: <alpine.LNX.2.00.1201082228280.24030@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1201082241350.24030@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201082028140.24030@swampdragon.chaosbits.net> <CA+55aFwO9Wtq=NEpMskW-2wrWZAGh-C6VBXENA3LtFOk=tUwgQ@mail.gmail.com> <alpine.LNX.2.00.1201082228280.24030@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A call to va_copy() should always be followed by a call to va_end() in the
same function.  In kernel/autit.c::audit_log_vformat() this is not always
done.  This patch makes sure va_end() is always called.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/audit.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 09fae26..2c1d6ab 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1260,12 +1260,13 @@ static void audit_log_vformat(struct audit_buffer *ab, const char *fmt,
 		avail = audit_expand(ab,
 			max_t(unsigned, AUDIT_BUFSIZ, 1+len-avail));
 		if (!avail)
-			goto out;
+			goto out_va_end;
 		len = vsnprintf(skb_tail_pointer(skb), avail, fmt, args2);
 	}
-	va_end(args2);
 	if (len > 0)
 		skb_put(skb, len);
+out_va_end:
+	va_end(args2);
 out:
 	return;
 }
-- 
1.7.8.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

