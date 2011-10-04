Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab1JDP5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:57:06 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32647 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab1JDP5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:57:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=W8AOOjt8gqlc+HZaJqBW7UOZ5zMbUho02ePiE0KXnvtZILSX2j2B+OmCbjrZw+Nsj
	JY8dydY4INdEKWBEwm3WA==
MIME-Version: 1.0
In-Reply-To: <CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
 <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com>
 <1317742838.29415.217.camel@pasglop> <CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 4 Oct 2011 09:56:37 -0600
Message-ID: <CAErSpo4XUp82t+BUU0gzUaOZG6Po8+EM4kDMRNB7D2VNy-z0MA@mail.gmail.com>
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using "performance" settings
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jon Mason <mason@myri.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 9:48 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Oct 4, 2011 at 8:40 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>>
>> Hopefully most of these patches only affect the "performance" setting
>> which is no longer the default.
>>
>> But yes, more reviews are always welcome.
>
> Well, bcrl argues that patches 1-2 of 3 are actively wrong.
>
> Quite frankly, my gut feel is that this late in the game, the only
> patch I should apply is 3/3, and even that I wonder about. But that
> seems to *really* disable all the games we do, and that all seem to be
> questionable.

The current state (with none of these three applied) is that we do
change MPS configuration in some cases and there is an unsolved
regression (Avi's e1000e problem) and bcrl's concern.

In my opinion, we need to turn off all MPS fiddling by default for rc9
with something like the following.  This is part of 3/3, which I think
should have been split into two pieces -- this one and the "also add"
part.

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d369316..5db5986 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -77,7 +77,7 @@ unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;
 unsigned long pci_hotplug_io_size  = DEFAULT_HOTPLUG_IO_SIZE;
 unsigned long pci_hotplug_mem_size = DEFAULT_HOTPLUG_MEM_SIZE;

-enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_SAFE;
+enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_TUNE_OFF;

 /*
 * The default CLS is used if arch didn't set CLS explicitly and not
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a919db2..4829424 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1451,12 +1451,24 @@ static int pcie_bus_configure_set(struct
pci_dev *dev, void *data)
 */
 void pcie_bus_configure_settings(struct pci_bus *bus, u8 mpss)
 {
       if (!pci_is_pcie(bus->self))
               return;

+       if (pcie_bus_config == PCIE_BUS_TUNE_OFF)
+               return;
