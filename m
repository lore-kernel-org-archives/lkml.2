Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab2GYFJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 01:09:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56401 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2GYFJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 01:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <1343025161.2957.22.camel@pasglop>
References: <alpine.LSU.2.00.1207211911160.1585@eggly.anvils>
 <1343011543.2957.2.camel@pasglop> <1343025161.2957.22.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 24 Jul 2012 23:09:11 -0600
X-Google-Sender-Auth: O1O8eXSWFRlaOQkHtQ_Cu3Nst6M
Message-ID: <CACxGe6vKUsUJnyef+DWfmQtpzGk8c6-Hta54VjCUWzss3Ej2gw@mail.gmail.com>
Subject: Re: More irqdomain problems (Was: next/mmotm unbootable on G5: irqdomain)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Hugh Dickins <hughd@google.com>, Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 12:32 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> Allright, another one Grant:
>
> unsigned int irq_find_mapping(struct irq_domain *domain,
>                               irq_hw_number_t hwirq)
> {
>         struct irq_data *data;
>
>         /* Look for default domain if nececssary */
>         if (domain == NULL)
>                 domain = irq_default_domain;
>         if (domain == NULL)
>                 return 0;
>
>         switch (domain->revmap_type) {
>         case IRQ_DOMAIN_MAP_LEGACY:
>                 return irq_domain_legacy_revmap(domain, hwirq);
>         case IRQ_DOMAIN_MAP_LINEAR:
>                 return irq_linear_revmap(domain, hwirq);
>         case IRQ_DOMAIN_MAP_TREE:
>                 rcu_read_lock();
>                 data = radix_tree_lookup(&domain->revmap_data.tree, hwirq);
>                 rcu_read_unlock();
>                 if (data)
>                         return data->irq;
> -               break;
> +               return 0;
>         case IRQ_DOMAIN_MAP_NOMAP:
>
> Please, stick a proper commit message and my s-o-b and see if you can fix
> your tree before you ask Linus to pull because that's not pretty on any
> pseries .... irq_find_mapping() does get called for all interrupt the
> first time it's mapped to check if there's a pre-existing mapping, so
> the case of the thing being unpopulated is absolutely legit.
>
> the NOMAP case has a similar dubious exit case but since I'm not that
> familiar with NOMAP I haven't touched it.

I've decided to rework the patch to simply omit the WARN statement. It
isn't really needed. I've merged in Linus' tree below the eliminate
slow-path patch and remove the WARN statement. It's been pushed out to
my irqdomain/next branch, so it should show up in tomorrow's
linux-next.

You can find it here if you want to give it a spin:

git://git.secretlab.ca/git/linux-2.6 irqdomain/next

I'll give it a bit more time in linux-next before I ask Linus to pull.

g.
