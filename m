Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab0GTHGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:06:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35601 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab0GTHGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:06:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 20 Jul 2010 16:01:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        greg@kroah.com
Subject: Re: [PATCH 3/8] v3 Add section count to memory_block
Message-Id: <20100720160131.7cc8c0a2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C451DD6.3080005@austin.ibm.com>
References: <4C451BF5.50304@austin.ibm.com>
	<4C451DD6.3080005@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 22:53:58 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Add a section count property to the memory_block struct to track the number
> of memory sections that have been added/removed from a emory block.
> 
> Signed-off-by: Nathan Fontenot <nfont@asutin.ibm.com>
> ---
>  drivers/base/memory.c  |   19 ++++++++++++-------
>  include/linux/memory.h |    2 ++
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/drivers/base/memory.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/memory.c	2010-07-19 20:43:49.000000000 -0500
> +++ linux-2.6/drivers/base/memory.c	2010-07-19 20:44:01.000000000 -0500
> @@ -487,6 +487,7 @@ static int add_memory_block(int nid, str
>  
>  	mem->start_phys_index = __section_nr(section);
>  	mem->state = state;
> +	atomic_inc(&mem->section_count);
>  	mutex_init(&mem->state_mutex);
>  	start_pfn = section_nr_to_pfn(mem->start_phys_index);
>  	mem->phys_device = arch_get_memory_phys_device(start_pfn);
> @@ -516,13 +517,17 @@ int remove_memory_block(unsigned long no
>  	struct memory_block *mem;
>  
>  	mem = find_memory_block(section);
> -	unregister_mem_sect_under_nodes(mem);
> -	mem_remove_simple_file(mem, start_phys_index);
> -	mem_remove_simple_file(mem, end_phys_index);
> -	mem_remove_simple_file(mem, state);
> -	mem_remove_simple_file(mem, phys_device);
> -	mem_remove_simple_file(mem, removable);
> -	unregister_memory(mem, section);
> +	atomic_dec(&mem->section_count);
> +
> +	if (atomic_read(&mem->section_count) == 0) {

We use atomic_dec_and_test() in usual.

Otherwise, I don't see other problems in other part. Please fix this nitpick.

Regards,
-Kame


