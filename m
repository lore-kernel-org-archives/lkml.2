Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1KIH2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 02:28:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:47518 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab1KIH2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 02:28:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,482,1315206000"; 
   d="scan'208";a="82713136"
Message-ID: <4EBA2B90.5040901@linux.intel.com>
Date: Wed, 09 Nov 2011 15:28:16 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: gregkh@suse.de, nfont@austin.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug: Refuse to add unaligned memory regions
References: <20110915062615.782bc4df@kryten>
In-Reply-To: <20110915062615.782bc4df@kryten>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/9/15 4:26, Anton Blanchard 写道:
>
> The sysfs memory probe interface allows unaligned regions
> to be added:
>
> # echo 0xffffff>  /sys/devices/system/memory/probe
>
> # cat /proc/iomem
> 00ffffff-01fffffe : System RAM
> 01ffffff-02fffffe : System RAM
> 02ffffff-03fffffe : System RAM
> 03ffffff-04fffffe : System RAM
> 04ffffff-05fffffe : System RAM
>
> Return -EINVAL instead of creating these bad regions.
>
> Signed-off-by: Anton Blanchard<anton@samba.org>
> ---
>
> Index: linux-build/drivers/base/memory.c
> ===================================================================
> --- linux-build.orig/drivers/base/memory.c	2011-08-11 08:25:55.005941391 +1000
> +++ linux-build/drivers/base/memory.c	2011-08-11 08:28:27.938580440 +1000
> @@ -380,9 +380,13 @@ memory_probe_store(struct class *class,
>   	u64 phys_addr;
>   	int nid;
>   	int i, ret;
> +	unsigned long pages_per_block = PAGES_PER_SECTION * sections_per_block;
>
>   	phys_addr = simple_strtoull(buf, NULL, 0);
>
> +	if (phys_addr&  ((pages_per_block<<  PAGE_SHIFT) - 1))
> +		return -EINVAL;
> +
>   	for (i = 0; i<  sections_per_block; i++) {
>   		nid = memory_add_physaddr_to_nid(phys_addr);
>   		ret = add_memory(nid, phys_addr,
> --

what platform doese it affect? PowerPC or else?

As I know, on x86 platform it should not use this interface: *probe*,
instead of acpi_hotplug_xxx. But PowerPC is RISC so how can you add
such weird address for it? Maybe it is because PowerPC uses 16M as
one section size and you assign a wrong address to it intentionally.
The final result is as you show, isn't it?

