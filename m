Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022Ab3AIU5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:57:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:43640 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933930Ab3AIUkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Willy Tarreau <w@1wt.eu>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 090/123] tcp: fix MSG_SENDPAGE_NOTLAST logic
Date: Wed,  9 Jan 2013 12:35:29 -0800
Message-Id: <20130109201510.164732286@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ae62ca7b03217be5e74759dc6d7698c95df498b3 ]

commit 35f9c09fe9c72e (tcp: tcp_sendpages() should call tcp_push() once)
added an internal flag : MSG_SENDPAGE_NOTLAST meant to be set on all
frags but the last one for a splice() call.

The condition used to set the flag in pipe_to_sendpage() relied on
splice() user passing the exact number of bytes present in the pipe,
or a smaller one.

But some programs pass an arbitrary high value, and the test fails.

The effect of this bug is a lack of tcp_push() at the end of a
splice(pipe -> socket) call, and possibly very slow or erratic TCP
sessions.

We should both test sd->total_len and fact that another fragment
is in the pipe (pipe->nrbufs > 1)

Many thanks to Willy for providing very clear bug report, bisection
and test programs.

Reported-by: Willy Tarreau <w@1wt.eu>
Bisected-by: Willy Tarreau <w@1wt.eu>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/splice.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -696,8 +696,10 @@ static int pipe_to_sendpage(struct pipe_
 		return -EINVAL;
 
 	more = (sd->flags & SPLICE_F_MORE) ? MSG_MORE : 0;
-	if (sd->len < sd->total_len)
+
+	if (sd->len < sd->total_len && pipe->nrbufs > 1)
 		more |= MSG_SENDPAGE_NOTLAST;
+
 	return file->f_op->sendpage(file, buf->page, buf->offset,
 				    sd->len, &pos, more);
 }


