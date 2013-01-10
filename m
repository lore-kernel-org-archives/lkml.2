Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab3AJJRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:17:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49910 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3AJJRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:17:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Date: Thu, 10 Jan 2013 09:17:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <20130109231758.GA27065@obsidianresearch.com> <20130110071937.GG15212@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130110071937.GG15212@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301100917.19577.arnd@arndb.de>
X-Provags-ID: V02:K0:24riiU3XvfSHlZOWFu7ukd8I/vLpnePzt2g1FP1Gz6U
 kvY8M5C5R+HjMmmt79BU6LIUE6LTpdOi0Qmr0UcT2DwqM2cS/T
 fIsVQAn4wtXsn8q7sYVhL1JVaof3/hglbgNEjzLyhts/BqI9Df
 8TI6KHdh19TcgnGowG1+kZis7jU6romRdAGeXITwljBlVKYHlw
 gXNznJdmT4L5tn20ULZSMxySDLKeXFrHx8B0phh2w7cKLuylKa
 NpGUO0UsUZs2/JGHMAxYf7ZPJcMJwP4wsfglmgR+qPNe2m9wFs
 SSq5KV046T7nSyA3vH/zNtZDD6R6dCKPHRFMctYLC1mtANS69u
 ikc8KwftE9ltuwGhgHVs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2013, Thierry Reding wrote:
> On Wed, Jan 09, 2013 at 04:17:58PM -0700, Jason Gunthorpe wrote:
> > On Wed, Jan 09, 2013 at 04:12:31PM -0700, Stephen Warren wrote:
> > You could decrease the size of the mapping to only span the bus
> > numbers that are configured for use via DT.
> 
> That won't work, unfortunately. The mapping is such that the bus number
> is not encoded in the uppermost bits, the extended register number is.
> So the only thing that we could do is decrease the size of the extended
> register space for *all* devices.

But you could still a method to map 16 separate areas per bus, each 65536
bytes long, which results in 1MB per bus. That is probably ok, since
very few systems have more than a handful of buses in practice.

In theory, doing static mappings on a per-page base would let you
do 16 devices at a time, but it's probably worth doing at this fine
granularity.

> > Are there any concerns about these config registers being accessed
> > from a context where a new mapping can't be made? Interrupt? Machine
> > Check? PCI-E Advanced Error Reporting?
> 
> I haven't checked but I would expect configuration space accesses to not
> happen in interrupt context. Usually they are limited to enumeration and
> driver probe.

Actually, AER probably needs this, and I believe some broken devices 
need to mask interrupts using the PCI command word in the config space,
it it can happen.

	Arnd
