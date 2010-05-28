Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab0E1RQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:16:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62727 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab0E1RQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:16:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Date: Fri, 28 May 2010 19:16:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005252345.15685.arnd@arndb.de> <4BFFF330.4080509@tilera.com>
In-Reply-To: <4BFFF330.4080509@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005281916.12999.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+8e+sB+qZKX/fReIsCTbeTcTxOOhgKS/AQsf1
 iIpVUuO1PfAuU+/F9tr06Q/sbIWwlHoGQ7w+k5qOUogUwB+Q2V
 +BUjV24NJGbzdNlxhu9dw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 May 2010, Chris Metcalf wrote:
> I looked at where inb() and friends are used, and although we can get
> close to not requiring them for tile, it's not quite there, and will
> need some further discussions on the various lists to clean up enough
> for our purposes.  There are three problems that surface when I try to
> remove the inb family:
> 
> 1. The ide-io-std.c file sets up the default_tp_ops, which we override
> in our IDE driver, but we still have to build this file, and it contains
> calls to inb, etc.

It's only needed in the IDE layer though and will go away once you
move to an ATA driver, right?

> 2. The usb pci quirks file contains some quirks that use inb and outb,
> and since we support PCI, we have to try to compile this file.
> 
> 3. CONFIG_DEVPORT defaults to yes, unless you're M68K.
>
> None of this seems to depend on CONFIG_HAS_IOPORT.

All three places you have found seem to be actual bugs.
 
> Our PCI driver supports IOMEM read/write, but not IOPORT.
> 
> Perhaps something like CONFIG_ARCH_PCI_HAS_NO_IOPORT or some such, and
> then we can disable all of the above things if that config option is
> present (and CONFIG_HAS_IOPORT is false also?).

That's what CONFIG_NO_IOPORT is supposed to be used for in the
first place, so I think we should just use the existing CONFIG_HAS_IOPORT
symbol to disable the broken code you found. CONFIG_DEVPORT then
not even needs to check for M68K.

	Arnd
