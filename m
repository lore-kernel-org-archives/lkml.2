Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2BILz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 06:55:57 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:52816 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183Ab2BILzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 06:55:55 -0500
Message-ID: <4F33B448.1040207@bfs.de>
Date: Thu, 09 Feb 2012 12:55:52 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Jens Axboe <axboe@kernel.dk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] relay: prevent integer overflow in relay_open()
References: <20120209104433.GA5540@elgon.mountain>
In-Reply-To: <20120209104433.GA5540@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 09.02.2012 11:44, schrieb Dan Carpenter:
> "subbuf_size" and "n_subbufs" come from the user and they need to be
> capped to prevent an integer overflow.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 4335e1d..ab56a17 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -164,10 +164,14 @@ depopulate:
>   */
>  static struct rchan_buf *relay_create_buf(struct rchan *chan)
>  {
> -	struct rchan_buf *buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
> -	if (!buf)
> +	struct rchan_buf *buf;
> +
> +	if (chan->n_subbufs > UINT_MAX / sizeof(size_t *))
>  		return NULL;
>  
> +	buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
> +	if (!buf)
> +		return NULL;
>  	buf->padding = kmalloc(chan->n_subbufs * sizeof(size_t *), GFP_KERNEL);
>  	if (!buf->padding)
>  		goto free_buf;
> @@ -574,6 +578,8 @@ struct rchan *relay_open(const char *base_filename,
>  
>  	if (!(subbuf_size && n_subbufs))
>  		return NULL;
> +	if (subbuf_size > UINT_MAX / n_subbufs)
> +		return NULL;
>  
>  	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
>  	if (!chan)
> --


numerical this is ok, but ...
maybe it is better to cap the chan->n_subbufs at a useful number ?
The user can still allocate an insane number of bytes.
Restricting subbuf_size*n_subbufs seems more logical (otherwise is this a real problem ?)

re,
 wh
