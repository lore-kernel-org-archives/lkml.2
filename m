Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0DJRC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 13:02:56 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:44141 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab0DJRCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 13:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eOh1CZM2wT7QLomrREg47aFMI9bLeIQiW7eBZnZv2v8EQGcndVNMxTXlHIkYadEMwP
         6/1FB5yWfCzxoKW4lp1rnY7J+YemzUA99JRTgL61pw1qEenTQ0N1aCQL+/ERWe/ZQmqa
         IHe9S6obsTdczPQaaOUVzvcVq0hsHzBIug82c=
MIME-Version: 1.0
In-Reply-To: <20100410083453.GN30801@buzzloop.caiaq.de>
References: <s5hhbnncflj.wl%tiwai@suse.de>
	 <Pine.LNX.4.44L0.1004071452560.5760-100000@iolanthe.rowland.org>
	 <20100408003313.GE4365@kroah.com> <4BBE6E57.6020600@gmail.com>
	 <20100409165014.GC5184@xanatos>
	 <g2u51f3faa71004091638nc383aa0ei899777c869273a22@mail.gmail.com>
	 <20100410083453.GN30801@buzzloop.caiaq.de>
Date: Sat, 10 Apr 2010 11:02:53 -0600
Message-ID: <p2o51f3faa71004101002xef38c6e4z71f5a61eed7f899e@mail.gmail.com>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
From: Robert Hancock <hancockrwd@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, alsa-devel@alsa-project.org,
       Greg KH <gregkh@suse.de>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 10, 2010 at 2:34 AM, Daniel Mack <daniel@caiaq.de> wrote:
> On Fri, Apr 09, 2010 at 05:38:13PM -0600, Robert Hancock wrote:
>> On Fri, Apr 9, 2010 at 10:50 AM, Sarah Sharp
>> <sarah.a.sharp@linux.intel.com> wrote:
>> > What makes you think that?  I've seen URB buffers with 64-bit DMA
>> > addresses.  I can tell when the debug polling loop runs and I look at
>> > the DMA addresses the xHCI driver is feeding to the hardware:
>> >
>> > Dev 1 endpoint ring 0:
>> > xhci_hcd 0000:05:00.0: @71a49800 01000680 00080000 00000008 00000841
>> >
>> > So the TRB at address 71a49800 is pointing to a buffer at address
>> > 0x0008000001000680.
>>
>> I'm not sure why the address would be that huge, unless it's not
>> actually a physical address, or there's some kind of remapping going
>> on?
>>
>> >
>> > If I'm setting a DMA mask wrong somewhere, or doing something else to
>> > limit the DMA to 32-bit, then please let me know.
>>
>> The DMA mask for the controller isn't being set anywhere (in the
>> version that's in Linus' current git anyway). In that case it'll
>> default to 32-bit and any DMA mappings above 4GB will need to be
>> remapped. The controller driver doesn't do the mapping itself but the
>> USB core does, passing in the controller device as the one doing the
>> DMA, so if the controller's DMA mask is set to 32-bit then the buffers
>> passed in will get remapped/bounced accordingly.
>
> So if we're seeing physical addresses in the log above, and the xHCI
> driver does not explicitly allow the USB core to use addresses above
> 4GB, why shouldn't the same thing be true as well for EHCI?
> (Which would then be exactly the case we're seeing)

That is a bit suspicious, yes. With the DMA mask at default I don't
expect that should happen. Sarah, what kind of traffic was happening
when you saw that (bulk, isochronous, etc)?

If this apparent EHCI problem is reproducible, it might be useful to
add some code that warns if anything non-zero gets written to the
hw_bufp_hi and hw_buf_hi members in the descriptors.

Also, booting with mem=4096M on an affected system would also tell you
if it's related to using memory above 4GB.
