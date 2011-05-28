Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab1E1XeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 19:34:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19574 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab1E1XeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 19:34:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=o2nrK/Hk1zmSXedvYRXiWBmgF4bXpf3jisdapwviuqm0++bkwObAVlg5WntC8dWcwl
         XvsxK1sH7Yvbh4tvXO2g==
Date: Sat, 28 May 2011 16:34:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: IrDA driver fails on PXA255
In-Reply-To: <20110528205701.GA1788@doriath.ww600.siemens.net>
Message-ID: <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com>
References: <20110528205701.GA1788@doriath.ww600.siemens.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 May 2011, Dmitry Eremin-Solenikov wrote:

> Hello,
> 
> Since a197b59ae6e8bee56fcef37ea2482dc08414e2ac (mm: fail GFP_DMA
> allocations when ZONE_DMA is not configured), pxaficp_ir.c driver fails
> to probe: pxa_irda_init_iobuf asks for a buffer with GFP_KERNEL |
> GFP_DMA flags, which fail nicely with the following trace:
> 
> ------------[ cut here ]------------
> WARNING: at mm/page_alloc.c:2251
> __alloc_pages_nodemask+0xa0/0x5ac()
> Modules linked in:
> [<c00385b0>] (unwind_backtrace+0x0/0xf0) from [<c0050b1c>] (warn_slowpath_common+0x4c/0x64)
> [<c0050b1c>] (warn_slowpath_common+0x4c/0x64) from [<c0050b4c>] (warn_slowpath_null+0x18/0x1c)
> [<c0050b4c>] (warn_slowpath_null+0x18/0x1c) from [<c00908ec>] (__alloc_pages_nodemask+0xa0/0x5ac)
> [<c00908ec>] (__alloc_pages_nodemask+0xa0/0x5ac) from [<c0090e74>] (__get_free_pages+0x10/0x3c)
> [<c0090e74>] (__get_free_pages+0x10/0x3c) from [<c01d608c>] (pxa_irda_init_iobuf+0x18/0x48)
> [<c01d608c>] (pxa_irda_init_iobuf+0x18/0x48) from [<c01d61d8>] (pxa_irda_probe+0x11c/0x32c)
> [<c01d61d8>] (pxa_irda_probe+0x11c/0x32c) from [<c019474c>] (platform_drv_probe+0x14/0x18)
> [<c019474c>] (platform_drv_probe+0x14/0x18) from [<c0193508>] (really_probe+0xa0/0x158)
> [<c0193508>] (really_probe+0xa0/0x158) from [<c019360c>] (driver_probe_device+0x4c/0x64)
> [<c019360c>] (driver_probe_device+0x4c/0x64) from [<c0193684>] (__driver_attach+0x60/0x84)
> [<c0193684>] (__driver_attach+0x60/0x84) from [<c0192d78>] (bus_for_each_dev+0x48/0x84)
> [<c0192d78>] (bus_for_each_dev+0x48/0x84) from [<c01926b8>] (bus_add_driver+0xa8/0x220)
> [<c01926b8>] (bus_add_driver+0xa8/0x220) from [<c0193c7c>] (driver_register+0xac/0x13c)
> [<c0193c7c>] (driver_register+0xac/0x13c) from [<c0033440>] (do_one_initcall+0x94/0x16c)
> [<c0033440>] (do_one_initcall+0x94/0x16c) from [<c00083f4>] (kernel_init+0x94/0x140)
> [<c00083f4>] (kernel_init+0x94/0x140) from [<c00348d0>] (kernel_thread_exit+0x0/0x8)
> ---[ end trace 0b8bf08f70147098 ]---
> 

The driver is attempting to allocate DMA memory and you have 
CONFIG_ZONE_DMA disabled, which is the only reason you would get this 
warning.  If the allocation did not fail as a result of a197b59ae6e8, the 
page allocator may return any memory in a higher zone that the driver may 
not be expecting.  If you had never noticed a problem before, it may be 
possible that the driver doesn't actually have any zone restrictions and 
GFP_DMA can be removed, but this code is pretty old.  Otherwise, it'll 
need to depend on ZONE_DMA in the Kconfig.

Let's cc Nicolas and Russell as well.
