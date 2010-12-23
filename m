Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0LWBL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 20:11:27 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60765 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0LWBL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 20:11:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WHMQJT+EZPYu4nQk9rio4zsHz+yCePTFlKPhTOzDR5Gsdp6R8HnEYMxlhDbqRwyPde
         gdYZXm2CrwyTevkqx58dxHuu8Od4QW3GYe5rbWoVNDBNRci8+dp/h8g6ktmE8/s0zb4W
         v77wE+OF1s2GGDqk2PwMmUeQVzwxYof371lL8=
MIME-Version: 1.0
In-Reply-To: <20101223001012.GF29368@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<20101221182037.GA4783@n2100.arm.linux.org.uk>
	<20101222122904.GC14693@n2100.arm.linux.org.uk>
	<AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
	<20101223001012.GF29368@n2100.arm.linux.org.uk>
Date: Wed, 22 Dec 2010 17:11:24 -0800
X-Google-Sender-Auth: Cjd1FhhtkbnP6N-xpSpvif1jvpU
Message-ID: <AANLkTimirgsuoM2che_ocrkvCZqGu6xEJjrjdmt9-69p@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Dan Williams <dan.j.williams@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 4:10 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Dec 22, 2010 at 03:45:39PM -0800, Dan Williams wrote:
>> 3.6 Constraints:
>> 1/ Calls to async_<operation> are not permitted in IRQ context.  Other
>>    contexts are permitted provided constraint #2 is not violated.
>
> BTW, this is misleading.  Have the functions been renamed dma_async_xxx(),
> eg dma_async_memcpy_buf_to_buf etc, or are you referring just to:
>
>        async_dmaengine_get
>        async_dmaengine_put
>        async_dma_find_channel
>        async_dma_find_channel
>        async_tx_ack
>        async_tx_clear_ack
>        async_tx_test_ack
>
> Beware of just renaming it to dma_async_<operation> as there's other
> functions in that namespace which may not be appropriate.
>
> Eg, is it really illegal to issue call dma_async_issue_pending() from
> IRQ context?  That'd make it exceedingly difficult to use the DMA
> engine with the slave API in a lot of device drivers.

This is generic offload (async_{memcpy|xor|etc...}) versus the slave
usage confusion .  In the async_<operation> case the client (md/raid5)
has no idea if a dmaengine is offloading the operation behind the
scenes and should not make any assumptions about submission context
beyond what is allowed in the document.  In the slave case the client
driver knows that it is talking to a specific dma driver.  The
contract between the client driver and dma driver is undocumented.
The slave usage model really is a "I want to use dmaengine to find my
dma device driver / manage channels, and I want a common prep / submit
mechanism, but otherwise stay out of my way".  Drivers that do not
want to meet the constraints expected by the opportunistic offload
clients should do what ste_dma40 does and add "depends on !(NET_DMA ||
ASYNC_TX_DMA)"

--
Dan
