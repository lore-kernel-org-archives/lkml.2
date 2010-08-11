Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0HKTCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:02:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56676 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0HKTCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u/ya4Er+QdjjXQgBGOWwFgihcgzbGr8Od5p+ITWv8jVBhPFZqUomzvNzHNpdnhReZ8
         VOfCv3FNKHH1xGQo52wYatDMKVOydgjSD6OLiq4OGPBH0ELAeAeqaKP6axQNP4RS7BeO
         5OMjHhxleXonfZ/fBzRDCwib0dIQNzxLLiJgs=
MIME-Version: 1.0
In-Reply-To: <20100811141219.GA5846@debian>
References: <1281476766-7066-1-git-send-email-linus.walleij@stericsson.com>
	<20100811141219.GA5846@debian>
Date: Wed, 11 Aug 2010 21:02:04 +0200
Message-ID: <AANLkTikD2LwYwsk6Q-7U-P3o+ujhY_0TqgeqOo=hhjA=@mail.gmail.com>
Subject: Re: [PATCH] DMAENGINE: add a slave buffer prep call
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/11 Rabin Vincent <rabin@rab.in>:

> On Tue, Aug 10, 2010 at 11:46:06PM +0200, Linus Walleij wrote:
>> This makes it possible for engines to implement slave transfers
>> to be done to/from a simple kmalloc():ed memory buffer and not
>> just from scatterlists.
>
> Why is this needed?  Drivers can just pass in a single-entry scatterlist
> to the existing API to achieve the same functionality, and a couple of
> them already do so.

Because of the overhead, simply. Especially if you want to trigger
many jobs after each other. (This is necessary in device/slave-DMA
since every transaction may fail...) It's not just constructing the
sg-headers and freeing them again and again, it's also list traversals
here and there since the driver must assume it can be a linked sglist and
then two other list traversals for each
dma_map_sg()/dma_unmap_sg() pair and ... yeah that's basically
it.

And the number of extra code lines needed.

Then it's something conceptwise of creating a list that you know
is just always one element that is just not elegant, like taking a queue
numer and standing in queue when there is only one customer but
hey, maybe it's just me.

One way of achieving it for all present drivers is to wrap the passed
buffer in a single sglist and pass to the sglist function if the single
buffer call is not supported in the driver. Maybe it'd be better if I
coded up the patch like that so all driver can rely on this function
to be present?

Yours,
Linus Walleij
