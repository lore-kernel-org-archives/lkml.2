Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0DNTZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 15:25:49 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:33891 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab0DNTZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 15:25:48 -0400
Date: Wed, 14 Apr 2010 12:25:46 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH -v2 1/2] x86: Reserve [0xa0000, 0x100000] in e820 map
Message-ID: <20100414192546.GA11130@hexapodia.org>
References: <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org> <4BC39F67.4090407@oracle.com> <1271192527.6035.44.camel@dc7800.home> <4BC4DD85.5030203@zytor.com> <4BC4DDEA.60202@oracle.com> <4BC4DFAD.9020600@zytor.com> <4BC4E55B.7000103@oracle.com> <4BC4E8FB.8060802@zytor.com> <4BC51312.6080302@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC51312.6080302@oracle.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 05:57:54PM -0700, Yinghai wrote:
> On 04/13/2010 02:58 PM, H. Peter Anvin wrote:
> > That's not good (in general - for devices in this particular range it's
> > not such a big deal, but it is potentially really bad for devices marked
> > reserved for them not to be moved.)
> > 
> > We have talked about a need to resolve this before.
> 
> this one should make both cases work.
> 
> Andy, can you check this one together with
> v3: x86: Reserve [0xa0000, 0x100000] in e820 map

I've booted successfully with the patch below, on top of the patch in
Message-ID: <4BC4E09F.9000608@oracle.com>

I'll attach the dmesg to bug 15744.

-andy

> Guenter, can you try the two patches on the system with special device?
> 
> Thanks
> 
> Yinghai
> 
> --------
> 
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
