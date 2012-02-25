Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab2BYB1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 20:27:18 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50374 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab2BYB1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 20:27:17 -0500
MIME-Version: 1.0
In-Reply-To: <4F48318E.8070902@am.sony.com>
References: <4F48318E.8070902@am.sony.com>
Date: Fri, 24 Feb 2012 20:27:16 -0500
X-Google-Sender-Auth: 3hdlr9zRTssz2Tx7tjT42HatjHQ
Message-ID: <CAP=VYLp7+Apubm=PHRLSw50V9zBKmV-xFRvcO4-qAogJVp7jcw@mail.gmail.com>
Subject: Re: RFC: memory leak in udp_table_init
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        linux kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 7:55 PM, Tim Bird <tim.bird@am.sony.com> wrote:
> We've uncovered an obscure memory leak in the routine udp_table_init(),
> in the file: net/ipv4/udp.c

At a glance, I think what you are seeing is the same as this?

http://lists.openwall.net/netdev/2011/06/22/12

Paul.

>
> The allocation sequence is a bit weird, and I've got some questions
> about the best way to fix it.
>
> Here's the code:
>
> void __init udp_table_init(struct udp_table *table, const char *name)
> {
>        unsigned int i;
>
>        if (!CONFIG_BASE_SMALL)
>                table->hash = alloc_large_system_hash(name,
>                        2 * sizeof(struct udp_hslot),
>                        uhash_entries,
>                        21, /* one slot per 2 MB */
>                        0,
>                        &table->log,
>                        &table->mask,
>                        64 * 1024);
>        /*
>         * Make sure hash table has the minimum size
>         */
>        if (CONFIG_BASE_SMALL || table->mask < UDP_HTABLE_SIZE_MIN - 1) {
>                table->hash = kmalloc(UDP_HTABLE_SIZE_MIN *
>                                      2 * sizeof(struct udp_hslot), GFP_KERNEL);
>                if (!table->hash)
>                        panic(name);
>                table->log = ilog2(UDP_HTABLE_SIZE_MIN);
>                table->mask = UDP_HTABLE_SIZE_MIN - 1;
>        }
>        ...
>
> We've seen instances where the second allocation of table->hash
> is performed, wiping out the first hash table allocation, without a
> free.  This ends up leaking the previously allocated hash table.
>
> That is, if we are !CONFIG_BASE_SMALL and for some reason
> the alloc_large_system_hash() operation returns less than UDP_HTABLE_SIZE_MIN
> hash slots, then it will trigger this.
>
> There's no complementary "free_large_system_hash()" which can be used to
> back out of the first allocation, that I can find.
>
> We are currently doing the following to avoid the memory leak, but this
> seems like it defeats the purpose of checking for the minimum size
> (that is, if the first allocation was too small, we don't re-allocate).
>
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 5d075b5..2524af4 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2194,7 +2194,8 @@ void __init udp_table_init(struct udp_table *table, const char *name)
>        /*
>         * Make sure hash table has the minimum size
>         */
> -       if (CONFIG_BASE_SMALL || table->mask < UDP_HTABLE_SIZE_MIN - 1) {
> +       if ((CONFIG_BASE_SMALL || table->mask < UDP_HTABLE_SIZE_MIN - 1)
> +               && !table->hash) {
>                table->hash = kmalloc(UDP_HTABLE_SIZE_MIN *
>                                      2 * sizeof(struct udp_hslot), GFP_KERNEL);
>                if (!table->hash)
>
> Any suggestions for a way to correct for a too-small first allocation, without
> a memory leak?
>
> Alternatively - how critical is this UDP_HTABLE_SIZE_MIN for correct operation
> of the stack?
>
> Thanks for any information you can provide.
>
>  -- Tim
>
> =============================
> Tim Bird
> Architecture Group Chair, CE Workgroup of the Linux Foundation
> Senior Staff Engineer, Sony Network Entertainment
> =============================
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
