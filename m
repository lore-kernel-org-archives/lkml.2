Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1FIS2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:28:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58905 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1FIS2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:28:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=e3i2gBT5L0Hrrf8a/+nIbFCdHOe0UyPKplVk5JpAYo5ousmCogZjXyO8pquwmE/MjL
         x/sJTg9/6xjIv69kW2XErzCE3elO5/M5abTM/6RI2wVrh18iO4UuiLp1Y3DN41Q6+ytZ
         X89uuMLQwB68sWNMvcxXoTUN+Fhx6cocdpLUs=
MIME-Version: 1.0
In-Reply-To: <BANLkTik9kZjJs5H2kvM+xAtd_CR5NA0dDw@mail.gmail.com>
References: <4DF06E29.4010807@st.com>
	<BANLkTik9kZjJs5H2kvM+xAtd_CR5NA0dDw@mail.gmail.com>
Date: Thu, 9 Jun 2011 11:28:43 -0700
X-Google-Sender-Auth: UoanyleyXYopZEUnwqHPU3WGOpQ
Message-ID: <BANLkTikzDEx2netonGyhskYFtiAEAxq5XQ@mail.gmail.com>
Subject: Re: Why move all map_sg/unmap_sg for slave channel to its client?
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: viresh kumar <viresh.kumar@st.com>, "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        anemo@mba.ocn.ne.jp, Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 2:38 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Jun 9, 2011 at 8:54 AM, viresh kumar <viresh.kumar@st.com> wrote:
>
>> I thought map_sg/unmap_sg for slave channels will be handled according
>> to the flags passed in prep_slave_sg(). But then i found following patch:
>> (...)
>> I don't have much knowledge about that discussion, but i think this should be left
>> configurable.
>> If the client wants to control map/unmap then it can simply pass
>> DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SKIP_SRC_UNMAP in flags. I didn't wanted to
>> skip this in my driver and so i don't pass them.
>
> What if the same driver is used on many different platforms like say
> drivers/tty/serial/amba-pl011.c, and some of the platforms using it
> has DMA engines that does not implement mapping/unmapping of
> the passed sglist?
>
> In that case I think you have to modify all drivers in drivers/dma/*
> to do this mapping, and then you could just make it a required behaviour
> and skip the flags altogether.
>
> But apparently that approach was blocked at one point so let's see
> what the others say.

My problem with automatic unmapping support is that the dma-driver
really does not have a chance to get it right except for the trivially
straightforward cases.  One need only look at the current bustage of
raid5 acceleration with respect to overlapping mappings and arm v6.
The dma-driver just knows how to perform "this" operation on "this"
dma address.  It does not know the lifetime of the mapping, or even if
it has the actual dma handle for unmapping versus an offset

For the raid case I've currently convinced myself that the raid client
needs to get directly involved in dma mapping management, rather than
teach all dma drivers a language of how to unmap and when.  Not only
will this fix the overlapping, but it also eliminates the need to map
and remap because the raid client knows the lifetime of  a stripe_head
while the driver only knows the lifetime of a given stripe operation.

For slave-dma maybe there is a lot of common un-mapping logic that can
be reused, but I think that comes from a separate smart library that
understands the dma mapping lifetimes of a given class of clients.
Leave the dma-drivers to just be dumb operators on anonymous dma
addresses.

--
Dan
