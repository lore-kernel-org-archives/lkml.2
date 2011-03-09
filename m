Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1CIXmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:42:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab1CIXml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:42:41 -0500
Date: Wed, 9 Mar 2011 15:42:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: roel <roel.kluin@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        linux-nfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nfsd: wrong index used in inner loop
Message-Id: <20110309154230.66bc2c36.akpm@linux-foundation.org>
In-Reply-To: <4D76A06A.4090405@gmail.com>
References: <4D76A06A.4090405@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Mar 2011 22:32:26 +0100
roel <roel.kluin@gmail.com> wrote:

> Index i was already used in the outer loop
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  fs/nfsd/nfs4xdr.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> Not 100% sure this one is needed but it looks suspicious.
> 
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index 1275b86..615f0a9 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -1142,7 +1142,7 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
>  
>  	u32 dummy;
>  	char *machine_name;
> -	int i;
> +	int i, j;
>  	int nr_secflavs;
>  
>  	READ_BUF(16);
> @@ -1215,7 +1215,7 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
>  			READ_BUF(4);
>  			READ32(dummy);
>  			READ_BUF(dummy * 4);
> -			for (i = 0; i < dummy; ++i)
> +			for (j = 0; j < dummy; ++j)
>  				READ32(dummy);
>  			break;
>  		case RPC_AUTH_GSS:

ooh, big bug.

I wonder why it was not previously detected at runtime.  Perhaps
nr_secflavs is always 1.

afacit this bug will allow a well-crafted packet to cause an
infinite-until-it-oopses loop in the kernel.
