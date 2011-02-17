Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1BQRUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:20:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1BQRT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:19:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 10/12] unicore32 machine related files: pci bus handling
Date: Thu, 17 Feb 2011 18:19:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <015501cbcdae$6961c5d0$3c255170$@mprc.pku.edu.cn>
In-Reply-To: <015501cbcdae$6961c5d0$3c255170$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171819.52845.arnd@arndb.de>
X-Provags-ID: V02:K0:qfID2lU7E2IOIF2vhgDJGTgVnBj1dwkqVz8NjK1jeSt
 TCeX/cWIZHF8NFgPmzACbDswJqlqkYGaLkjTnr7UNJDjeQ1wqk
 nl+2u5d0oqIebgdGyiEuLgj30FG0mKFdJnxBownmuSy2tVIH1D
 dJwVMiJ+jyLMOBpFlpP2rYxzEWZ15jTQhrTw1BImKMcSHpY6uR
 tg0TExq6AHsl9/3n9IwTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 February 2011, Guan Xuetao wrote:
> +{
> +       PCICFG_ADDR = CONFIG_CMD(bus, devfn, where);
> +       switch (size) {
> +       case 1:
> +               *value = (PCICFG_DATA >> ((where & 3) * 8)) & 0xFF;
> +               break;
> +       case 2:

It took me a while to figure out what this actually does. PCICFG_ADDR
and PCICFG_DATA are pointers to MMIO registers, which you should not
simply dereference. A lot of things can go wrong there, especially
if future machines move to weakly ordered I/O subsystem or have
multiple CPUs, but even for the simple case, the compiler has
a lot of ways to mess this up.

As explained in my reply to the "hardware registers" patch, all these
pointers should be marked as __iomem, so that sparse warns about
dangerous accesses such as the one here.

The code above should be written as

{
       writel(CONFIG_CMD(bus, devfn, where), PCICFG_ADDR);
       switch (size) {
       case 1:
               *value = readl(PCICFG_DATA >> ((where & 3) * 8)) & 0xFF;
               break;
       case 2:

	Arnd
