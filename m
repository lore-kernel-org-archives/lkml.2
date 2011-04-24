Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab1DXDPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 23:15:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62496 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab1DXDPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 23:15:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UOVM/LcQIsqNHMHKs59pp8kGE2sHwrh2DCoDWWqL28nYPx9OyHDw2XZLkzsfWKldNZ
         Ygp/IW7HZnim+c2MDLBdVxZCRUz6kdkpMi61GJ7OHe7hnd195Z7dwMpNnjEjpqFJpm1D
         F+ExBDQewKLAaTwtrhNjU9LDWLyiZDgdIJbXo=
MIME-Version: 1.0
In-Reply-To: <4DB3840F.3060503@gmail.com>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
 <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211500170.5741@router.home> <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com> <4DB3840F.3060503@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sun, 24 Apr 2011 12:14:43 +0900
Message-ID: <BANLkTi=vm-qs48-JySCpv+YHyC+9sO9U0A@mail.gmail.com>
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
To: Michael Schmitz <schmitzmic@googlemail.com>
Cc: David Rientjes <rientjes@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
        "tg@mirbsd.de >> Thorsten Glaser" <tg@mirbsd.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/24 Michael Schmitz <schmitzmic@googlemail.com>:
> David Rientjes wrote:
>>
>> For m68k, N_NORMAL_MEMORY represents all nodes that have present memory
>> since it does not support HIGHMEM.  This patch sets the bit at the time the
>> node is brought online.
>>
>> If N_NORMAL_MEMORY is not accurate, slub may encounter errors since it
>> uses this nodemask to setup per-cache kmem_cache_node data structures.
>>
>> Signed-off-by: David Rientjes <rientjes@google.com>
>> ---
>>  arch/m68k/mm/init_mm.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/m68k/mm/init_mm.c b/arch/m68k/mm/init_mm.c
>> --- a/arch/m68k/mm/init_mm.c
>> +++ b/arch/m68k/mm/init_mm.c
>> @@ -59,6 +59,8 @@ void __init m68k_setup_node(int node)
>>        }
>>  #endif
>>        pg_data_map[node].bdata = bootmem_node_data + node;
>> +       if (node_present_pages(node))
>> +               node_set_state(node, N_NORMAL_MEMORY);
>>        node_set_online(node);
>>  }
>>
>
> As Andreas pointed out, node_present_pages is set in free_area_init_node
> which only gets called at the very end of m68k mm paging_init.
>
> The correct patch would be something like this - the need for the
> conditional is perhaps debatable, seeing as we set the pages present just
> before node_set_state.
>
> Tested on my ARAnyM test setup so far. I'd like to wait for an independent
> kernel image built by Thorsten before I test on the actual hardware. Sorry
> but you'll have to restart your build Thorsten :-)
>
> Signed-off-by: Michael Schmitz <schmitz@debian.org>
> --
> diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
> index 02b7a03..b806c19 100644
> --- a/arch/m68k/mm/motorola.c
> +++ b/arch/m68k/mm/motorola.c
> @@ -300,6 +300,8 @@ void __init paging_init(void)
>               zones_size[ZONE_DMA] = m68k_memory[i].size >> PAGE_SHIFT;
>               free_area_init_node(i, zones_size,
>                                   m68k_memory[i].addr >> PAGE_SHIFT, NULL);
> +                if (node_present_pages(i))
> +                        node_set_state(i, N_NORMAL_MEMORY);
>       }
> }

I think you are right. however I doubt m68k need to care memoryless node check.
probably following patch just work.

------------------------------------
 diff --git a/arch/m68k/mm/init_mm.c b/arch/m68k/mm/init_mm.c
 --- a/arch/m68k/mm/init_mm.c
 +++ b/arch/m68k/mm/init_mm.c
 @@ -59,6 +59,8 @@ void __init m68k_setup_node(int node)
        }
  #endif
        pg_data_map[node].bdata = bootmem_node_data + node;
        node_set_online(node);
+      node_set_state(node, N_NORMAL_MEMORY);


Maybe, the correct solution is to use CONFIG_ARCH_POPULATES_NODE_MAP feature.
the usage is simple, adding add_active_range() and replacing
free_area_init_node() with free_area_init_nodes().

Thanks.
