Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0FXUpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 16:45:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53760 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0FXUpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 16:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IX5J/8AG5jh5o5tC0UlMETPYnBFeQyV9++AOAteFqB3vewz8QKdYuALzSqsxn5VO9a
         6JE8/+RYQzfipLRvJK4HHlug5VovNpoPHeR3Imr5eL/uMpWSwW0V2CQLZUzskAu5fdcs
         VVtcKbWWuujL2X9Nfr9x1dImysOXWf57GP59E=
MIME-Version: 1.0
In-Reply-To: <20100624193413.GA20457@sgi.com>
References: <20100624193413.GA20457@sgi.com>
Date: Thu, 24 Jun 2010 13:45:40 -0700
X-Google-Sender-Auth: eAGz1rELEzs5kfPMdMaeA7jwwLA
Message-ID: <AANLkTilTpJuwL52d-u-iYYnh6nw5qYQgLYRt7zdcjktp@mail.gmail.com>
Subject: Re: [PATCH] - irq vector assignment
From: Yinghai Lu <yinghai@kernel.org>
To: Jack Steiner <steiner@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 12:34 PM, Jack Steiner <steiner@sgi.com> wrote:
> Try to assign irqs to cpus on the correct node & fall back to global
> assignment only if node-local fails. This reduces the chances of
> using all of the interrupt vectors of a single cpu.
>
> Signed-off-by: Jack Steiner <steiner@sgi.com>
>
>
> ---
>  arch/x86/kernel/apic/io_apic.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> Index: linux/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/apic/io_apic.c   2010-06-24 12:58:11.658933610 -0500
> +++ linux/arch/x86/kernel/apic/io_apic.c        2010-06-24 13:56:26.734380290 -0500
> @@ -3259,7 +3259,9 @@ unsigned int create_irq_nr(unsigned int
>                desc_new = move_irq_desc(desc_new, node);
>                cfg_new = desc_new->chip_data;
>
> -               if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
> +               if (node >= 0 && __assign_irq_vector(new, cfg_new, node_to_cpumask_map[node]) == 0)
> +                       irq = new;
> +               else if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
>                        irq = new;
>                break;
>        }

how about update apic::target_cpus() to take node?

YH
