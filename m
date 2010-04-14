Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0DNQzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:55:55 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:3229 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab0DNQzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:55:53 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai <yinghai.lu@oracle.com>
Subject: Re: [PATCH -v2 1/2] x86: Reserve [0xa0000, 0x100000] in e820 map
Date: Wed, 14 Apr 2010 10:55:49 -0600
User-Agent: KMail/1.9.10
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Isaacson <adi@hexapodia.org>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
References: <20100409223532.GC11130@hexapodia.org> <4BC4E8FB.8060802@zytor.com> <4BC51312.6080302@oracle.com>
In-Reply-To: <4BC51312.6080302@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004141055.50172.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 April 2010 06:57:54 pm Yinghai wrote:

> Subject: [PATCH] x86, resource: Add reserve_region_with_split_check_child()
> 
> It will cover the whole region to BUSY, except that some regions that have
> children under them.
> 
> those children normally is PCI bar but it is falling into E820_RESERVED.
> We can not put BUSY on them, otherwise driver can not use pci_request_region()
> later
> 
> /proc/iomem will have
> 00010000-00094fff : System RAM
> 00095000-0009ffff : reserved
> 000a0000-000bffff : PCI Bus 0000:00
>   000a0000-000bffff : reserved
> 000c0000-000cffff : reserved
> 000d0000-000dffff : PCI Bus 0000:00
>   000d0000-000dffff : reserved
> 000e0000-000fffff : reserved
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/e820.c |   10 +++++++---
>  include/linux/ioport.h |    3 +++
>  kernel/resource.c      |   24 +++++++++++++++++++-----
>  3 files changed, 29 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/e820.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/e820.c
> +++ linux-2.6/arch/x86/kernel/e820.c
> @@ -1094,7 +1094,7 @@ void __init e820_reserve_resources(void)
>  		 * pci device BAR resource and insert them later in
>  		 * pcibios_resource_survey()
>  		 */
> -		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
> +		if (e820.map[i].type != E820_RESERVED) {
>  			res->flags |= IORESOURCE_BUSY;
>  			insert_resource(&iomem_resource, res);
>  		}
> @@ -1135,8 +1135,12 @@ void __init e820_reserve_resources_late(
>  
>  	res = e820_res;
>  	for (i = 0; i < e820.nr_map; i++) {
> -		if (!res->parent && res->end)
> -			insert_resource_expand_to_fit(&iomem_resource, res);
> +		if (!res->parent && res->end) {
> +			if (res->start < (1ULL<<20)) {
> +				reserve_region_with_split_check_child(&iomem_resource, res->start, res->end, res->name);
> +			} else
> +				insert_resource_expand_to_fit(&iomem_resource, res);

I don't like adding all these special-purpose resource interfaces, e.g.,
insert_resource_expand_to_fit(), reserve_region_with_split(),
reserve_region_with_split_check_child(), etc.  They tend to be only
used by one caller, which is a clue to me that we're doing something
wrong.

Sometimes we'd like to print debug information in them (as we do in
insert_resource_expand_to_fit()), but we don't have enough context,
so the message isn't very meaningful.

I think it's better to have more generic interfaces that allow us to
implement this sort of functionality where it's used and where we
have the context to print useful messages.  For example, could the
reserve_region_with_split_check_child() functionality be implemented
in e820.c by building on something like request_resource_conflict()?

> +		}
>  		res++;
>  	}
>  
> Index: linux-2.6/include/linux/ioport.h
> ===================================================================
> --- linux-2.6.orig/include/linux/ioport.h
> +++ linux-2.6/include/linux/ioport.h
> @@ -120,6 +120,9 @@ void release_child_resources(struct reso
>  extern void reserve_region_with_split(struct resource *root,
>  			     resource_size_t start, resource_size_t end,
>  			     const char *name);
> +void reserve_region_with_split_check_child(struct resource *root,
> +			     resource_size_t start, resource_size_t end,
> +			     const char *name);
>  extern struct resource *insert_resource_conflict(struct resource *parent, struct resource *new);
>  extern int insert_resource(struct resource *parent, struct resource *new);
>  extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
> Index: linux-2.6/kernel/resource.c
> ===================================================================
> --- linux-2.6.orig/kernel/resource.c
> +++ linux-2.6/kernel/resource.c
> @@ -609,7 +609,7 @@ int adjust_resource(struct resource *res
>  
>  static void __init __reserve_region_with_split(struct resource *root,
>  		resource_size_t start, resource_size_t end,
> -		const char *name)
> +		const char *name, bool check_child)
>  {
>  	struct resource *parent = root;
>  	struct resource *conflict;
> @@ -631,13 +631,18 @@ static void __init __reserve_region_with
>  	kfree(res);
>  
>  	/* conflict covered whole area */
> -	if (conflict->start <= start && conflict->end >= end)
> +	if (conflict->start <= start && conflict->end >= end) {
> +		if (check_child && !conflict->child && strstr(conflict->name, "PCI Bus"))

This is kind of gross, too.  Checking the name of a resource for "PCI Bus"?

Bjorn

> +			__reserve_region_with_split(conflict, start, end, name, false);
>  		return;
> +	}
>  
>  	if (conflict->start > start)
> -		__reserve_region_with_split(root, start, conflict->start-1, name);
> +		__reserve_region_with_split(root, start, conflict->start-1, name, check_child);
>  	if (conflict->end < end)
> -		__reserve_region_with_split(root, conflict->end+1, end, name);
> +		__reserve_region_with_split(root, conflict->end+1, end, name, check_child);
> +	if (check_child && !conflict->child && strstr(conflict->name, "PCI Bus"))
> +		__reserve_region_with_split(conflict, conflict->start, conflict->end, name, false);
>  }
>  
>  void __init reserve_region_with_split(struct resource *root,
> @@ -645,7 +650,16 @@ void __init reserve_region_with_split(st
>  		const char *name)
>  {
>  	write_lock(&resource_lock);
> -	__reserve_region_with_split(root, start, end, name);
> +	__reserve_region_with_split(root, start, end, name, false);
> +	write_unlock(&resource_lock);
> +}
> +
> +void __init reserve_region_with_split_check_child(struct resource *root,
> +		resource_size_t start, resource_size_t end,
> +		const char *name)
> +{
> +	write_lock(&resource_lock);
> +	__reserve_region_with_split(root, start, end, name, true);
>  	write_unlock(&resource_lock);
>  }
>  
> 


