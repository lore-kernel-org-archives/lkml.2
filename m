Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758Ab0HLSvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 14:51:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53389 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab0HLSvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 14:51:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=VJtUYq7nZRKcY/F+pTDCdWAdejmRwwvYaiBD0UeIgMNzvztH3jac/Oy0l7q98ONhNT
         Gbcz+AhCi4RoVsnDHjwrKiiMGwZE0/twGVPxHn8IhuAOjMR7jhjWFisNif1Hah1+v2QY
         YvpyJ4kkS0mYu9QkIs9xWo0t2zYUxDCEpZAyg=
Date: Fri, 13 Aug 2010 00:21:51 +0530
From: Rabin Vincent <rabin@rab.in>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] DMAENGINE: add a slave buffer prep call
Message-ID: <20100812185150.GA4854@debian>
References: <1281476766-7066-1-git-send-email-linus.walleij@stericsson.com>
 <20100811141219.GA5846@debian>
 <AANLkTikD2LwYwsk6Q-7U-P3o+ujhY_0TqgeqOo=hhjA=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikD2LwYwsk6Q-7U-P3o+ujhY_0TqgeqOo=hhjA=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 09:02:04PM +0200, Linus Walleij wrote:
> 2010/8/11 Rabin Vincent <rabin@rab.in>:
> > On Tue, Aug 10, 2010 at 11:46:06PM +0200, Linus Walleij wrote:
> >> This makes it possible for engines to implement slave transfers
> >> to be done to/from a simple kmalloc():ed memory buffer and not
> >> just from scatterlists.
> >
> > Why is this needed?  Drivers can just pass in a single-entry scatterlist
> > to the existing API to achieve the same functionality, and a couple of
> > them already do so.
> 
> Because of the overhead, simply. Especially if you want to trigger
> many jobs after each other. (This is necessary in device/slave-DMA
> since every transaction may fail...) It's not just constructing the
> sg-headers and freeing them again and again,

Note that the single length SG list can just be created on the stack.
For example, sound/soc/sh/siu_pcm.c.

> it's also list traversals
> here and there since the driver must assume it can be a linked sglist and
> then two other list traversals for each
> dma_map_sg()/dma_unmap_sg() pair and ... yeah that's basically
> it.

These list traversals of course run only one iteration for a single
length SG list.

> 
> And the number of extra code lines needed.

It's about five lines, but yes, these are duplicated in drivers.

> 
> Then it's something conceptwise of creating a list that you know
> is just always one element that is just not elegant, like taking a queue
> numer and standing in queue when there is only one customer but
> hey, maybe it's just me.

While I don't know about the overhead benefits, such an API would
probably be nice to have to at least avoid duplicating the sglist
building sequence.

Since it can be easily implemented as a wrapper over the existing API
with no change to exsting DMA drivers, why does a new cap need to be
added?  Your suggestion below sounds like a better approach.

> 
> One way of achieving it for all present drivers is to wrap the passed
> buffer in a single sglist and pass to the sglist function if the single
> buffer call is not supported in the driver. Maybe it'd be better if I
> coded up the patch like that so all driver can rely on this function
> to be present?

Rabin
