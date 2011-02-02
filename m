Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1BBQhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:37:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47393 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab1BBQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:37:41 -0500
Date: Wed, 2 Feb 2011 16:37:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, gcc@gcc.gnu.org,
        linux-kernel@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>
Subject: Re: ARM unaligned MMIO access with attribute((packed))
Message-ID: <20110202163702.GA23240@n2100.arm.linux.org.uk>
References: <201102021700.20683.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102021700.20683.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 05:00:20PM +0100, Arnd Bergmann wrote:
> I would suggest fixing this by:
> 
> 1. auditing all uses of __attribute__((packed)) in the Linux USB code
> and other drivers, removing the ones that are potentially harmful.
> 
> 2. Changing the ARM MMIO functions to use inline assembly instead of
> direct pointer dereference.
> 
> 3. Documenting the gcc behavior as undefined.

We used to use inline assembly at one point, but that got chucked out.
The problem is that using asm() for this causes GCC to generate horrid
code.

1. there's no way to tell GCC that the inline assembly is a load
   instruction and therefore it needs to schedule the following
   instructions appropriately.

2. GCC will needlessly reload pointers from structures and other such
   behaviour because it can't be told clearly what the inline assembly
   is doing, so the inline asm needs to have a "memory" clobber.

3. It seems to misses out using the pre-index addressing, prefering to
   create add/sub instructions prior to each inline assembly load/store.

4. There are no (documented) constraints in GCC to allow you to represent
   the offset format for the half-word instructions.

Overall, it means greater register pressure, more instructions, larger
functions, greater instruction cache pressure, etc.
