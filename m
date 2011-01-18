Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab1ARSoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 13:44:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1ARSoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:44:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH] asm-generic/io.h: Fix io{read,write}{16,32}be for big endian systems
Date: Tue, 18 Jan 2011 19:44:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8; KDE/4.5.1; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1295374261-19609-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1295374261-19609-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101181944.07146.arnd@arndb.de>
X-Provags-ID: V02:K0:OTWunNPUjSTdbaSwepottW7yPxKRue4kMAJgVafboan
 gda9SaxKlqZvgt65uJQvT2yBhgeV5uhLUiV/5JzeB74RZ2Eh+I
 EYdrqaup+dQez4qwpqiwQU02TPfT+WN/wSeT5QJta8cWP3UpUO
 yotndZDJRxC19UVO5W6zx7Y30RxxCBNRTuDL2U+cyVnwf5At+A
 MDFtEDMjElgTpPK6xgUYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 January 2011 19:11:01 Lars-Peter Clausen wrote:
> Currently io{read,write}{16,32} expand to
>         *addr = cpu_to_leXX(cpu_to_beXX(val))
> and
>         val = beXX_to_cpu(leXX_to_cpu(*addr))
> 
> While it should rather be:
>         *addr = cpu_to_be{16,32}(val)
> and
>         val = be{16,32}_to_cpu(*addr)
> 
> The current implementation works on litte-endian targets(where cpu_to_leXX is a
> noop), but breaks on on big-endian targets, this patch fixes it.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

The existing code looks broken on big-endian indeed, thanks
for the report!

However, you cannot use __raw_readl in general, because that
function knows nothing about the various kinds of I/O accesses
(potentially) handled by readl. Think of architectures where
readl is not a pointer dereference but something else.

The right solution is probably to use swab16/swab32 for the
big-endian functions. This also corrects the iowrite functions
which really should be using cpu_to_be32 instead of be32_to_cpu
(although they are always defined to be the same afaict.

	Arnd
