Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936548Ab0COPm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:42:56 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11538 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936194Ab0COPmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:42:52 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Giampaolo Bellini <iw2lsi@gmail.com>
Subject: Re: PCI conflicts with latest kernels
Date: Mon, 15 Mar 2010 08:42:48 -0700
User-Agent: KMail/1.9.10
Cc: Linux PCI <linux-pci@vger.kernel.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <463bccef1003140331h72b1f11qe133a6a1c952fc6d@mail.gmail.com> <1268601123.28444.21.camel@dc7800.home> <463bccef1003141611q26229896y5d75b035552ff6fc@mail.gmail.com>
In-Reply-To: <463bccef1003141611q26229896y5d75b035552ff6fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003150942.49987.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I re-added the CC: list, so the archives will have the whole
conversation, in case anybody else has similar problems or
can help answer this.]

On Sunday 14 March 2010 05:11:55 pm Giampaolo Bellini wrote:
> I apply the patch but seems that it does not solve conflicts

Yes, I didn't expect it to fix anything, only to tell us more about
what's happening.

But from your dmesg, I think the problem is that the e820 map reserves
0xe0000-0x100000, and then PCI device 0b.0 has a BAR programmed to part
of that same region:

   BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  pci 0000:00:0b.0: reg 10: [mem 0x000e0000-0x000e0fff]
  pci 0000:00:0b.0: address space collision: [mem 0x000e0000-0x000e0fff] already in use

I don't know enough about the e820 map to know whether this is a bug in
the e820 map or a problem in the PCI BAR programming, or what.

> as far I understand, the problem was there also with 2.6.29 but was not
> logged the same way and/or with the same debug-level due to changes made in
> *drivers/pci/setup-res.c* (expecially in pci_claim_resource()))

Yes.  In 2.6.29, pcibios_allocate_resources() used request_resource()
directly and logged errors with dev_info().  In 2.6.34-rc1, we use
pci_claim_resource(), which calls request_resource() and logs errors
with dev_err(), so we now have a higher priority message than we used
to have.

> machine, however, seems stable... for me the problem is that I'm trying to
> avoid text-messages during boot stage and printk(KERN_ERR "message") cause
> the system to switch in text mode & show such errors...

If you only want to hide the message, you can use "loglevel=2".

> as you can see, I've try also with pci=use_crs

Since you don't have ACPI, pci=use_crs and pci=nocrs are not relevant
for your system.

Bjorn

