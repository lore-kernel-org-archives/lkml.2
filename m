Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab1DLQlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:41:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62539 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1DLQlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:41:22 -0400
Date: Tue, 12 Apr 2011 12:39:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org, yinghai@kernel.org, hpa@linux.intel.com,
        mingo@elte.hu
Subject: Re: [PATCH 3/4] xen: more debugging in the e820 parsing
Message-ID: <20110412163957.GA1067@dumpdata.com>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
 <1302607192-21355-3-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302607192-21355-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 12:19:51PM +0100, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

I am not entirely sure if we need these. You get all of this data by looking
at the Xen E820 and the guest E820 (to see the xen_extra_mem):

(XEN) Xen-e820 RAM map:
(XEN)  0000000000000000 - 000000000009f800 (usable)
(XEN)  000000000009f800 - 00000000000a0000 (reserved)
(XEN)  00000000000f0000 - 0000000000100000 (reserved)
(XEN)  0000000000100000 - 00000000cf5e0000 (usable)
(XEN)  00000000cf5e0000 - 00000000cf5e3000 (ACPI NVS)
(XEN)  00000000cf5e3000 - 00000000cf5f0000 (ACPI data)
(XEN)  00000000cf5f0000 - 00000000cf600000 (reserved)
(XEN)  00000000e0000000 - 00000000f0000000 (reserved)
(XEN)  00000000fec00000 - 0000000100000000 (reserved)
(XEN)  0000000100000000 - 0000000130000000 (usable)
..

[    0.000000] BIOS-provided physical RAM map:
.. snip..
[    0.000000]  Xen: 0000000100000000 - 00000001a19e0000 (usable)

And your patch adds this:

[    0.000000] e820_region: type=1 start=0000000000000000 end=000000000009f800
[    0.000000] e820_region: type=2 start=000000000009f800 end=00000000000a0000
[    0.000000] e820_region: type=2 start=00000000000f0000 end=0000000000100000
[    0.000000] e820_region: type=1 start=0000000000100000 end=00000000cf5e0000
[    0.000000] e820_region: type=4 start=00000000cf5e0000 end=00000000cf5e3000
[    0.000000] e820_region: type=3 start=00000000cf5e3000 end=00000000cf5f0000
[    0.000000] e820_region: type=2 start=00000000cf5f0000 end=00000000cf600000
[    0.000000] e820_region: type=2 start=00000000e0000000 end=00000000f0000000
[    0.000000] e820_region: type=2 start=00000000fec00000 end=0000000100000000
[    0.000000] e820_region: type=1 start=0000000100000000 end=0000000130000000
[    0.000000] released 0 pages of unused memory
[    0.000000] extra e820 region: start=0000000100000000 end=00000001a19e0000

> ---
>  arch/x86/xen/setup.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index fa0269a..9c38bd1 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -61,6 +61,8 @@ static __init void xen_add_extra_mem(unsigned long pages)
>  		return;
>  
>  	e820_add_region(extra_start, size, E820_RAM);
> +	printk(KERN_DEBUG "extra e820 region: start=%016Lx end=%016Lx\n",
> +			extra_start, extra_start + size);
>  	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
>  
>  	memblock_x86_reserve_range(extra_start, extra_start + size, "XEN EXTRA");
> @@ -231,6 +233,8 @@ char * __init xen_memory_setup(void)
>  	for (i = 0; i < memmap.nr_entries; i++) {
>  		unsigned long long end;
>  
> +		printk(KERN_DEBUG "e820_region: type=%d start=%016Lx end=%016Lx",
> +				map[i].type, map[i].addr, map[i].size + map[i].addr);
>  		/* Guard against non-page aligned E820 entries. */
>  		if (map[i].type == E820_RAM)
>  			map[i].size -= (map[i].size + map[i].addr) % PAGE_SIZE;
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
