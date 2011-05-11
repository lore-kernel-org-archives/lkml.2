Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1EKAJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 20:09:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9821 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab1EKAJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 20:09:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sZtjKgOJwbJUNxXYSKaX4jJ2TAyl/xkEfUnpv2VbNKt/1EHrSBRXDIVuvqmbStuasj
         8VaVGnHbu4V9b9FiyTwA==
Date: Tue, 10 May 2011 17:08:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@suse.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, stable@kernel.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] slub: Revert "[PARISC] slub: fix panic with DISCONTIGMEM"
In-Reply-To: <1304979845.4865.58.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1105101656310.15037@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg> <alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com> <1304026464.2598.36.camel@mulgrave.site> <alpine.DEB.2.00.1104281437010.21665@chino.kir.corp.google.com> <1304521355.2810.21.camel@mulgrave.site>
 <alpine.DEB.2.00.1105041203250.22426@chino.kir.corp.google.com> <1304979845.4865.58.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 May 2011, James Bottomley wrote:

> > Great, and if that works out successfully this time around I think we'll 
> > either need to fix each individual arch Kconfig that we know doesn't work 
> > well (at least parisc because of the scheduling issue) so that it at least 
> > enables CONFIG_NUMA implicitly for discontigmem unless CONFIG_BROKEN is 
> > set.
> 
> OK, I confirm that the N_NORMAL_MEMORY patch on its own fixes slub for
> us.  We can revert the mark slub BROKEN in DISCONTIGMEM && !NUMA patch.
> 

Ok, so we need to revert 4a5fa3590f09 ([PARISC] slub: fix panic with 
DISCONTIGMEM) that did not allow CONFIG_SLUB to be set for architectures 
that use DISCONTIGMEM without NUMA support unless they have CONFIG_BROKEN 
set from Linus' tree _and_ from the stable trees.



slub: Revert "[PARISC] slub: fix panic with DISCONTIGMEM"

4a5fa3590f09 ([PARISC] slub: fix panic with DISCONTIGMEM) did not allow 
SLUB to be used on architectures that use DISCONTIGMEM without compiling 
NUMA support without CONFIG_BROKEN also set.

The slub panic that it was intended to prevent is addressed by 
d9b41e0b54fd ([PARISC] set memory ranges in N_NORMAL_MEMORY when onlined) 
on parisc so there is no further slub issues with such a configuration.

This reverts the former commit so that SLUB may now be used on such 
architectures since there haven't been any reports of additional errors.

Cc: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 init/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1226,7 +1226,6 @@ config SLAB
 	  per cpu and per node queues.
 
 config SLUB
-	depends on BROKEN || NUMA || !DISCONTIGMEM
 	bool "SLUB (Unqueued Allocator)"
 	help
 	   SLUB is a slab allocator that minimizes cache line usage
