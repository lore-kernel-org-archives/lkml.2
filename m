Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0JKISM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:18:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50314 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab0JKISK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KLk+PZ+8LumC7ooIOi1ITRWzAhOzxKASjFkpnrlRpOLOw4o7aFpntzcp4j4YCyPCOG
         jhUJUONvgtXPGt/Cccn4Abijj3B0882fOF6lxCacGkn2FBZ66uioaJJ5QXz45inr8cfF
         Js2QTjXMROvnkkGYJVlxEmq/kWqZ4rTWDEvto=
Subject: Re: [HELP] ATM: mpc, use-after-free
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        ML netdev <netdev@vger.kernel.org>,
        linux-atm-general@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, chas@cmf.nrl.navy.mil
In-Reply-To: <4CB2C33C.8080109@gmail.com>
References: <4CB2C33C.8080109@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 10:18:00 +0200
Message-ID: <1286785081.2737.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 11 octobre 2010 à 09:56 +0200, Jiri Slaby a écrit :
> Hi,
> 
> Stanse found this use-after-free:
> 
> static void mpc_push(struct atm_vcc *vcc, struct sk_buff *skb)
> {
> ...
>         new_skb = skb_realloc_headroom(skb, eg->ctrl_info.DH_length);
> 
>         dev_kfree_skb_any(skb);
> 
> FREE    ^^^^^^^^^^^^^^^^^^^^^^^
> 
>         if (new_skb == NULL) {
>                 mpc->eg_ops->put(eg);
>                 return;
>         }
>         skb_push(new_skb, eg->ctrl_info.DH_length);
>         skb_copy_to_linear_data(new_skb, eg->ctrl_info.DLL_header,
>                                 eg->ctrl_info.DH_length);
>  ...
>         memset(ATM_SKB(skb), 0, sizeof(struct atm_skb_data));
> 
> USE            ^^^^^^^^^^^^
> 
>         netif_rx(new_skb);
> 
> I guess it should be ATM_SKB(new_skb), right?

Yes

-	memset(ATM_SKB(skb), 0, sizeof(struct atm_skb_data));
+	memset(ATM_SKB(new_skb), 0, sizeof(struct atm_skb_data));

> 
> The two problems are:
> 1) obvious use-after-free
> 2) ?data leak, since we don't erase the right memory?
> 
> thanks,

Indeed, please submit a formal patch ?

Thanks


