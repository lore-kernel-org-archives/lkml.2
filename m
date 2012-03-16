Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422971Ab2CPO5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:57:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52305 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422825Ab2CPO5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:57:48 -0400
Message-ID: <4F6354E4.8030704@monstr.eu>
Date: Fri, 16 Mar 2012 15:57:40 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Brian Swetland <swetland@google.com>,
        Iliyan Malchev <malchev@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Guzman Lugo Fernando <fernando.lugo@ti.com>,
        Anna Suman <s-anna@ti.com>, Clark Rob <rob@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kieran Bingham <kieranbingham@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/7] remoteproc: resource table overhaul
References: <1330589497-4139-1-git-send-email-ohad@wizery.com> <1330589497-4139-2-git-send-email-ohad@wizery.com>
In-Reply-To: <1330589497-4139-2-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

Ohad Ben-Cohen wrote:
> The resource table is an array of 'struct fw_resource' members, where
> each resource entry is expressed as a single member of that array.
> 
> This approach got us this far, but it has a few drawbacks:
> 
> 1. Different resource entries end up overloading the same members of 'struct
>    fw_resource' with different meanings. The resulting code is error prone
>    and hard to read and maintain.
> 
> 2. It's impossible to extend 'struct fw_resource' without breaking the
>    existing firmware images (and we already want to: we can't introduce the
>    new virito device resource entry with the current scheme).
> 
> 3. It doesn't scale: 'struct fw_resource' must be as big as the largest
>    resource entry type. As a result, smaller resource entries end up
>    utilizing only small part of it.
> 
> This is fixed by defining a dedicated structure for every resource type,
> and then converting the resource table to a list of type-value members.
> Instead of a rigid array of homogeneous structs, the resource table
> is turned into a collection of heterogeneous structures.
> 
> This way:
> 1. Resource entries consume exactly the amount of bytes they need.
> 2. It's easy to extend: just create a new resource entry structure, and assign
>    it a new type.
> 3. The code is easier to read and maintain: the structures' members names are
>    meaningful.
> 
> While we're at it, this patch has several other resource table changes:
> 1. The resource table gains a simple header which contains the
>    number of entries in the table and their offsets within the table. This
>    makes the parsing code simpler and easier to read.
> 2. A version member is added to the resource table. Should we change the
>    format again, we'll bump up this version to prevent breakage with
>    existing firmware images.
> 3. The VRING and VIRTIO_DEV resource entries are combined to a single
>    VDEV entry. This paves the way to supporting multiple VDEV entries.
> 4. Since we don't really support 64-bit rprocs yet, convert two stray u64
>    members to u32.

I don't want to look for in this patch but there is one change which completely
break my remoteproc for dual core ARM.

I am using ohad-github/rpmsg_3.3_rc6_TLV branch and I have also changed resource
table to get it work.

Here is the part of log where you can see what happen.

rproc_handle_virtio_rsc: rsc type 0
rproc_handle_virtio_rsc: rsc type 3
vdev rsc: id 7, dfeatures 1, cfg len 0, 2 vrings
vdev rsc: vring0: da 100000, qsz 256, align 4096
vring0: va e1000000 dma 0 size 3000 idr 0
vdev rsc: vring1: da 104000, qsz 256, align 4096
vring1: va e1004000 dma 4000 size 3000 idr 1
zynq-rproc zynq-rproc.1: powering up cpu1_freertos
zynq-rproc zynq-rproc.1: Booting fw image test, size 211118
iommu not found
rsc: type 0
carveout rsc: da 0, pa 0, len 100000, flags 0
carveout va e1100000, dma 100000, len 0x100000
rsc: type 3
rsc: type 2
trace0 added: va e1140000, da 0x40000, len 0x8000
phdr: type 1 da 0x0 memsz 0x1ae60 filesz 0x14014

The problem which I have is that vdev entry and vrings are handled first
and in __rproc_handle_vring calls dma_alloc_coherent first which caused
that virtaddr points to memory start (remapped to virt addr 0xe1000000)
which should be used by code.

In previous version I had carverout first which means that code was copyied
to physical address 0x0 and then vrigns were allocated. Current code allocate
vring first and then RTOS is not able to run from zero address.

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
