Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0FNRlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:41:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab0FNRlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:41:49 -0400
Date: Mon, 14 Jun 2010 13:41:42 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Dominik Brodowski <linux@dominikbrodowski.net>
cc: linux-kernel@vger.kernel.org
Subject: Another PCMCIA regression
In-Reply-To: <20100602143822.GA11506@isilmar-3.linta.de>
Message-ID: <Pine.LNX.4.64.1006141335540.24598@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1005251619020.12278@hs20-bc2-1.build.redhat.com>
 <20100526113515.GA7219@comet.dominikbrodowski.net> <20100602143822.GA11506@isilmar-3.linta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010, Dominik Brodowski wrote:

> Mikulas,
> 
> On Wed, May 26, 2010 at 01:35:15PM +0200, Dominik Brodowski wrote:
> > On Tue, May 25, 2010 at 04:25:21PM -0400, Mikulas Patocka wrote:
> > > The commit a8408c17d0038b76a83affb1b56dc18fa1e7ed86 in Linux 2.6.34-rc6 
> > > broke pcmcia for me. I use 3c574 network card in yenta socket on Armada 
> > > 7400 laptop. My distribution is Debian lenny.
> > > 
> > > Reverting the test for "s->functions" in pccard_validate_cis makes the 
> > > network card work again.
> > 
> > Does this warning appear during reume, or during some other "special" use
> > case? Also, does commit cc83b08fc791045ac197e6f4a030599bcd7100c5 solve this
> > issue? If not: Could you enable dynamic debug logging via
> > 
> > # mount debugfs
> > mount none -t debugfs /sys/kernel/debug/
> > 
> > # enable debug
> > echo "module pcmcia +p" > /sys/kernel/debug/dynamic_debug/control
> > echo "module pcmcia_core +p" > /sys/kernel/debug/dynamic_debug/control
> > echo "module yenta_socket +p" > /sys/kernel/debug/dynamic_debug/control
> > 
> > and send me the resulting log (which may be looong).
> 
> any update on this?
> 
> Thanks & best wishes,
> 
> 	Dominik

Hi

That WARN_ON() bug is fixed in 2.6.35-rc3, but there is another bug, also 
introduced in 2.6.34-rc6 in "pcmcia: pcmcia_dev_present bugfix"

That patch changes bit field to atomic_t, it wouldn't be problematic, but 
it also adds one line "atomic_set(&socket->present, 0);" to 
pcmcia_bus_add_socket which causes nonworking eth0.

The symptoms are: eth0 is present, but can't be activated with "ifconfig 
eth0 up". The test "pcmcia_dev_present(link)" in 
drivers/net/pcmcia/3c574_cs.c:el3_open is failing.

This bug happens only after system boot, if I unload and reinsert the 
modules manually, it doesn't happen.

I'm here sending the patch that reverts the change and fixes the bug (I 
don't know why, I found it experimentally).

Mikulas

---
 drivers/pcmcia/ds.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.35-rc3-fast/drivers/pcmcia/ds.c
===================================================================
--- linux-2.6.35-rc3-fast.orig/drivers/pcmcia/ds.c	2010-06-13 10:13:37.000000000 +0200
+++ linux-2.6.35-rc3-fast/drivers/pcmcia/ds.c	2010-06-14 19:14:08.000000000 +0200
@@ -1364,8 +1364,6 @@ static int __devinit pcmcia_bus_add_sock
 		return ret;
 	}
 
-	atomic_set(&socket->present, 0);
-
 	return 0;
 }
 
