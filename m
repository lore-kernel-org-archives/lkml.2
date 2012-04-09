Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab2DINYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:24:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DINYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:24:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 3/6] arch/tile: support MMIO-based readb/writeb etc.
Date: Mon, 9 Apr 2012 13:24:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com> <201204062101.q36L1tuT011403@farm-0027.internal.tilera.com>
In-Reply-To: <201204062101.q36L1tuT011403@farm-0027.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204091324.34288.arnd@arndb.de>
X-Provags-ID: V02:K0:RONxXAeRR6+HWEEzSTLyaJXFDaA6sX9k48tBNskdn6+
 eymmqk2D8IbfLE/VhrEXu4tDqMDZaijuz0n5lYvNx+K7RMcA0G
 HgV8S2/m9XztuG4CtJLSO/NVqpUGdrMNdhEMxL4tYvHFHtj7DI
 BkVffa7AVXk0i+wemxFVMBSxDLsQL+ikKLluyXnuhmdZrDXuAc
 Loi+acHf8lEqW2prcqsSqe2Zz4wxjgojU2m6lf4xis0mx4Y+q7
 2PB7GoEiMYuVglPFxsl7X9P6vg2VyhxS4H+15nySSA4sFB2oSA
 IlgWXsedXU3GC7SmBex+P2JtHADw0k/yVvZLSTCrdb69FzS+/h
 6naWGfAanzT/gTD4/fuA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2012, Chris Metcalf wrote:
> Add support for MMIO read/write on tilegx to support GXIO IORPC access.
> Similar to the asm-generic version, but we include memory fences on
> the writes to be conservative.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

It's usually better to use inline assembly here, to guarantee that
the compiler does not split an access into multiple byte sized
accesses as it might sometimes do if a register data structure
is marged "packed". The "volatile" guarantees that the access
does not go beyond a single word, but it does not guarantee that
it's atomic.

I don't think you need the fences after the write because PCI MMIO
writes are posted anyway (only PIO is non-posted), but you might need
some kind of barrier on the read to prevent a scenario where an MMIO 
read tells you that a DMA has completed, but the CPU (or the compiler)
has scheduled the read of that data ahead of the MMIO read.

	Arnd
