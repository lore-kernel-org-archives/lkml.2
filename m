Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab0GTHUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:20:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36305 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab0GTHUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:20:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 20 Jul 2010 16:15:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        greg@kroah.com
Subject: Re: [PATCH 4/8] v3 Allow memory_block to span multiple memory
 sections
Message-Id: <20100720161532.31952577.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C451E1C.8070907@austin.ibm.com>
References: <4C451BF5.50304@austin.ibm.com>
	<4C451E1C.8070907@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 22:55:08 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Update the memory sysfs code that each sysfs memory directory is now
> considered a memory block that can contain multiple memory sections per
> memory block.  The default size of each memory block is SECTION_SIZE_BITS
> to maintain the current behavior of having a single memory section per
> memory block (i.e. one sysfs directory per memory section).
> 
> For architectures that want to have memory blocks span multiple
> memory sections they need only define their own memory_block_size_bytes()
> routine.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> ---
>  drivers/base/memory.c |  141 ++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 98 insertions(+), 43 deletions(-)
> 
> Index: linux-2.6/drivers/base/memory.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/memory.c	2010-07-19 20:44:01.000000000 -0500
> +++ linux-2.6/drivers/base/memory.c	2010-07-19 21:12:22.000000000 -0500
> @@ -28,6 +28,14 @@
>  #include <asm/uaccess.h>
>  
>  #define MEMORY_CLASS_NAME	"memory"
> +#define MIN_MEMORY_BLOCK_SIZE	(1 << SECTION_SIZE_BITS)
> +
> +static int sections_per_block;
> +
> +static inline int base_memory_block_id(int section_nr)
> +{
> +	return (section_nr / sections_per_block) * sections_per_block;
> +}
>  
>  static struct sysdev_class memory_sysdev_class = {
>  	.name = MEMORY_CLASS_NAME,
> @@ -82,22 +90,21 @@ EXPORT_SYMBOL(unregister_memory_isolate_
>   * register_memory - Setup a sysfs device for a memory block
>   */
>  static
> -int register_memory(struct memory_block *memory, struct mem_section *section)
> +int register_memory(struct memory_block *memory)
>  {
>  	int error;
>  
>  	memory->sysdev.cls = &memory_sysdev_class;
> -	memory->sysdev.id = __section_nr(section);
> +	memory->sysdev.id = memory->start_phys_index;

I'm curious that this memory->start_phys_index can't overflow ?
sysdev.id is 32bit.


Thanks,
-Kame

