Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab0JaSIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 14:08:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54163 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab0JaSIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 14:08:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M/E8QBDrzN1IM8YfblRkF4Fk2Z60OHw+xV9zA98K6xhMe2cj0mhVcQO2T3PMmOMG/c
         twsIHJUMrOT8FRLSlVf7nF9dA39q7DP8Z61Nf/F2+5QmByv2fTot20StgRDBtbcL8vkd
         Oj6ahE6eorj9zzkRe4N9lw4vFw7dILNx54phY=
Subject: Re: [PATCH 1/3] net: ax25: fix information leak to userland
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288545022-16393-1-git-send-email-segooon@gmail.com>
References: <1288545022-16393-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Oct 2010 19:08:34 +0100
Message-ID: <1288548514.2660.70.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 31 octobre 2010 à 20:10 +0300, Vasiliy Kulikov a écrit :
> Sometimes ax25_getname() doesn't initialize all members of fsa_digipeater
> field of fsa struct.  This structure is then copied to userland.  It leads to
> leaking of contents of kernel stack memory.  We have to initialize them to zero.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  net/ax25/af_ax25.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index 26eaebf..a324d83 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -1392,6 +1392,7 @@ static int ax25_getname(struct socket *sock, struct sockaddr *uaddr,
>  	ax25_cb *ax25;
>  	int err = 0;
>  
> +	memset(&fsa->fsa_digipeater, 0, sizeof(fsa->fsa_digipeater));
>  	lock_sock(sk);
>  	ax25 = ax25_sk(sk);
>  

If you really want to fix this for good, please do it completely ?

sa_family_t is a short

ax25_address is 7 bytes.

Therefore, there is a hole before sax25_ndigis.

struct sockaddr_ax25 {
        sa_family_t     sax25_family;
        ax25_address    sax25_call;
<hole>
        int             sax25_ndigis;
        /* Digipeater ax25_address sets follow */
};
struct full_sockaddr_ax25 {
        struct sockaddr_ax25 fsa_ax25;
        ax25_address    fsa_digipeater[AX25_MAX_DIGIS];
};


So a correct patch is the following one. Note AX25 is probably used by
nobody at all, so a full memset() is not performance critical in this
path.


diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 26eaebf..6da5dae 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1392,6 +1392,7 @@ static int ax25_getname(struct socket *sock, struct sockaddr *uaddr,
 	ax25_cb *ax25;
 	int err = 0;
 
+	memset(fsa, 0, sizeof(*fsa));
 	lock_sock(sk);
 	ax25 = ax25_sk(sk);
 
@@ -1403,7 +1404,6 @@ static int ax25_getname(struct socket *sock, struct sockaddr *uaddr,
 
 		fsa->fsa_ax25.sax25_family = AF_AX25;
 		fsa->fsa_ax25.sax25_call   = ax25->dest_addr;
-		fsa->fsa_ax25.sax25_ndigis = 0;
 
 		if (ax25->digipeat != NULL) {
 			ndigi = ax25->digipeat->ndigi;


