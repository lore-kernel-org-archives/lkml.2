Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1BNNrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:47:32 -0500
Received: from ni.piap.pl ([195.187.100.4]:40913 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab1BNNra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:47:30 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Ben Collins <bcollins@bluecherry.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Mon, 14 Feb 2011 14:47:27 +0100
MIME-Version: 1.0
Message-ID: <m3hbc6pw28.fsf@t19.piap.pl>
Content-Type: text/plain; charset=us-ascii
Subject: SOLO6x10 readl() and writel() usage
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20101209 #4187514, check: 20110214 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

BTW why are you using this instead of simple register readl/writel()?
Does the hardware needs something like this?

static inline u32 solo_reg_read(struct solo_dev *solo_dev, int reg)
{
	unsigned long flags;
	u32 ret;
	u16 val;

	spin_lock_irqsave(&solo_dev->reg_io_lock, flags);

	ret = readl(solo_dev->reg_base + reg);
	rmb();
	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &val);
	rmb();

	spin_unlock_irqrestore(&solo_dev->reg_io_lock, flags);

	return ret;
}

static inline void solo_reg_write(struct solo_dev *solo_dev, int reg, u32 data)
{
	unsigned long flags;
	u16 val;

	spin_lock_irqsave(&solo_dev->reg_io_lock, flags);

	writel(data, solo_dev->reg_base + reg);
	wmb();
	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &val);
	rmb();

	spin_unlock_irqrestore(&solo_dev->reg_io_lock, flags);
}
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
