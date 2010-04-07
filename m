Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab0DGX7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:59:31 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48735 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0DGX7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GvwryX/v77QhuwvZaIX85EgQPjX3TSgBsPvvB13bKgs0+fImYhQ8pKi2Vv4YMcKKvY
         cruqEqwrX2BfFnS4JBTeDr9NoGdG3+U5PG7BnVFhTtLHAZfGYohQmTN88UVLVHtYS8pw
         wQfsGs7/8hXF/quQc1qyVlL8Vz7dUYN+fnpZQ=
Message-ID: <4BBD1C5E.4050906@gmail.com>
Date: Wed, 07 Apr 2010 17:59:26 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Takashi Iwai <tiwai@suse.de>, Daniel Mack <daniel@caiaq.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
References: <s5hhbnncflj.wl%tiwai@suse.de> <Pine.LNX.4.44L0.1004071452560.5760-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004071452560.5760-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 01:13 PM, Alan Stern wrote:
> On Wed, 7 Apr 2010, Takashi Iwai wrote:
>
>>> Ok, I'll write some dummies for usb_malloc() and usb_zalloc() which
>>> will just call kmalloc() with GFP_DMA32 for now.
>>
>> Can't we provide only zalloc() variant?  Zero'ing doesn't cost much,
>> and the buffer allocation shouldn't be called too often.
>
> Linus specifically requested us to avoid using kzalloc in usbfs.  I
> can't find the message in the email archives, but Greg KH should be
> able to confirm it.
>
> As long as we're imitating kmalloc for one use, we might as well make
> it available to all.
>
>>> And while at it,
>>> usb_alloc_buffer() will be renamed to usb_alloc_consistent().
>>
>> Most of recent functions are named with "coherent".
>
> Yes, the terminology got a little confused between the PCI and DMA
> realms.  I agree, "coherent" is better.
>
> BTW, although some EHCI controllers may support 64-bit DMA, the driver
> contains this:
>
> 	if (HCC_64BIT_ADDR(hcc_params)) {
> 		ehci_writel(ehci, 0,&ehci->regs->segment);
> #if 0
> // this is deeply broken on almost all architectures
> 		if (!dma_set_mask(hcd->self.controller, DMA_BIT_MASK(64)))
> 			ehci_info(ehci, "enabled 64bit DMA\n");
> #endif
> 	}
>
> I don't know if the comment is still true, but until the "#if 0" is
> removed, ehci-hcd won't make use of 64-bit DMA.

The comment is wrong (or at least outdated or based on an incorrect 
assumption), but you're right, currently 64-bit DMA is not used on any 
EHCI controllers. It could be, but it sounded like the consensus was it 
wasn't worth the risk. Apparently Windows 7 started using it, and then 
had to put out a patch because some NVidia EHCI controllers indicated 
64-bit support but it didn't work properly. So you'd have to blacklist 
those controllers, at least.
