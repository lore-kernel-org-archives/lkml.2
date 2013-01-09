Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab3AIV43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:56:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:41256 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab3AIUhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tommi Rantala <tt.rantala@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 03/80] sctp: fix memory leak in sctp_datamsg_from_user() when copy from user space fails
Date: Wed,  9 Jan 2013 12:34:55 -0800
Message-Id: <20130109201500.825980027@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Tommi Rantala <tt.rantala@gmail.com>

[ Upstream commit be364c8c0f17a3dd42707b5a090b318028538eb9 ]

Trinity (the syscall fuzzer) discovered a memory leak in SCTP,
reproducible e.g. with the sendto() syscall by passing invalid
user space pointer in the second argument:

 #include <string.h>
 #include <arpa/inet.h>
 #include <sys/socket.h>

 int main(void)
 {
         int fd;
         struct sockaddr_in sa;

         fd = socket(AF_INET, SOCK_STREAM, 132 /*IPPROTO_SCTP*/);
         if (fd < 0)
                 return 1;

         memset(&sa, 0, sizeof(sa));
         sa.sin_family = AF_INET;
         sa.sin_addr.s_addr = inet_addr("127.0.0.1");
         sa.sin_port = htons(11111);

         sendto(fd, NULL, 1, 0, (struct sockaddr *)&sa, sizeof(sa));

         return 0;
 }

As far as I can tell, the leak has been around since ~2003.

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/chunk.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -284,7 +284,7 @@ struct sctp_datamsg *sctp_datamsg_from_u
 			goto errout;
 		err = sctp_user_addto_chunk(chunk, offset, len, msgh->msg_iov);
 		if (err < 0)
-			goto errout;
+			goto errout_chunk_free;
 
 		offset += len;
 
@@ -324,7 +324,7 @@ struct sctp_datamsg *sctp_datamsg_from_u
 		__skb_pull(chunk->skb, (__u8 *)chunk->chunk_hdr
 			   - (__u8 *)chunk->skb->data);
 		if (err < 0)
-			goto errout;
+			goto errout_chunk_free;
 
 		sctp_datamsg_assign(msg, chunk);
 		list_add_tail(&chunk->frag_list, &msg->chunks);
@@ -332,6 +332,9 @@ struct sctp_datamsg *sctp_datamsg_from_u
 
 	return msg;
 
+errout_chunk_free:
+	sctp_chunk_free(chunk);
+
 errout:
 	list_for_each_safe(pos, temp, &msg->chunks) {
 		list_del_init(pos);


