Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2FJMPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 08:15:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44863 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2FJMPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 08:15:37 -0400
Message-ID: <1339330600.4999.7.camel@lappy>
Subject: Re: [PATCH] ieee802154: verify packet size before trying to
 allocate it
From: Sasha Levin <levinsasha928@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dbaryshkov@gmail.com, slapin@ossfans.org, davem@davemloft.net,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 10 Jun 2012 14:16:40 +0200
In-Reply-To: <20120610122435.7d5c8fa7@pyramind.ukuu.org.uk>
References: <1339326619-1753-1-git-send-email-levinsasha928@gmail.com>
	 <20120610122435.7d5c8fa7@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Sun, 2012-06-10 at 12:24 +0100, Alan Cox wrote:
> On Sun, 10 Jun 2012 13:10:19 +0200
> Sasha Levin <levinsasha928@gmail.com> wrote:
> > +	if (hlen + tlen + size > IEEE802154_MTU) {
> > +		err = -EMSGSIZE;
> > +		goto out;
> 
> What stops an overflow at this point. We'll then pass a small value to
> sock_alloc_send_skb/sock_alloc_send_pskb and copy a large number of bytes
> into it.
> 
> This does seem to be already broken, and not fixed by the patch ?
> 
> Alan

Hm, nothing.

I've added this check to prevent users from being able to allocate huge kernel buffers, and haven't though about the overflow case at all. Thanks for pointing it out.

How about something like this instead:

-----8<-----

From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 10 Jun 2012 13:08:03 +0200
Subject: [PATCH] ieee802154: verify packet size before trying to allocate it

Currently when sending data over datagram, the send function will attempt to
allocate any size passed on from the userspace.

We should make sure that this size is checked and limited. The maximum size
of an IP packet seemed like the safest limit here.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 net/ieee802154/dgram.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ieee802154/dgram.c b/net/ieee802154/dgram.c
index 6fbb2ad..b098b9c 100644
--- a/net/ieee802154/dgram.c
+++ b/net/ieee802154/dgram.c
@@ -230,6 +230,12 @@ static int dgram_sendmsg(struct kiocb *iocb, struct sock *sk,
	mtu = dev->mtu;
	pr_debug("name = %s, mtu = %u\n", dev->name, mtu);

+	if (size > mtu) {
+		pr_debug("size = %Zu, mtu = %u\n", size, mtu);
+		err = -EINVAL;
+		goto out_skb;
+	}
+
	hlen = LL_RESERVED_SPACE(dev);
	tlen = dev->needed_tailroom;
	skb = sock_alloc_send_skb(sk, hlen + tlen + size,
@@ -258,12 +264,6 @@ static int dgram_sendmsg(struct kiocb *iocb, struct sock *sk,
	if (err < 0)
		goto out_skb;

-	if (size > mtu) {
-		pr_debug("size = %Zu, mtu = %u\n", size, mtu);
-		err = -EINVAL;
-		goto out_skb;
-	}
-
	skb->dev = dev;
	skb->sk  = sk;
	skb->protocol = htons(ETH_P_IEEE802154);

