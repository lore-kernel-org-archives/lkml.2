Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab2DIUxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:53:47 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:31876 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab2DIUxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:53:31 -0400
Message-ID: <4F834C48.1060603@tilera.com>
Date: Mon, 9 Apr 2012 16:53:28 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] arch/tile: support MMIO-based readb/writeb etc.
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com> <201204062101.q36L1tuT011403@farm-0027.internal.tilera.com> <201204091324.34288.arnd@arndb.de>
In-Reply-To: <201204091324.34288.arnd@arndb.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/2012 9:24 AM, Arnd Bergmann wrote:
> On Friday 06 April 2012, Chris Metcalf wrote:
>> Add support for MMIO read/write on tilegx to support GXIO IORPC access.
>> Similar to the asm-generic version, but we include memory fences on
>> the writes to be conservative.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> It's usually better to use inline assembly here, to guarantee that
> the compiler does not split an access into multiple byte sized
> accesses as it might sometimes do if a register data structure
> is marged "packed". The "volatile" guarantees that the access
> does not go beyond a single word, but it does not guarantee that
> it's atomic.

Good point.  Since tile doesn't support unaligned reads in kernel space
anyway, it hadn't occurred to me, but you're right that the compiler might
be too conservative in some circumstances.  Fixed.

> I don't think you need the fences after the write because PCI MMIO
> writes are posted anyway (only PIO is non-posted), but you might need
> some kind of barrier on the read to prevent a scenario where an MMIO 
> read tells you that a DMA has completed, but the CPU (or the compiler)
> has scheduled the read of that data ahead of the MMIO read.

I'm not sure why posted vs non-posted would matter, but I think you're
right that we shouldn't need them, and some simple testing seemed to show
that the system was stable without them.  The initial developer said they
were there originally just there for reasons of paranoia during development.

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

