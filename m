Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2IXJGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:06:55 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51154 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2IXJGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:06:54 -0400
MIME-Version: 1.0
In-Reply-To: <1343971271-13355-1-git-send-email-linux@horizon.com>
References: <1343971271-13355-1-git-send-email-linux@horizon.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 24 Sep 2012 11:06:33 +0200
Message-ID: <CAK1hOcOwRZs1dDV9Yw22zeVFSTHqScjXv302TEvDVuLgT7bJQg@mail.gmail.com>
Subject: Re: [PATCH 1/4] lib: vsprintf: Optimize division by 10 for small integers.
To: George Spelvin <linux@horizon.com>
Cc: mina86@mina86.com, hughd@google.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 7:21 AM, George Spelvin <linux@horizon.com> wrote:
> Shrink the reciprocal approximations used in put_dec_full4
> based on the comments in put_dec_full9.
>
> Signed-off-by: George Spelvin <linux@horizon.com>
> Cc: Denys Vlasenko <vda.linux@googlemail.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> ---
>  lib/vsprintf.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> I was looking over the code and noticed that the constants could be smaller.
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index c3f36d41..2f32fe8 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -243,13 +243,14 @@ char *put_dec(char *buf, unsigned long long n)
>
>  /* Second algorithm: valid only for 64-bit long longs */
>
> +/* See comment in put_dec_full9 for choice of constants */
>  static noinline_for_stack
>  char *put_dec_full4(char *buf, unsigned q)
>  {
>         unsigned r;
> -       r      = (q * 0xcccd) >> 19;
> +       r      = (q * 0xccd) >> 15;
>         *buf++ = (q - 10 * r) + '0';
> -       q      = (r * 0x199a) >> 16;
> +       q      = (r * 0xcd) >> 11;

I would use 16-bit shifts instead of smaller ones.
There may be CPUs on which "get upper half of 32-bit reg"
operation is cheaper or smaller than a shift.

-- 
vda
