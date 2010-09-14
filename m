Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0INRv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:51:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63382 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab0INRv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:51:57 -0400
Message-ID: <4C8FB60D.1080906@ru.mvista.com>
Date: Tue, 14 Sep 2010 21:51:09 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: balbi@ti.com
CC: Sergei Shtylyov <sshtylyov@mvista.com>, Ming Lei <tom.leiming@gmail.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com> <1283873014-32511-6-git-send-email-tom.leiming@gmail.com> <4C8E18AD.8000502@ru.mvista.com> <AANLkTinei3u1OZ-eBiUTDF=PDjwxLcL6rBpt7iNQJgHJ@mail.gmail.com> <4C8E4882.6040600@ru.mvista.com> <4C8E50CC.3080705@ru.mvista.com> <20100914065604.GD2601@legolas.emea.dhcp.ti.com> <4C8F527E.40408@ru.mvista.com> <20100914105402.GD7554@legolas.emea.dhcp.ti.com>
In-Reply-To: <20100914105402.GD7554@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Felipe Balbi wrote:

>>    If a DMA interrupt comes when the whole transfer is not yet 
>> complete (and
>> other Ming Lei's patches are making this possible),

    Oh, here I mixed some other patch with Ming Lei's ones...

>> it will pass due to the

> than this is the actual problem, no ? If we're using mode1 dma (as we
> are on tx path), we should only get dma interrupt when the whole
> transfer has been completed.

    The Inventra DMA controller has serious DMA length limitation, so the whole 
transfer may take more than one DMA.

>> 'ís_dma' condition above the patched code:

>>                 if (is_dma || request->actual == request->length) {

>> and then it will hit the code sending the final ZLP (above this 
>> patched code too):

> but this was already there before the patch.

    Yes, and here lies the problem.

>>                         /*
>>                          * First, maybe a terminating short packet. 
>> Some DMA
>>                          * engines might handle this by themselves.
>>                          */
>>                         if ((request->zero && request->length
>>                                 && request->length % 
>> musb_ep->packet_sz == 0)
>> #ifdef CONFIG_USB_INVENTRA_DMA
>>                                 || (is_dma && (!dma->desired_mode ||
>>                                         (request->actual &
>>                                                 (musb_ep->packet_sz - 
>> 1))))
>> #endif
>>                         ) {

>> before the transfer is complete while it should only be hit when and 
>> only when
>> the whole transfer is complete. The current code doesn't look correct 
>> as well
>> though, all due to this 'ís_dma' condition. Surely this needs fixing.

> likewise, this was there before the patch. I don't think the real
> problem lies with this patch, it's been there for a while, don't you
> agree ?

    Then what problem this patch fixes, if not this one?

> the problem is not on the extra if () added below the quoted code,
> it's on the quoted code itself, which wasn't changed in any way.

    Let me repeat: in the PIO mode the added check is just duplicate, in the DMA 
mode it's added too late in the code, after ZLP/short packet send is triggered.
We should modify the check at the top of that code instead.

WBR, Sergei
