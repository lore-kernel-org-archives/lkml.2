Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1ARQ7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:59:35 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:35891 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab1ARQ7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:59:33 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2011 11:59:33 EST
From: Ian Molton <ian.molton@collabora.co.uk>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, eric.dumazet@gmail.com,
        ebiederm@xmission.com, xemul@openvz.org, davidel@xmailserver.org,
        Alban Crequy <alban.crequy@collabora.co.uk>
Subject: [PATCH] af_unix: implement socket filter
Date: Tue, 18 Jan 2011 16:39:15 +0000
Message-Id: <1295368755-20931-1-git-send-email-ian.molton@collabora.co.uk>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Crequy <alban.crequy@collabora.co.uk>

Linux Socket Filters can already be successfully attached and detached on unix
sockets with setsockopt(sockfd, SOL_SOCKET, SO_{ATTACH,DETACH}_FILTER, ...).
See: Documentation/networking/filter.txt

But the filter was never used in the unix socket code so it did not work. This
patch uses sk_filter() to filter buffers before delivery.

This short program demonstrates the problem on SOCK_DGRAM.

int main(void) {
  int i, j, ret;
  int sv[2];
  struct pollfd fds[2];
  char *message = "Hello world!";
  char buffer[64];
  struct sock_filter ins[32] = {{0,},};
  struct sock_fprog filter;

  socketpair(AF_UNIX, SOCK_DGRAM, 0, sv);

  for (i = 0 ; i < 2 ; i++) {
    fds[i].fd = sv[i];
    fds[i].events = POLLIN;
    fds[i].revents = 0;
  }

  for(j = 1 ; j < 13 ; j++) {

    /* Set a socket filter to truncate the message */
    memset(ins, 0, sizeof(ins));
    ins[0].code = BPF_RET|BPF_K;
    ins[0].k = j;
    filter.len = 1;
    filter.filter = ins;
    setsockopt(sv[1], SOL_SOCKET, SO_ATTACH_FILTER, &filter, sizeof(filter));

    /* send a message */
    send(sv[0], message, strlen(message) + 1, 0);

    /* The filter should let the message pass but truncated. */
    poll(fds, 2, 0);

    /* Receive the truncated message*/
    ret = recv(sv[1], buffer, 64, 0);
    printf("received %d bytes, expected %d\n", ret, j);
  }

    for (i = 0 ; i < 2 ; i++)
      close(sv[i]);

  return 0;
}

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
Reviewed-by: Ian Molton <ian.molton@collabora.co.uk>
---
 net/unix/af_unix.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index dd419d2..8d9bbba 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1475,6 +1475,12 @@ restart:
 			goto out_free;
 	}
 
+	if (sk_filter(other, skb) < 0) {
+		/* Toss the packet but do not return any error to the sender */
+		err = len;
+		goto out_free;
+	}
+
 	unix_state_lock(other);
 	err = -EPERM;
 	if (!unix_may_send(sk, other))
-- 
1.7.2.3

