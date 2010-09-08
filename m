Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0IHUTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:19:16 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:23964 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab0IHUTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:19:08 -0400
Message-ID: <4C87EFB6.2000101@hp.com>
Date: Wed, 08 Sep 2010 16:19:02 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Dan Rosenberg <dan.j.rosenberg@gmail.com>
CC: sri@us.ibm.com, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sctp: prevent reading out-of-bounds memory
References: <AANLkTimtTXpeywA64xUDHZP2RrrtrswyvEB9KeYqhrgU@mail.gmail.com>
In-Reply-To: <AANLkTimtTXpeywA64xUDHZP2RrrtrswyvEB9KeYqhrgU@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 01:21 PM, Dan Rosenberg wrote:
> Two user-controlled allocations in SCTP are subsequently dereferenced
> as sockaddr structs, without checking if the dereferenced struct
> members fall beyond the end of the allocated chunk.  There doesn't
> appear to be any information leakage here based on how these members
> are used and additional checking, but it's still worth fixing.
> 
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> 

Acked-By: Vlad Yasevich <vladislav.yasevich@hp.com>

-vlad

> --- linux-2.6.35.4.orig/net/sctp/socket.c       2010-09-03
> 08:58:48.127080114 -0400
> +++ linux-2.6.35.4/net/sctp/socket.c    2010-09-03 11:52:28.239595395 -0400
> @@ -916,6 +916,12 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
>        /* Walk through the addrs buffer and count the number of addresses. */
>        addr_buf = kaddrs;
>        while (walk_size < addrs_size) {
> +
> +               if (walk_size + sizeof(sa_family_t) > addrs_size) {
> +                       kfree(kaddrs);
> +                       return -EINVAL;
> +               }
> +
>                sa_addr = (struct sockaddr *)addr_buf;
>                af = sctp_get_af_specific(sa_addr->sa_family);
> 
> @@ -1002,9 +1008,14 @@ static int __sctp_connect(struct sock* s
>        /* Walk through the addrs buffer and count the number of addresses. */
>        addr_buf = kaddrs;
>        while (walk_size < addrs_size) {
> +
> +               if (walk_size + sizeof(sa_family_t) > addrs_size) {
> +                       err = -EINVAL;
> +                       goto out_free;
> +               }
> +
>                sa_addr = (union sctp_addr *)addr_buf;
>                af = sctp_get_af_specific(sa_addr->sa.sa_family);
> -               port = ntohs(sa_addr->v4.sin_port);
> 
>                /* If the address family is not supported or if this address
>                 * causes the address buffer to overflow return EINVAL.
> @@ -1013,6 +1024,8 @@ static int __sctp_connect(struct sock* s
>                        err = -EINVAL;
>                        goto out_free;
>                }
> +
> +               port = ntohs(sa_addr->v4.sin_port);
> 
>                /* Save current address so we can work with it */
>                memcpy(&to, sa_addr, af->sockaddr_len);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

