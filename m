Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1FJDle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:41:34 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:57586 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916Ab1FJDlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:41:32 -0400
Message-ID: <4DF19251.1090100@st.com>
Date: Fri, 10 Jun 2011 09:11:05 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "anemo@mba.ocn.ne.jp" <anemo@mba.ocn.ne.jp>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Why move all map_sg/unmap_sg for slave channel to its client?
References: <4DF06E29.4010807@st.com>	<BANLkTik9kZjJs5H2kvM+xAtd_CR5NA0dDw@mail.gmail.com> <BANLkTikzDEx2netonGyhskYFtiAEAxq5XQ@mail.gmail.com>
In-Reply-To: <BANLkTikzDEx2netonGyhskYFtiAEAxq5XQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 11:58 PM, Dan Williams wrote:
> On Thu, Jun 9, 2011 at 2:38 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Thu, Jun 9, 2011 at 8:54 AM, viresh kumar <viresh.kumar@st.com> wrote:
>>
>>> I thought map_sg/unmap_sg for slave channels will be handled according
>>> to the flags passed in prep_slave_sg(). But then i found following patch:
>>> (...)
>>> I don't have much knowledge about that discussion, but i think this should be left
>>> configurable.
>>> If the client wants to control map/unmap then it can simply pass
>>> DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SKIP_SRC_UNMAP in flags. I didn't wanted to
>>> skip this in my driver and so i don't pass them.
>>
>> What if the same driver is used on many different platforms like say
>> drivers/tty/serial/amba-pl011.c, and some of the platforms using it
>> has DMA engines that does not implement mapping/unmapping of
>> the passed sglist?
>>
>> In that case I think you have to modify all drivers in drivers/dma/*
>> to do this mapping, and then you could just make it a required behaviour
>> and skip the flags altogether.
>>
>> But apparently that approach was blocked at one point so let's see
>> what the others say.
> 
> My problem with automatic unmapping support is that the dma-driver
> really does not have a chance to get it right except for the trivially
> straightforward cases.  One need only look at the current bustage of
> raid5 acceleration with respect to overlapping mappings and arm v6.
> The dma-driver just knows how to perform "this" operation on "this"
> dma address.  It does not know the lifetime of the mapping, or even if
> it has the actual dma handle for unmapping versus an offset
> 
> For the raid case I've currently convinced myself that the raid client
> needs to get directly involved in dma mapping management, rather than
> teach all dma drivers a language of how to unmap and when.  Not only
> will this fix the overlapping, but it also eliminates the need to map
> and remap because the raid client knows the lifetime of  a stripe_head
> while the driver only knows the lifetime of a given stripe operation.
> 
> For slave-dma maybe there is a lot of common un-mapping logic that can
> be reused, but I think that comes from a separate smart library that
> understands the dma mapping lifetimes of a given class of clients.
> Leave the dma-drivers to just be dumb operators on anonymous dma
> addresses.
> 

Linus, Dan,

Got it. Thanks for your replies.

-- 
viresh
