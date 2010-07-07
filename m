Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab0GGWKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:10:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50543 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab0GGWKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:10:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 16/18] llseek: automatically add .llseek fop
Date: Thu, 8 Jul 2010 00:10:45 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>, Julia Lawall <julia@diku.dk>,
       Christoph Hellwig <hch@infradead.org>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-17-git-send-email-arnd@arndb.de> <AANLkTilxcVzDv-BSPz6ZaDDyWx7j8_HFU4hIEaf6KHOC@mail.gmail.com>
In-Reply-To: <AANLkTilxcVzDv-BSPz6ZaDDyWx7j8_HFU4hIEaf6KHOC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007080010.45751.arnd@arndb.de>
X-Provags-ID: V02:K0:c9ALCrW2DKDW4dJ+4xam9GXS5rgWZ0pvIPnvm368VVB
 m/KtEQmzq5zUxe+39+fa/5rNI+o1Dk1QmP0FzIZKiS4ZPaqK0U
 OrCFjUV7arKgVRjWsg8ySI40oXtD06Y6nDxV/t4J7kXzKxGLWo
 EZvrIsXBILhxyiVepaI1B3Qab+65GirsTCxuTDZxDY4swneKf0
 jsULtauR4KeFIykV33l6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 July 2010 23:55:25 Mike Frysinger wrote:
> > New drivers should normally not use
> > noop_llseek but instead use no_llseek and
> > call nonseekable_open at open time.
> > Existing drivers can be converted to do
> > the same when the maintainer knows for
> > certain that no user code relies on calling
> > seek on the device file.
> 
> can we skip the transition for devices that we already know ?

Yes, we could do that for the cases that call nonseekable_open
either by putting it into file_operations or by calling it
from their own open() function in the same file. These
are the two cases where the semantic patch currently adds
no_llseek.

The reason I added the explicit no_llseek was so I could
tell the difference between those file operations that
use nonseekable_open and those that spatch could for
some reason not identify as belonging into any of the
categories.

> > --- a/arch/blackfin/kernel/kgdb_test.c
> > +++ b/arch/blackfin/kernel/kgdb_test.c
> > static const struct file_operations kgdb_test_proc_fops = {
> > +       .llseek = noop_llseek,/* read and write both use no f_pos */
> > --- a/arch/blackfin/mach-bf561/coreb.c
> > +++ b/arch/blackfin/mach-bf561/coreb.c
> >  static const struct file_operations coreb_fops = {
> > +       .llseek = noop_llseek,/* no read or write fn */
> 
> neither of these drivers are seekable, so attempts to do so should be
> an error ...

Ok, then you should add ".open = nonseekable_open," to the file
operations and put that change into a tree that gets pulled into
linux-next. The semantic patch will do the right thing then,
whatever we decide.

	Arnd
