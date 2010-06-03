Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab0FCNj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:39:28 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:52701 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0FCNj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w9oVKM0MbhvtoTslLjvl8lHXbEB443OcP/cHJSdOkI0cUXk7wxsIFHlGrtjrMDAkWG
         PCgV45YEqDV9SbYayYhecw4Px3bbN/6dsJspkFFXV1mVavKMbPME3awTJR2VSxIx7x87
         T9E2II9/wzbmQjUesUQBAzOCBEjBk7rWDycWI=
Date: Thu, 3 Jun 2010 17:23:19 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc1 ahci regression
Message-ID: <20100603132319.GA4889@oksana.dev.rtsoft.ru>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
 <20100603075402.GA11093@oksana.dev.rtsoft.ru>
 <AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
 <20100603084104.GA17431@oksana.dev.rtsoft.ru>
 <AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
 <AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com>
 <20100603093923.GA25856@oksana.dev.rtsoft.ru>
 <AANLkTim8TALR8Ev9KDX4tteXUrQ3oKOcnyMHk9WOdUvG@mail.gmail.com>
 <20100603131414.GA23520@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100603131414.GA23520@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 05:14:14PM +0400, Anton Vorontsov wrote:
> On Thu, Jun 03, 2010 at 08:35:31PM +0800, Luming Yu wrote:
> > On Thu, Jun 3, 2010 at 5:39 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> > > On Thu, Jun 03, 2010 at 05:18:40PM +0800, Luming Yu wrote:
> > > [...]
> > >> Linux version 2.6.32-25.el6.x86_64
> > >
> > > Hm. Can you really boot the kernels that has
> > > 365cfa1ed5 applied and reverted?
> > >
> > > That is, do
> > >
> > > $ git reset --hard 365cfa1ed5
> > > $ make
> > > $ ...boot...
> > Linux version 2.6.34-rc7 (root@localhost) (gcc version 4.4.4 20100503
> [...]
> > > And then
> > >
> > > $ git reset --hard 365cfa1ed5^
> > > $ make
> > > $ ...boot...
> > >
> > Linux version 2.6.34-rc7 (root@localhost) (gcc version 4.4.4 20100503
> > (Red Hat 4.4.4-2) (GCC) ) #24 SMP Thu Jun 3 08:07:58 EDT 2010
> 
> Thanks. But for some reason you don't include debug
> messages from the not working kernel. :-/ I presume
> you use different methods to capture the log, you
> should pass 'debug' kernel command line option to
> actually enable these messages. Please try to
> capture the debugging messages.
> 
> Meanwhile, here is a guess: initrd isn't happy about
> the new libahci.ko dependency for ahci.ko, and so it
> doesn't load the module? Why? I don't know. Let
> me check it...

Oh. It seems I found it. It must be the module order loading
thing.

Can you try the patch down below?

And thanks for the patience!

diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 20c5251..092d9e0 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -1,7 +1,7 @@
 
 obj-$(CONFIG_ATA)		+= libata.o
 
-obj-$(CONFIG_SATA_AHCI)		+= ahci.o libahci.o
+obj-$(CONFIG_SATA_AHCI)		+= libahci.o ahci.o
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
