Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1BVIzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:55:16 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:34115 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1BVIzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:55:14 -0500
Date: Tue, 22 Feb 2011 09:55:02 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the i2c tree
Message-ID: <20110222095502.1d18e6d8@endymion.delvare>
In-Reply-To: <20110222171720.59019382.sfr@canb.auug.org.au>
References: <20110221153522.8a0b29bf.sfr@canb.auug.org.au>
	<20110221105858.197cbf1d@endymion.delvare>
	<20110222171720.59019382.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 22 Feb 2011 17:17:20 +1100, Stephen Rothwell wrote:
> Hi Jean,
> 
> On Mon, 21 Feb 2011 10:58:58 +0100 Jean Delvare <khali@linux-fr.org> wrote:
> >
> > On Mon, 21 Feb 2011 15:35:22 +1100, Stephen Rothwell wrote:
> > > Hi Jean,
> > > 
> > > After merging the tip tree, today's linux-next build (powerpc
> > > ppc64_defconfig) produced these warnings:
> > > 
> > > drivers/i2c/i2c-core.c: In function 'i2c_do_add_adapter':
> > > drivers/i2c/i2c-core.c:799: warning: 'attach_adapter' is deprecated (declared at include/linux/i2c.h:149)
> > > drivers/i2c/i2c-core.c:804: warning: 'attach_adapter' is deprecated (declared at include/linux/i2c.h:149)
> > > drivers/i2c/i2c-core.c: In function 'i2c_do_del_adapter':
> > > drivers/i2c/i2c-core.c:985: warning: 'detach_adapter' is deprecated (declared at include/linux/i2c.h:150)
> > > drivers/i2c/i2c-core.c:988: warning: 'detach_adapter' is deprecated (declared at include/linux/i2c.h:150)
> > > 
> > > Introduced by commit 95529c656b97b08c7a92504f98650a229f03ae04 ("i2c:
> > > Deprecate i2c_driver.attach_adapter and .detach_adapter").  We normally
> > > fix up as many uses of an interface as possible before deprecating it ...
> > 
> > These are the core locations where the deprecated callbacks are called.
> > Ideally they would _not_ emit warnings, are these are legitimate and
> > can't be removed before all drivers relying on these callbacks have
> > been fixed. If there is a way to silent these warnings, please let me
> > know, as I don't know of any.
> 
> You could build just that file with -Wno-deprecated-declarations, or put
> the deprecated stuff into another file that is built with that flag.
> We did the latter with pci_find_device (see commit e8b553bf4b19c "PCI:
> disable pci_find_device warnings when deprecated pci functions are
> enabled").

Thanks for the hints. The latter is difficult in my case, as the
functions where the deprecated methods are called are internal to
i2c-core. The former seems to work though, and I think we can live with
it for 6 months. I've appended the following to
i2c-03-deprecate-attach-detach_adapter.patch:

--- linux-2.6.38-rc5.orig/drivers/i2c/Makefile	2011-01-05 21:24:21.000000000 +0100
+++ linux-2.6.38-rc5/drivers/i2c/Makefile	2011-02-22 09:49:58.000000000 +0100
@@ -10,3 +10,4 @@ obj-$(CONFIG_I2C_MUX)		+= i2c-mux.o
 obj-y				+= algos/ busses/ muxes/
 
 ccflags-$(CONFIG_I2C_DEBUG_CORE) := -DDEBUG
+CFLAGS_i2c-core.o := -Wno-deprecated-declarations

Thanks,
-- 
Jean Delvare
