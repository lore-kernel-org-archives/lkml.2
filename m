Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2BCQ1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:27:01 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54804 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab2BCQ06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:26:58 -0500
MIME-Version: 1.0
In-Reply-To: <1328136242-17725-2-git-send-email-yinghai@kernel.org>
References: <1328136242-17725-1-git-send-email-yinghai@kernel.org> <1328136242-17725-2-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 3 Feb 2012 08:26:37 -0800
Message-ID: <CAErSpo6sdsV_ZEkfLq-tGxY4GvyWSz99h31XqS62RjFvthvJhw@mail.gmail.com>
Subject: Re: [PATCH 01/15] Make %pR could handle bus resource with domain
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 2:43 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> So could use %pR for busn_res with domain nr in start/end
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  lib/vsprintf.c |   28 ++++++++++++++++++++++++----
>  1 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 8e75003..b34eeea 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -451,6 +451,12 @@ char *resource_string(char *buf, char *end, struct resource *res,
>                .precision = -1,
>                .flags = SPECIAL | SMALL | ZEROPAD,
>        };
> +       static const struct printf_spec domain_spec = {
> +               .base = 16,
> +               .field_width = 4,
> +               .precision = -1,
> +               .flags = SMALL | ZEROPAD,
> +       };
>        static const struct printf_spec bus_spec = {
>                .base = 16,
>                .field_width = 2,
> @@ -507,11 +513,25 @@ char *resource_string(char *buf, char *end, struct resource *res,
>                specp = &mem_spec;
>                decode = 0;
>        }
> -       p = number(p, pend, res->start, *specp);
> -       if (res->start != res->end) {
> -               *p++ = '-';
> -               p = number(p, pend, res->end, *specp);
> +
> +       if (res->flags & IORESOURCE_BUS && res->end >> 8) {
> +               p = number(p, pend, res->start >> 8, domain_spec);
> +               *p++ = ':';
> +               p = number(p, pend, res->start & 0xff, *specp);
> +               if (res->start != res->end) {
> +                       *p++ = '-';
> +                       p = number(p, pend, res->end >> 8, domain_spec);
> +                       *p++ = ':';
> +                       p = number(p, pend, res->end & 0xff, *specp);

The "<< 8", ">>8", and "& 0xff" patterns are used frequently in these
patches.  I think it's worth adding macros or inline functions to make
it clear that all these places are connected.

> +               }
> +       } else {
> +               p = number(p, pend, res->start, *specp);
> +               if (res->start != res->end) {
> +                       *p++ = '-';
> +                       p = number(p, pend, res->end, *specp);
> +               }
>        }
> +
>        if (decode) {
>                if (res->flags & IORESOURCE_MEM_64)
>                        p = string(p, pend, " 64bit", str_spec);
> --
> 1.7.7
>
