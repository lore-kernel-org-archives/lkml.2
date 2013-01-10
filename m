Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab3AJS1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:27:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49219 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab3AJS1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:27:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Date: Thu, 10 Jan 2013 18:26:55 +0000
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
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <201301100917.19577.arnd@arndb.de> <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130110102544.GA5546@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301101826.56248.arnd@arndb.de>
X-Provags-ID: V02:K0:RnAglmKDzYoFE1EZ2W1VaSaczwQ9719NCV2CDKzaUFo
 nhU/Y2MZ5RRl7NB0Dkq2T+Z+ghVq87+qfdpaxkAIvoRktD84Pt
 kjIMkJIcApt82ffSKqUAME6wVft2gj5QDhxRCeoh6/zhLat2u1
 4o2p2B0iWliYXrL2cD4Ndn+8L82GDcsCJJV+Pl/SaBXE8iHT3v
 1XaIWsZtkvUQAvUy6lbWiyddxBMx43bKMARJw3VPcOIFi2vW9Z
 7vS50TeGq3cW23+1VcYbEiBJtlygt2zm/NKo0hWR8DzkwdRyvy
 743WEQu3jh726zNWbt9PmeE+YCBk2MsHyuN+cBiOHM1701bynm
 folCgJXRvCX/jbibiJdc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2013, Thierry Reding wrote:
> I don't understand how this would help. The encoding is like this:
> 
>         [27:24] extended register number
>         [23:16] bus number
>         [15:11] device number
>         [10: 8] function number
>         [ 7: 0] register number
> 
> So it doesn't matter whether I use separate areas per bus or not. As
> soon as the whole extended configuration space needs to be accessed a
> whopping 28 bits (256 MiB) are required.
> 
> What you propose would work if only regular configuration space is
> supported. I'm not sure if that's an option.

I mean something like:

struct tegra_bus_private {
	...
	void __iomem *config_space[16];
};


void tegra_scan_bus(struct pci_bus *bus)
{
	int i;
	struct tegra_bus_private *priv = bus->dev->private;

	for (i=0; i<16; i++)
		priv->config_space[i] = ioremap(config_space_phys +
				 65536 * bus->primary + i * SZ_1M, 65536);

	...
}

	Arnd
