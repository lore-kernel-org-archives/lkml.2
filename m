Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab1BRA6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:58:30 -0500
Received: from smtp-out.google.com ([74.125.121.67]:63425 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab1BRA6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:58:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gxLIMJaMaQQfWlaSAnjcGc6xw6mn5tp6CNbqSNnxCVvskVUejv0JTn/kbswkmY0SQ3
         yt98B7Sv2Gv0GeQRPUHA==
MIME-Version: 1.0
In-Reply-To: <1297373487-23902-3-git-send-email-ccross@android.com>
References: <1297373487-23902-1-git-send-email-ccross@android.com>
	<1297373487-23902-3-git-send-email-ccross@android.com>
Date: Thu, 17 Feb 2011 16:58:09 -0800
X-Google-Sender-Auth: amGtMfxR_mQzEcR2g0CGQ4jew90
Message-ID: <AANLkTik3O_keaFh25kd_Pr7dkiSAG5rg3-ZGZ7wAVN6S@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] ARM: gic: Use cpu pm notifiers to save gic state
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, santosh.shilimkar@ti.com, catalin.marinas@arm.com,
        will.deacon@arm.com, Colin Cross <ccross@android.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Chao Xie <chao.xie@marvell.com>,
        Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 1:31 PM, Colin Cross <ccross@android.com> wrote:

<snip>

> +#ifdef CONFIG_PM
> +       u32 saved_spi_enable[DIV_ROUND_UP(1020, 32)];
> +       u32 saved_spi_conf[DIV_ROUND_UP(1020, 16)];
> +       u32 saved_spi_pri[DIV_ROUND_UP(1020, 4)];
> +       u32 saved_spi_target[DIV_ROUND_UP(1020, 4)];
> +       u32 __percpu *saved_ppi_enable;
> +       u32 __percpu *saved_ppi_conf;
> +       u32 __percpu *saved_ppi_pri;
> +#endif
The #ifdef CONFIG_PM breaks building !CONFIG_PM, and this should
depend on CONFIG_CPU_IDLE, not CONFIG_PM.

> +static void gic_cpu_save(unsigned int gic_nr)
> +{
> +       int i;
> +       u32 *ptr;
> +       void __iomem *dist_base;
> +       void __iomem *cpu_base;
> +
> +       if (gic_nr >= MAX_GIC_NR)
> +               BUG();
> +
> +       dist_base = gic_data[gic_nr].dist_base;
> +       cpu_base = gic_data[gic_nr].cpu_base;
> +
> +       if (!dist_base || !cpu_base)
> +               return;
> +
> +       ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_enable);
> +       for (i = 0; i < DIV_ROUND_UP(32, 32); i++)
> +               ptr[i] = readl(dist_base + GIC_DIST_ENABLE_SET + i * 4);
> +
> +       ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_conf);
> +       for (i = 0; i < DIV_ROUND_UP(32, 16); i++)
> +               ptr[i] = readl(dist_base + GIC_DIST_CONFIG + i * 4);
> +
> +       ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_pri);
> +       for (i = 0; i < DIV_ROUND_UP(32, 4); i++)
> +               ptr[i] = readl(dist_base + GIC_DIST_PRI + i * 4);
> +
> +       writel(0, cpu_base + GIC_CPU_CTRL);
> +}
Disabling the GIC cpu interface here prevents SGIs from waking the CPU
from WFI.  On Tegra2, it is useful to be able to go to WFI, and then
either back to normal or into reset depending on the state of the
other CPU.  Is it safe to leave the GIC CPU control on when going to
reset?
