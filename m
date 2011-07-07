Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1GGMOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:14:07 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47072 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755856Ab1GGMOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:14:03 -0400
X-Sasl-enc: 3XGYBe4jcoZW7XiyX+nezNXyc7EfTqVrnwBxiIi+gEls 1310040841
Message-ID: <4E15A308.7080502@ladisch.de>
Date: Thu, 07 Jul 2011 14:14:00 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: linux-usb@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, florian@mickler.org, pedrib@gmail.com,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Allocating buffers for USB transfers (again)
References: <CACTFLANCYMXH=z+NxEF0aqpMGZp21Q16_uB=J3rndM3pW74qeA@mail.gmail.com>
In-Reply-To: <CACTFLANCYMXH=z+NxEF0aqpMGZp21Q16_uB=J3rndM3pW74qeA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> I have to revisit an issue we've discussed in length around a year ago
> and which still remains unsolved. I've been getting feedback from more
> users of my driver snd-usb-caiaq who report the issue found in bug
> #15580 in the kernel bugzilla:
> https://bugzilla.kernel.org/show_bug.cgi?id=15580
> 
> Let me quickly summarize the current state of this issue as I see it.
> 
> The problem seems to be that certain 64bit chipsets can't deal with
> the fact that an URB's transfer_buffer is allocated with
> kmalloc(GFP_KERNEL). The effect is that kmalloc() is very likely to
> hand out memory which is not addressable by devices that are connected
> via 32bit PCI busses, such as EHCI controllers. In theory, DMA bounce
> buffers should be installed in such cases, or the IOMMU would be in
> charge to re-map these buffers to suitable locations, but for at least
> two people who have reported the issue, this obviously fails.

The problem is that snd-usb-caiaq modifies the URB buffer after
submission.

USB drivers must always be prepared to work with host controllers that
use double buffering.  (IIRC there are some exotic ones where the
hardware works only with internal SRAM.)  DMA mapping, if available, is
only an optimization.

> The question now is how to proceed. I see three possible ways.
> ...
> 3. re-activate the currently disabled functions
> usb_buffer_{map,unmap,sync} functions and let the USB stack do the
> memory mapping

This is the only way that allows bounce buffers to be copied at the
correct time.

> What really puzzles me is that this doesn't hit a lot more people with
> other drivers.

I don't think there is any other driver that relies on the buffer being
coherently DMA-mapped.


Regards,
Clemens
