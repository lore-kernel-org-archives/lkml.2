Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1ART4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:56:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64094 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1ART4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:56:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH] asm-generic/io.h: Fix io{read,write}{16,32}be for big endian systems
Date: Tue, 18 Jan 2011 20:56:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8; KDE/4.5.1; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1295374261-19609-1-git-send-email-lars@metafoo.de> <201101181944.07146.arnd@arndb.de> <4D35E378.70300@metafoo.de>
In-Reply-To: <4D35E378.70300@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101182056.35673.arnd@arndb.de>
X-Provags-ID: V02:K0:W8bvabzXX6L/XQVr2Q/GpeE+jjpRnPxRcuLLG85SrOA
 xF5qtGQnLNoHg9rWOAHeY5Xkpy3XTsRnwq5wAugHgeWOoxDQQ+
 yOtt+dcy5QdcT+iw6DEqjhGMKb0n3NHUqN1lJjlHNqV376uo3/
 8bWeAubysuEq3GxJ+pZpcE0oLTuikjzBoggC06ztAwf5deZmrm
 1QClHB03YGH+Wn1dPmm0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 January 2011 20:01:12 Lars-Peter Clausen wrote:
> Well, i've though about that as well, but in the current asm-generic/io.h readl is
> unconditionally defined as cpu_to_le32(__raw_readl(addr)) and ioread32 is defined as
> readl.
> 
> So unless an arch io.h undefines those macros and redefines them (which none of the
> current archs does, as far as i can see), we are o
> 
> If an arch chooses to redefine ioread or readl, it should probably also redefine
> ioread{16,32}be.

Right, but the header file also serves as a template for new architectures
that cannot directly use it. I would prefer not to give a possibly bad example
here, especially when it's in a rarely used function.

> > The right solution is probably to use swab16/swab32 for the
> > big-endian functions. This also corrects the iowrite functions
> > which really should be using cpu_to_be32 instead of be32_to_cpu
> > (although they are always defined to be the same afaict.
> 
> This would first cause a conversion to little-endian, which is a swap() in the
> generic case and then you would call swap() again on the result. Which is basically a
> noop, but I'm not sure if compilers will detect this.

The overhead of the swab() is certainly dwarfed by the long time spent in
readl().

I would prefer to swap twice in this case and let the compiler work it out
if possible. The next best alternative would probably be to define both
ioread and ioread_be using __raw_readl in combination with a le32_to_cpu
or be32_to_cpu.

	Arnd
