Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab1AMPBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:01:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41367 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab1AMPBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:01:12 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 13 Jan 2011 16:00:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire build fix
Message-ID: <20110113160021.07a8ce85@stein>
In-Reply-To: <20110107175539.2b882d3d@stein>
References: <20110107175539.2b882d3d@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following update for the IEEE 1394 (FireWire) subsystem.
It's straightforward and runtime tested.

Clemens Ladisch (1):
      firewire: ohci: fix compilation on arches without PAGE_KERNEL_RO

 drivers/firewire/ohci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Thanks.


commit 1427130425c1239d977e8891c3a8923f53a6e352
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Thu Jan 13 10:12:17 2011 +0100

    firewire: ohci: fix compilation on arches without PAGE_KERNEL_RO
    
    PAGE_KERNEL_RO is not available on all architectures, so its use
    in the new AR code broke compilation on sparc64.
    
    Because the read-only mapping was just a debugging aid, just use
    PAGE_KERNEL instead.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    
    James Bottomley wrote:
    > On Thu, 2011-01-13 at 08:27 +0100, Clemens Ladisch wrote:
    >> firewire: ohci: fix compilation on arches without PAGE_KERNEL_RO, e.g. sparc
    >>
    >> PAGE_KERNEL_RO is not available on all architectures, so its use in the
    >> new AR code broke compilation on sparc64.
    >>
    >> Because the R/O mapping is only used to catch drivers that try to write
    >> to the reception buffer and not actually required for correct operation,
    >> we can just use a normal PAGE_KERNEL mapping where _RO is not available.
    [...]
    >> +/*
    >> + * For archs where PAGE_KERNEL_RO is not supported;
    >> + * mapping the AR buffers readonly for the CPU is just a debugging aid.
    >> + */
    >> +#ifndef PAGE_KERNEL_RO
    >> +#define PAGE_KERNEL_RO PAGE_KERNEL
    >> +#endif
    >
    > This might cause interesting issues on sparc64 if it ever acquired a
    > PAGE_KERNEL_RO.  Sparc64 has extern pgprot_t for it's PAGE_KERNEL types
    > rather than #defines, so the #ifdef check wouldn't see this.
    >
    > I think either PAGE_PROT_RO becomes part of our arch API (so all
    > architectures are forced to add it), or, if it's not part of the API,
    > ohci isn't entitled to use it.  The latter seems simplest since you have
    > no real use for write protection anyway.
    
    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index d77d120..bd3c61b 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -961,7 +961,7 @@ static int ar_context_init(struct ar_context *ctx, struct fw_ohci *ohci,
 	for (i = 0; i < AR_WRAPAROUND_PAGES; i++)
 		pages[AR_BUFFERS + i] = ctx->pages[i];
 	ctx->buffer = vm_map_ram(pages, AR_BUFFERS + AR_WRAPAROUND_PAGES,
-				 -1, PAGE_KERNEL_RO);
+				 -1, PAGE_KERNEL);
 	if (!ctx->buffer)
 		goto out_of_memory;
 
-- 
Stefan Richter
-=====-==-== ---= -==-=
http://arcgraph.de/sr/
