Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2FJLVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:21:16 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51471 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab2FJLVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:21:14 -0400
Date: Sun, 10 Jun 2012 12:24:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: dbaryshkov@gmail.com, slapin@ossfans.org, davem@davemloft.net,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee802154: verify packet size before trying to
 allocate it
Message-ID: <20120610122435.7d5c8fa7@pyramind.ukuu.org.uk>
In-Reply-To: <1339326619-1753-1-git-send-email-levinsasha928@gmail.com>
References: <1339326619-1753-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2012 13:10:19 +0200
Sasha Levin <levinsasha928@gmail.com> wrote:

> Currently when sending data over datagram, the send function will attempt to
> allocate any size passed on from the userspace.
> 
> We should make sure that this size is checked and limited. The maximum size
> of an IP packet seemed like the safest limit here.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
> 
> Change in v2:
>  - Limit by maximum size the protocol supports.
> 
>  net/ieee802154/dgram.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ieee802154/dgram.c b/net/ieee802154/dgram.c
> index 6fbb2ad..628498c 100644
> --- a/net/ieee802154/dgram.c
> +++ b/net/ieee802154/dgram.c
> @@ -232,6 +232,11 @@ static int dgram_sendmsg(struct kiocb *iocb, struct sock *sk,
>  
>  	hlen = LL_RESERVED_SPACE(dev);
>  	tlen = dev->needed_tailroom;
> +	if (hlen + tlen + size > IEEE802154_MTU) {
> +		err = -EMSGSIZE;
> +		goto out;

What stops an overflow at this point. We'll then pass a small value to
sock_alloc_send_skb/sock_alloc_send_pskb and copy a large number of bytes
into it.

This does seem to be already broken, and not fixed by the patch ?

Alan
