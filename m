Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab1ANAQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:16:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187Ab1ANAQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:16:13 -0500
MIME-Version: 1.0
In-Reply-To: <201101131619.01893.bjorn.helgaas@hp.com>
References: <1294327066-23518-1-git-send-email-jslaby@suse.cz>
 <201101101140.45501.bjorn.helgaas@hp.com> <4D2ECEDC.4040804@gmail.com> <201101131619.01893.bjorn.helgaas@hp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Jan 2011 16:15:20 -0800
Message-ID: <AANLkTinN40GMRL3bJ7LKDmhCYK1AYZfQ+mVYwxDP1ZQe@mail.gmail.com>
Subject: Re: [PATCH 1/1] PCI: tune up ICH4 quirk for broken BIOSes
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 3:19 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> I think we're back to the question of why we have the ICH4 quirk in
> the first place, and I don't know the answer to that.

Iirc, there were several laptops that didn't have the ACPI region
mentioned in any of the regular places, and we'd allocate the PCMCIA
IO region on top of them. The machine would boot, but if anybody ever
inserted a PCCard into the machine, the first access to the IO region
would generally just halt it (because it was trying to read the
PCCard, but the APCI region decodes first, and then the read from that
usually put the CPU in a sleep state that it would never wake up from
for obvious reasons).

So we do want the ICH4 quirk.

> Maybe you could make the ICH4 quirk only claim the region if it's
> above PCIBIOS_MIN_IO, i.e., if it's in the area where we could put
> another PCI device on top of it?

That may well be the best solution - we'd only mark it reserved if it
might conflict with a dynamic allocation, and if it conflicts with
other motherboard resources (like the IDE ports), then we don't know
what the decode priority is anyway, so..

In this case, it looks like the legacy IDE ports get decoded before
the dynamic BAR's. Which is not too much of a surprise (fixed
addresses tend to be the first to get decoded).

                    Linus
