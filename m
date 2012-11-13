Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2KMI2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:28:02 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55303 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2KMI2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:28:00 -0500
Date: Tue, 13 Nov 2012 00:27:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ethan Zhao <ethan.kernel@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com
Subject: Re: ACPI and NUMA guys, please help to check if this patch is OK
In-Reply-To: <CABawtvOC8grVSB6oXb1snsncuku+HtyaRjCUMkaiPaVfPurr7w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1211130024060.18379@chino.kir.corp.google.com>
References: <CABawtvNSYENtrJTaB5Vfd+j5MahE=xv4Ueb6-zmd1CHShuU0iQ@mail.gmail.com> <alpine.DEB.2.00.1205222029590.28165@chino.kir.corp.google.com> <CABawtvM-ZzFvT3LLb5V2bm52odeSyxeQwwvbVXgrNcMX5WMrbQ@mail.gmail.com> <alpine.DEB.2.00.1205232142120.10366@chino.kir.corp.google.com>
 <CABawtvMtO5NR-j3zX2xxXfgZ_XxrCdF+k+n4jG3KyEVe=xYjjA@mail.gmail.com> <CABawtvOC8grVSB6oXb1snsncuku+HtyaRjCUMkaiPaVfPurr7w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Ethan Zhao wrote:

> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index e56f3be..55c8a8e 100644
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -161,6 +161,13 @@ static __init int slit_valid(struct acpi_table_slit *slit)
>  {
>         int i, j;
>         int d = slit->locality_count;
> +       int pxd = nodes_weight(nodes_found_map);
> +       if (pxd != d) {
> +               printk(KERN_INFO "ACPI: BIOS bug! SLIT localities
> count %d doesn't equal SRAT proximity domains number %d\n",
> +                       d , pxd);
> +               return 0;
> +       }
> +
>         for (i = 0; i < d; i++) {
>                 for (j = 0; j < d; j++)  {
>                         u8 val = slit->entry[d*i + j];

This is incorrect: the SLIT locality count comes straight from the BIOS 
whereas the maximum number of nodes the kernel supports is defined by 
CONFIG_NODES_SHIFT.  If this patch were to be merged, the SLIT is 
invalidated when CONFIG_NODES_SHIFT is too low whereas today we respect 
the proximity of nodes that can be onlined which is a regression.
