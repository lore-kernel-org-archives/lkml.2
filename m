Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0LXSfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 13:35:30 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19092 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab0LXSf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 13:35:29 -0500
Date: Fri, 24 Dec 2010 19:25:37 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: "Rickard E. (Rik) Faith" <faith@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Subject: [PATCH] auditing: Always follow va_copy() with va_end()
Message-ID: <alpine.LNX.2.00.1012241922050.28973@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A call to va_copy() should always be followed by a call to va_end() in the 
same function. In kernel/autit.c::audit_log_vformat() this is not always 
done. This patch makes sure va_end() is always called.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 audit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 77770a0..d86027c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1255,12 +1255,13 @@ static void audit_log_vformat(struct audit_buffer *ab, const char *fmt,
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
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

