Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0K2Qpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:45:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57321 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab0K2Qp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:45:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI BUS
Date: Mon, 29 Nov 2010 17:45:22 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1290860675-15453-1-git-send-email-ulli.kroll@googlemail.com> <201011282056.17389.arnd@arndb.de> <4CF3CF33.20407@gmail.com>
In-Reply-To: <4CF3CF33.20407@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011291745.22566.arnd@arndb.de>
X-Provags-ID: V02:K0:n/b/BIGbLRpBW75HrwGwnSzZnNMFNc2WwpegjQR3jxd
 v/FyHbtCRwFzKaZ6GAftg9RwXuihIrYVzbRKypCMlxNYoSe+uJ
 s5pJG/PiMHo0VKKtqHa7vqC30avjc8w+Usou1/o0Q0KgvjiIOM
 F1UHvW22K1AMlcnFqnzI7GOagm4xwI3EroxsCYNJMzJpVstG5T
 EBKXMVNBEzGID9dNleJbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 November 2010, Paulius Zaleckas wrote:
> > The I/O ordering is probably not what you think it is.
> > There is no ordering guarantee between __raw_writel and
> > spin_lock/spin_unlock, so you really should be using
> > readl/writel.
> 
> No he really should NOT use readl/writel. The ONLY difference
> between readl/writel and __raw_readl/__raw_writel is endianess
> conversion. __raw_*l is not doing it. Which to use depend only
> on HW.

There are many differences between readl and __raw_readl, including

* __raw_readl does not have barriers and does not serialize with
  spinlocks, so it breaks on out-of-order CPUs.
* __raw_readl does not have a specific endianess, while readl is
  fixed little-endian, just as the hardware is in this case.
  The endian-conversion is a NOP on little-endian ARM, but required
  if you actually run on a big-endian ARM (you don't).
* __raw_readl may not be atomic, gcc is free to split the access
  into byte wise reads (it normally does not, unless you mark
  the pointer __attribute__((packed))).

In essence, it is almost never a good idea to use __raw_readl, and
the double underscores should tell you so.

	Arnd
