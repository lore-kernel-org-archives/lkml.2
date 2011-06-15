Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1FOGFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 02:05:22 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61509 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1FOGFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 02:05:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=umhvijiqdwI0ixp+Rg6oYcPr9JmpA4fQlLm9D+MiddTlM5ci8WCWO2lUz4i0NXFJIJ
         wF4Ka3hc+XoiDoPJFKx/f2wSFEm3o/QKpliPlaYLopATtEJ6qe6EMKxDQGvBOu1OlDV/
         ddchSZrXevX4NAF1G2hsV6P7hnlgJlwzV+Fk0=
MIME-Version: 1.0
In-Reply-To: <E1QWcgn-0004Mv-T6@eag09.americas.sgi.com>
References: <E1QWcgn-0004Mv-T6@eag09.americas.sgi.com>
Date: Wed, 15 Jun 2011 12:05:17 +0600
Message-ID: <BANLkTinpqPhTNRtqPGnfZznefESwD19iXA@mail.gmail.com>
Subject: Re: [PATCH 1 of 6] x86, UV: smp_processor_id in a preemptable region
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 5:06 AM, Cliff Wickman <cpw@sgi.com> wrote:
> From: Cliff Wickman <cpw@sgi.com>
>
> Calling smp_processor_id() from within a preemptable region will issue
> a warning if DEBUG_PREEMPT is set.
>
> Diffed against 3.0.0-rc3
>
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> ---
>  arch/x86/platform/uv/tlb_uv.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> Index: linux/arch/x86/platform/uv/tlb_uv.c
> ===================================================================
> --- linux.orig/arch/x86/platform/uv/tlb_uv.c
> +++ linux/arch/x86/platform/uv/tlb_uv.c
> @@ -1334,7 +1334,9 @@ static ssize_t tunables_write(struct fil
>
>        instr[count] = '\0';
>
> +       preempt_disable(); /* avoid DEBUG_PREEMPT warning */

I think above code comment, "avoid DEBUG_PREEMPT warning" should be to
something more meaningful. It's a BUG, if smp_processor_id() is called
within preemptible context. So, we don't want to hit that BUG.

>        bcp = &per_cpu(bau_control, smp_processor_id());
> +       preempt_enable_no_resched();
>
>        ret = parse_tunables_write(bcp, instr, count);
>        if (ret)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
