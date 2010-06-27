Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab0F0PIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 11:08:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53590 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755420Ab0F0PIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 11:08:52 -0400
Subject: Re: [PATCH -mm 1/2] scsi: remove dma_is_consistent usage in 53c700
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, grundler@parisc-linux.org, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <1277633423-5700-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1277633423-5700-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Jun 2010 10:08:48 -0500
Message-ID: <1277651328.4366.7.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-27 at 19:10 +0900, FUJITA Tomonori wrote:
> 53c700 is the only user of dma_is_consistent():
> 
> BUG_ON(!dma_is_consistent(hostdata->dev, pScript) && L1_CACHE_BYTES < dma_get_cache_alignment());
> 
> The above code tries to see if the system can allocate coherent memory
> or not. It's for some old systems that can't allocate coherent memory
> at all (e.g some parisc systems).

Actually, that's not the right explanation.  The BUG_ON is because of an
efficiency in the driver ... it's nothing to do with the architecture.

The driver uses a set of mailboxes, but for efficiency's sake, it packs
them into a single coherent area and separates the different usages by a
L1 cache stride).  On architectures capable of manufacturing coherent
memory, this is a nice speed up in the DMA infrastructure.  However, for
incoherent architectures, it's fatal if the dma coherence stride is
greater than the L1 cache size, because now we'll get data corruption
due to cacheline interference.  That's what the BUG_ON is checking for.

> I think that we can safely remove the above usage:
> 
> - such old systems haven't triger the above checking for long.
> 
> - the above condition is important for systems that can't allocate
>   coherent memory if these systems do DMA. So probably it would be
>   better to have such checking in arch's DMA initialization code
>   instead of a driver.

Well, we can't check in the architecture because it's a driver specific
thing ... I suppose making it a rule that dma_get_cache_alignment()
*must* be <= L1_CACHE_BYTES fixes it ... we seem to have no architecture
violating that, so just add it to the documentation, and the check can
go.

James


