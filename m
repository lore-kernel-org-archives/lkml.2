Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0INKsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 06:48:07 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34034 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0INKsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 06:48:04 -0400
Message-ID: <4C8F527E.40408@ru.mvista.com>
Date: Tue, 14 Sep 2010 14:46:22 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
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
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com> <1283873014-32511-6-git-send-email-tom.leiming@gmail.com> <4C8E18AD.8000502@ru.mvista.com> <AANLkTinei3u1OZ-eBiUTDF=PDjwxLcL6rBpt7iNQJgHJ@mail.gmail.com> <4C8E4882.6040600@ru.mvista.com> <4C8E50CC.3080705@ru.mvista.com> <20100914065604.GD2601@legolas.emea.dhcp.ti.com>
In-Reply-To: <20100914065604.GD2601@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-09-2010 10:56, Felipe Balbi wrote:

>> Oops, I've been too fast and haven't realized that the check done here
>> _is_ actually wrong. It causes ZLP send to trigger too fast in the DMA
>> case. So please fix this patch. Felipe, please drop it for now.

> patch is not even touching that part of the code,

    Yeah, and that's the problem.

> not even
> reading/writing TXCSR_TXPKTRDY bit care to explain please.

    If a DMA interrupt comes when the whole transfer is not yet complete (and 
other Ming Lei's patches are making this possible), it will pass due to the 
'ís_dma' condition above the patched code:

                 if (is_dma || request->actual == request->length) {

and then it will hit the code sending the final ZLP (above this patched code too):

                         /*
                          * First, maybe a terminating short packet. Some DMA
                          * engines might handle this by themselves.
                          */
                         if ((request->zero && request->length
                                 && request->length % musb_ep->packet_sz == 0)
#ifdef CONFIG_USB_INVENTRA_DMA
                                 || (is_dma && (!dma->desired_mode ||
                                         (request->actual &
                                                 (musb_ep->packet_sz - 1))))
#endif
                         ) {

before the transfer is complete while it should only be hit when and only when 
the whole transfer is complete. The current code doesn't look correct as well 
though, all due to this 'ís_dma' condition. Surely this needs fixing.

WBR, Sergei
