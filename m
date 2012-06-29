Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2F2Ox5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:53:57 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:57232 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2F2Ox4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:53:56 -0400
Message-ID: <1340981632.25226.2.camel@gurkel.linbit>
Subject: [RFC] [TCP 0/3] Receive from socket into bio without copying
From: Andreas Gruenbacher <agruen@linbit.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 29 Jun 2012 16:53:52 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm (still) trying to pass data from the network to the block layer without
copying. The block layer needs blocks to be contiguous in memory, and may have
some alignment restrictions as well.  A lot of modern network hardware will
receive large packets into separate buffers, so individual large packets will
end up in contiguous, aligned buffers.  I would like to make use of that, but
tcp currently doesn't allow me to control what ends up in which packets.

This patch series introduces a new flag for indicating to tcp when it should
start a new segment. Using that on the sender side, I can get data over the
network with no cpu copying at all.

[My last posting on this topic from May 8 is archived here:
 http://www.spinics.net/lists/netdev/msg197788.html ]

Thanks,
Andreas

Andreas Gruenbacher (3):
  tcp: Add MSG_NEW_PACKET flag to indicate preferable packet boundaries
  tcp: Zero-copy receive from a socket into a bio
  fs: Export bio_release_pages()

 fs/bio.c               |    3 +-
 include/linux/bio.h    |    1 +
 include/linux/socket.h |    1 +
 include/net/tcp.h      |    3 +
 net/ipv4/Makefile      |    3 +-
 net/ipv4/tcp.c         |    5 +-
 net/ipv4/tcp_recvbio.c |  168 ++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 180 insertions(+), 4 deletions(-)
 create mode 100644 net/ipv4/tcp_recvbio.c

-- 
1.7.10.2

