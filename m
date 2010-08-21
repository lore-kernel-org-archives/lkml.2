Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab0HUO4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 10:56:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45970 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0HUO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 10:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VC8Poc9OsSvKaQUY7lqfUBrj/gV4s+jd5lo9qdZzORaIvu9tGFhZl0bTofUOy6Dy6q
         O958Zh4Fyme1xrbrwAb42odttxl3ERbxsbWwdxoTvLg8eR8N8DpjEzqXEcuhNnOlgyRA
         kOIMNCZ4VtRVpxrTfybrFTRojClO8z0ktI36Q=
Subject: Re: [PATCH] My work on MemoryStick system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <292036.65081.qm@web37607.mail.mud.yahoo.com>
References: <292036.65081.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 17:56:19 +0300
Message-ID: <1282402579.4799.20.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-21 at 06:50 -0700, Alex Dubov wrote: 
> > 
> > I just tested this series with Jmicron, and unfortunelly
> > there are bugs.
> > 
> > * driver refuses to handle 26 byte TPC I use to read regs
> > (sizeof(ms_registers). If I bump it to 32, it works.
> 
> It will work with any multiply of 4 (24 and 28 work as well). It's a known
> "feature".
Then I bump the size of ms_registers to 32 and leave this as is.
OK?
And I add a warning about this feature of some hardwares someplace.


But what about MS_TPC_GET_INT. This asks for single byte.
Hardware has to support it.



> 
> > 
> > * With this fix first few reads still fail.
> > That means that card isn't detected always because boot
> > blocks might not
> > be read.
> > Later card works fine.
> > 
> > * Also I found out that msproblk.c allocates memory for
> > attributes IO
> > using stock kmalloc, and hangs that to driver.
> > However if driver doesn't support such address, it will
> > fail.
> 
> Why would hardware do anything at all with attribute memory space?
Read it?

You allocate the memory with kmalloc, create a sg with sg_init_one and
pass that to driver.
So therefore it can be from arbitrary address.

In fact swiotlb takes care of that, and I just forgot the dma_unmap_sg
in my r592.c...


> 
> > I fixed that in my driver by properly calling dma_unmap_sg,
> > and thus
> > using SWIOTLB if necessary.
> > But Jmicron driver doesn't unmap its sg.
It does btw, didn't notice.... 
> > (Yet the system with Jmicron device has just one GB, so
> > this isn't the
> > problem I am seeing).

I found further problems in jmicron driver:


1. Serial mode doesn't work well.
I first read the boot block, and then enable parallel mode.
I do so because boot block has a flag that tells if parallel mode is
supported.
It turns out that sector reads often don't finish, especially first and
often second one which contain boot blocks.
If I enable parallel mode right away problem goes away.


2. the MS_TPC_WRITE_LONG_DATA fail, therefore I can't write anything to
the stick.

As soon as my driver starts to write a block,  first
MS_TPC_WRITE_LONG_DATA succeeds, but second one timeouts.
(there is no MS_TPC_GET_INT in between, because of parallel mode).

Maybe I do something wrong in my ms_block.c, but I checked it many
times, and it appears to be correct, and it works fine with r592.c


Best regards,
Maxim Levitsky



