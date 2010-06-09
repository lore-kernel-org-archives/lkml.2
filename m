Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab0FIHUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:20:13 -0400
Received: from mail4.comsite.net ([205.238.176.238]:2247 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab0FIHUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:20:11 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.20.111.250;
From: Milton Miller <miltonm@bga.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 00/12] treewide: Remove unnecessary kmalloc casts
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
	<96933b66aa5f995746a34410ca63e5e8b84593cb.1275968594.git.joe@perches.com>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Date: Wed, 09 Jun 2010 02:20:01 -0500
X-Originating-IP: 71.20.111.250
Message-ID: <1276068001_13533@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon Jun 07 2010 at around 23:53:18 EST, Joe Perches wrote:
> Trivial cleanups
> 
> arch/cris: Remove unnecessary kmalloc casts
> arch/powerpc: Remove unnecessary kmalloc casts
> arch/x86/kernel/tlb_uv.c: Remove unnecessary kmalloc casts
> drivers/gpu/drm: Remove unnecessary kmalloc casts
> drivers/isdn/capi/capidrv.c: Remove unnecessary kmalloc casts
> drivers/media: Remove unnecesary kmalloc casts
> drivers/message/i2o/i20_config.c: Remove unnecessary kmalloc casts
> drivers/parisc/iosapic.c: Remove unnecessary kzalloc cast
> drivers/s390: Remove unnecessary kmalloc casts
> drivers/serial/icom.c: Remove unnecessary kmalloc casts
> drivers/usb/storage/isd200.c: Remove unnecessary kmalloc casts
> fs/ufs/util.c: Remove unnecessary kmalloc casts
> 

Joe,

Thanks for doing cleanups.

However, in this case you are removing casts that, while not necessary
for C, are indeed there for a reason.

Specifically, they are of the form
   type *p;
   <code>
   p = (type *)kmalloc(sizeof(type), ...);

For example, from the powerpc patch:
> goto out;
> }
> - tmp_part = (struct nvram_partition *)
> - kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
> + tmp_part = kmalloc(sizeof(struct nvram_partition), GFP_KERNEL);
> err = -ENOMEM;

The reason they casts are present is to guard against someone changing
the type of p at the top of the function and not changing the type at
the kmalloc.

This was discussed some years ago, possibly around the time kcalloc
got its underflow detection.

Should we create a kmalloc wrapper that enforces this type saftey?
While we have added static analysis tools that can check these things,
and we have slab redzoning options, they tend to be run in batch by
"someone else" or in response to debugging a problem.


There may have been discussion of doing the above vs
   p = kmalloc(sizeof(*p), ...);

I don't remember if it was programmer preference or issues when p is
an array type.


I am not subscribed so I don't have the full list that you sent
these to, and I know some maintainers have already taken some of
the series the last time you posted; could you please augment the
CC list.

thanks,
milton
