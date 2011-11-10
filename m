Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935174Ab1KJPS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:18:59 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34664 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933817Ab1KJPS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:18:57 -0500
Date: Thu, 10 Nov 2011 19:18:52 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] ata: Fix build error in pata_of_platform (NO_IRQ usage)
Message-ID: <20111110151852.GA7465@oksana.dev.rtsoft.ru>
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
 <4E94A920.40503@xenotime.net>
 <4E987829.3080104@xenotime.net>
 <20111110135703.GA23609@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111110135703.GA23609@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes a band-aid fix the following build failure:

  CC      drivers/ata/pata_of_platform.o
drivers/ata/pata_of_platform.c: In function 'pata_of_platform_probe':
drivers/ata/pata_of_platform.c:55:13: error: 'NO_IRQ' undeclared (first use in this function)
drivers/ata/pata_of_platform.c:55:13: note: each undeclared identifier is reported only once for each function it appears in

The proper fix (stop OF code from returning NO_IRQ values) is pending.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

On Thu, Nov 10, 2011 at 02:57:03PM +0100, Ingo Molnar wrote:
[...]
> > > drivers/ata/pata_of_platform.c:55:13: error: 'NO_IRQ' undeclared (first use in this function)
> > 
> > [adding Author: Anton]
> > 
> > Build error still present in linux-next of 20111014.
> 
> This build failure regression report was ignored twice and then 
> pushed upstream and is still unfixed a month after the initial 
> report. Upstream now fails to build on like 25% of x86 configs.
> 
> What's going on with this bug guys?

Here is the story:

- NO_IRQ is evil[1], AFAIR the trend is to remove its usage completely;
- Sane arches (x86) don't use it at all, or have it defined to 0
  (PPC32/64).
- On another arches it is either -1 or whatever random value;
- The NO_IRQ disease spreads despite our willingness, even within
  the new OF code.

The new irq domain stuff (that is used on ARM) always returns 0
in 'no irq' case, so we may easily remove it.

So the proper fix would be two-fold: for OF and for that driver.
But this is for 3.3 kernels. I'll send the two patches as follow-ups.

In the meantime, the band-aid (for 3.2) is down below.

[1]
http://lkml.org/lkml/2005/11/22/159
http://lkml.org/lkml/2005/11/22/227

 drivers/ata/pata_of_platform.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index a72ab0d..f99e17b 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -16,6 +16,11 @@
 #include <linux/of_platform.h>
 #include <linux/ata_platform.h>
 
+/* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
+#ifndef NO_IRQ
+#define NO_IRQ 0
+#endif
+
 static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
 {
 	int ret;
-- 
1.7.5.3

