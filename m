Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab0CWJZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 05:25:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49081 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325Ab0CWJZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 05:25:50 -0400
Subject: Re: [PATCH RFC] kmemleak vs. memory hotplug
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: jbarnes@virtuousgeek.org, prarit@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100322195149.GA2278@redhat.com>
References: <20100322195149.GA2278@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Tue, 23 Mar 2010 09:25:28 +0000
Message-ID: <1269336328.29545.10.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Mar 2010 09:25:29.0817 (UTC) FILETIME=[C7A2F490:01CACA6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 19:51 +0000, Jason Baron wrote:
> I noticed in the Kconfig that kmemleak can not be set without
> MEMORY_HOTPLUG being unset. I'd like to be able to enable both. Below,
> is an rfc patch, completely untested, as a starting point. Hopefully,
> ppl more knowledgeable in this area can comment.
[...]
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 5b069e4..509a728 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -102,6 +102,9 @@
>  #include <linux/kmemcheck.h>
>  #include <linux/kmemleak.h>
> 
> +/* exlcludes memory hotplug */
> +DEFINE_MUTEX(kmemleak_hotplug);
> +
>  /*
>   * Kmemleak configuration and common defines.
>   */
> @@ -1178,6 +1181,7 @@ static void kmemleak_scan(void)
>          * Struct page scanning for each node. The code below is not yet safe
>          * with MEMORY_HOTPLUG.
>          */
> +       mutex_lock(&kmemleak_hotplug);
>         for_each_online_node(i) {
>                 pg_data_t *pgdat = NODE_DATA(i);
>                 unsigned long start_pfn = pgdat->node_start_pfn;
> @@ -1196,6 +1200,7 @@ static void kmemleak_scan(void)
>                         scan_block(page, page + 1, NULL, 1);
>                 }
>         }
> +       mutex_unlock(&kmemleak_hotplug);

An alternative (not sure whether it's feasible) may be to inform
kmemleak about the pg_data_t objects (via kmemleak_alloc) sometime
during initialisation and add hooks to memory hotplug to remove or add
such objects from kmemleak during hotplug events.

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 78e34e6..01fc57d 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -34,6 +34,23 @@
> 
>  #include "internal.h"
> 
> +/* exclude subsystems that hotplug might conflict with */
> +static void lock_hotplug_exlucde(void)
> +{
> +       /* exclude hotplug */
> +       lock_system_sleep();
> +       /* exlucde kmemleak */
> +       lock_system_kmemleak();
> +}
> +
> +static void unlock_hotplug_exlucde(void)
> +{
> +       /* exclude hotplug */
> +       unlock_system_sleep();
> +       /* exlucde kmemleak */
> +       unlock_system_kmemleak();
> +}

I think the unlocking should be done in the reversed order.

Thanks.

-- 
Catalin

