Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab2BPNYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:24:11 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:48993 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab2BPNYK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:24:10 -0500
MIME-Version: 1.0
In-Reply-To: <1329383368-12122-9-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <1329383368-12122-9-git-send-email-grant.likely@secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 16 Feb 2012 06:23:50 -0700
X-Google-Sender-Auth: eR3wTqNuZvrh4cZZFiL3-pTi_9E
Message-ID: <CACxGe6sKzDzxKUxs2ZVNpf07bzaJSsJ8m+3mdPkU+4mf3EajdQ@mail.gmail.com>
Subject: Re: [PATCH v5 08/27] irq_domain: Move irq_domain code from powerpc to kernel/irq
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 2:09 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> This patch only moves the code.  It doesn't make any changes, and the
> code is still only compiled for powerpc.  Follow-on patches will generalize
> the code for other architectures.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Milton Miller <miltonm@bga.com>
> Tested-by: Olof Johansson <olof@lixom.net>
> ---
> +unsigned int irq_find_mapping(struct irq_domain *host,
> +                             irq_hw_number_t hwirq)
> +{
> +       unsigned int i;
> +       unsigned int hint = hwirq % irq_virq_count;
> +
> +       /* Look for default host if nececssary */
> +       if (host == NULL)
> +               host = irq_default_host;
> +       if (host == NULL)
> +               return NO_IRQ;
> +
> +       /* legacy -> bail early */
> +       if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
> +               return hwirq;
> +
> +       /* Slow path does a linear search of the map */
> +       if (hint == 0)
> +               hint = 1;
> +       i = hint;
> +       do {
> +               struct irq_data *data = irq_get_irq_data(i);
> +               if (data && (data->domain == host) && (data->hwirq == hwirq))
> +                       return i;
> +               i++;
> +               if (i >= irq_virq_count)
> +                       i = 1

Typo on this line; missing semicolon.  Fixed in my tree now.

g.
