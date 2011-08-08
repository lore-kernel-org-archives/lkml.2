Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1HHXpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:45:21 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:59846 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751080Ab1HHXpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:45:19 -0400
Subject: Re: [PATCH] lib/sha1: remove memsets and allocate workspace on the
 stack
From: Joe Perches <joe@perches.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Joachim Eastwood <manabian@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1312844837-10086-1-git-send-email-msb@chromium.org>
References: <1312844837-10086-1-git-send-email-msb@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 16:45:15 -0700
Message-ID: <1312847115.1643.22.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 16:07 -0700, Mandeep Singh Baines wrote:
> The previous implementation required the workspace to be passed in as
> a parameter. This prevents the compiler from being able to store the
> workspace in registers. I've also removed the memset since that also
> prevents the compiler from storing the workspace in registers.

I did a similar patch locally.

> There is no loss of security due to removing the memset. It would be a
> bug for the stack to leak to userspace. However, a defence-in-depth
> argument could be made for keeping the clearing of the workspace.

You should add #include <linux/crypthash.h> to
lib/sha1.c and perhaps rationalize the use of __u8
and char for the second argument to sha_transform in
the definition and uses.

For defense in depth, a bool could be added to sha_transform
like:

void sha_transform(__u32 *digest, const char *data, bool wipe);

and the internal workspace memset after use if wipe set though
perhaps the memset could be a compile time option like
CONFIG_CRYPTO_DEFENSE_IN_DEPTH or such instead.

> diff --git a/drivers/char/random.c b/drivers/char/random.c
[]
> @@ -816,13 +816,13 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
>  static void extract_buf(struct entropy_store *r, __u8 *out)
[]
> -		sha_transform(hash, (__u8 *)(r->pool + i), workspace);
> +		sha_transform(hash, (__u8 *)(r->pool + i));
[]
> diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
[]
> @@ -3,10 +3,9 @@
[]
> -void sha_transform(__u32 *digest, const char *data, __u32 *W);
> +void sha_transform(__u32 *digest, const char *data);
[]
> diff --git a/lib/sha1.c b/lib/sha1.c
[]
> +void sha_transform(__u32 *digest, const char *data)
[]
> diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
[]
> @@ -50,7 +49,7 @@ static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport,
[]
> -	sha_transform(tmp + 16, (__u8 *)tmp, tmp + 16 + 5);
> +	sha_transform(tmp + 16, (__u8 *)tmp);
[]
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
[]
> @@ -2511,8 +2510,7 @@ struct sk_buff *tcp_make_synack(struct sock *sk, struct dst_entry *dst,
[]
>  			sha_transform((__u32 *)&xvp->cookie_bakery[0],
> -				      (char *)mess,
> -				      &workspace[0]);
> +				      (char *)mess);
[]
> diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
[]
> @@ -81,7 +80,7 @@ static u32 cookie_hash(const struct in6_addr *saddr, const struct in6_addr *dadd
[]
> -	sha_transform(tmp + 16, (__u8 *)tmp, tmp + 16 + 5);
> +	sha_transform(tmp + 16, (__u8 *)tmp);


