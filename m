Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0LOQu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:50:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0LOQu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:50:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/9] ARM i.MX51: Add ipu clock support
Date: Wed, 15 Dec 2010 17:49:59 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "Zhang Lily-R58066" <r58066@freescale.com>,
        linux-fbdev@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        linux-kernel@vger.kernel.org
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <201012151640.03789.arnd@arndb.de> <20101215163445.GE9937@n2100.arm.linux.org.uk>
In-Reply-To: <20101215163445.GE9937@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151749.59488.arnd@arndb.de>
X-Provags-ID: V02:K0:E4LDQOHNK74viniyPgKx6R2VA/aBA6evfpMmBsr8ZCX
 +danLDujbyWxtwXaTpuZ7PEkSt5ImyO0zwOt3n2QpLUGx5/DCY
 BO2R0d0+JX7U2z/J1OrQDhMfvhjlnauZ/bJox8yGRDya+sjO2L
 B/8Z66LraI+00iisUmVAFZidxMW5QWXitAqJqo4x6LBi6qGHG5
 JznznQYCZk3dnOeb5e/ZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 December 2010, Russell King - ARM Linux wrote:
> > The regular accessor function for I/O registers is readl, which handles
> > the access correctly with regard to atomicity, I/O ordering and byteorder.
> 
> There's no possibility of those two being mis-ordered - they will be in
> program order whatever.
> 
> What isn't guaranteed is the ordering between I/O accesses (accesses to
> device memory) and SDRAM accesses (normal memory) which can pass each other
> without additional barriers.  Memory accesses can pass I/O accesses.

Yes, that's what I meant.

> If you don't need normal vs device access ordering, using readl_relaxed()/
> writel_relaxed() is preferred, and avoids the (apparantly rather high)
> performance overhead of having to issue barriers all the way down to the
> L2 cache.

Well, my point was that the authors should choose their I/O accessors
carefully. Using __raw_writel() without any explanations is a rather
bad default, it's not designed for that. Using writel() as a default
is usually a good choice, as we can assume it to do the right thing.

writel_relaxed() is also good where appropriate, because it tells
the reader that the driver author has thought about the I/O (vs. code)
ordering and concluded that it's safe to do.
 
> Lastly, I don't see where atomicity comes into it - __raw_writel vs writel
> have the same atomicity.  Both are single access atomic provided they're
> naturally aligned.  Misaligned device accesses are not predictable.

This is just what gcc turns it into today. In theory, a future gcc or
a future cpu might change that. If you mark a pointer as
'__attribute__((packed))', it probably already does, even for aligned
pointers, while it does not when using writel_{,relaxed}. The point is
that __raw_* means just that -- we don't give any guarantees on what
happens on the bus, so people should not use it.

	Arnd
