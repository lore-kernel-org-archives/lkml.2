Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab2JAXCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:02:10 -0400
Received: from 1wt.eu ([62.212.114.60]:35473 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055Ab2JAXB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:59 -0400
Message-Id: <20121001225202.353059505@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lin Ming <mlin@ss.pku.edu.cn>, Paul Moore <pmoore@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 112/180] cipso: dont follow a NULL pointer when setsockopt() is called
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

[ Upstream commit 89d7ae34cdda4195809a5a987f697a517a2a3177 ]

As reported by Alan Cox, and verified by Lin Ming, when a user
attempts to add a CIPSO option to a socket using the CIPSO_V4_TAG_LOCAL
tag the kernel dies a terrible death when it attempts to follow a NULL
pointer (the skb argument to cipso_v4_validate() is NULL when called via
the setsockopt() syscall).

This patch fixes this by first checking to ensure that the skb is
non-NULL before using it to find the incoming network interface.  In
the unlikely case where the skb is NULL and the user attempts to add
a CIPSO option with the _TAG_LOCAL tag we return an error as this is
not something we want to allow.

A simple reproducer, kindly supplied by Lin Ming, although you must
have the CIPSO DOI #3 configure on the system first or you will be
caught early in cipso_v4_validate():

	#include <sys/types.h>
	#include <sys/socket.h>
	#include <linux/ip.h>
	#include <linux/in.h>
	#include <string.h>

	struct local_tag {
		char type;
		char length;
		char info[4];
	};

	struct cipso {
		char type;
		char length;
		char doi[4];
		struct local_tag local;
	};

	int main(int argc, char **argv)
	{
		int sockfd;
		struct cipso cipso = {
			.type = IPOPT_CIPSO,
			.length = sizeof(struct cipso),
			.local = {
				.type = 128,
				.length = sizeof(struct local_tag),
			},
		};

		memset(cipso.doi, 0, 4);
		cipso.doi[3] = 3;

		sockfd = socket(AF_INET, SOCK_DGRAM, 0);
		#define SOL_IP 0
		setsockopt(sockfd, SOL_IP, IP_OPTIONS,
			&cipso, sizeof(struct cipso));

		return 0;
	}

CC: Lin Ming <mlin@ss.pku.edu.cn>
Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/cipso_ipv4.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 039cc1f..10f8f8d 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1726,8 +1726,10 @@ int cipso_v4_validate(const struct sk_buff *skb, unsigned char **option)
 		case CIPSO_V4_TAG_LOCAL:
 			/* This is a non-standard tag that we only allow for
 			 * local connections, so if the incoming interface is
-			 * not the loopback device drop the packet. */
-			if (!(skb->dev->flags & IFF_LOOPBACK)) {
+			 * not the loopback device drop the packet. Further,
+			 * there is no legitimate reason for setting this from
+			 * userspace so reject it if skb is NULL. */
+			if (skb == NULL || !(skb->dev->flags & IFF_LOOPBACK)) {
 				err_offset = opt_iter;
 				goto validate_return_locked;
 			}
-- 
1.7.2.1.45.g54fbc



