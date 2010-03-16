Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937443Ab0CPGOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:14:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab0CPGOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:14:32 -0400
Subject: Re: ATA 4 KiB sector issues.
From: James Bottomley <James.Bottomley@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
In-Reply-To: <4B9EED55.10201@kernel.org>
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de>
	 <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>
	 <4B9EED55.10201@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 23:14:20 -0700
Message-ID: <1268720060.21384.10.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 11:30 +0900, Tejun Heo wrote:
> Hello,
> 
> On 03/10/2010 06:14 PM, Denys Vlasenko wrote:
> > 63s/255h is more or less "standard" now.
> > 
> > Alignment issues can be solved by picking a good multiple of
> > _heads_ or _cylinders_:
> 
> I've got a couple of comments stating that picking a good geometry
> parameters can resolve the whole issue but I simply fail to see how it
> could.  We can pick any parameter we wish, but there is no reliable
> way to communicate the custom geometry parameters to others.
> 
> Geometry is determined by two parameters sec/trk and heads/cyl.  You
> can punch in those numbers if the BIOS has a menu for it (many don't
> these days).  Or hope that BIOS can somehow figure it out from the
> partition table which some BIOSs actually try to do.  The problem is
> that to determine the two parameters you need to equations matching
> CHSs and LBAs and that's available iff the first partition ends before
> CHS addressing limit according to the custom geometry, which usually
> is not the case.
> 
> So, custom geometry is only useful to trick partitioners which align
> using cylinders into using better alignments but doesn't help anything
> for compatibility as no one can determine the used geometry reliably
> after the partitioning is complete.  With compatibility benefit gone,
> there simply is no reason to stick to the cylinder abstraction at all.
> 
> Am I missing something?

Sort of.  As you say, C/H/S doesn't exist for any modern disk.  However,
the msdos label, for reasons lost in the mists of time, uses cylinders
as the units of partition boundaries, so we have to invent a bogus C/H/S
geometry for that partition label.  Because of the problems with picking
C/H/S, most boot loaders take care to ensure that BIOS never cares about
it either (by using the block offset I/O routines), so for most linux
bootloaders, the BIOS problems with C/H/S is a red herring.

So, it is true to say that picking a certain H/S geometry (which is
entirely withing the gift of the partitioner) will align msdos label
partitions, but will be don't care for all other labels: all other
partition labels (like gpt) use block as offset and don't have any truck
with the fictitious C/H/S stuff.

The big problem is that 99% of the x86 systems out there still use the
ancient msdos label for their boot disks, so aligning H/S going forwards
will give us a nice "just works" for x86 boxes.

James


