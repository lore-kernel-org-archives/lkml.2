Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1BWRuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:50:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56372 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab1BWRuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:50:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH v3 2/2] i2c: xiic: Use 32bit accesses only
Date: Wed, 23 Feb 2011 18:49:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-i2c@vger.kernel.org,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>
References: <1298396971-611-1-git-send-email-monstr@monstr.eu> <201102230936.09921.arnd@arndb.de> <4D64D55B.50405@monstr.eu>
In-Reply-To: <4D64D55B.50405@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231849.58544.arnd@arndb.de>
X-Provags-ID: V02:K0:QFYktei6uXkGYrWj4w442rJEdXUHAi3uRMvGz+aHreA
 XA3z97AZqpRx+0Zu84YscR2IBw4QOygwANhZCwSiXkcnRGPmZw
 Ot3WKJc5zmm/EYFbWlojxZOtjtExuSOjNf2xM3srJzjw0D72Ie
 CZ89XT+ZBVIx04loRydfGUUnoisKBcfeE+sj6zRctWMXw5QvoV
 +6RHpjhVyVSow4m+3gZoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 February 2011 10:37:31 Michal Simek wrote:
> Arnd Bergmann wrote:
> > On Wednesday 23 February 2011 09:08:47 Michal Simek wrote:
> >> Grant Likely wrote:
> >>> On Tue, Feb 22, 2011 at 10:49 AM, Michal Simek <monstr@monstr.eu> wrote:
> >>>> i2c driver is used for LE/BE that's why is useful to use
> >>>> 32bit accesses. Then it is not necessary to solve any
> >>>> endian issues.
> >>> Are you sure?  I would expect the BE version needs to use
> >>> io{read,write}32be variants of the accessors.  What platforms have you
> >>> tested on?
> >> iowrite32 is the same with iowrite32be for Microblaze.
> >> I have no problem to change it to iowrite32be if you like.
> >>
> >> I have tested it on microblaze big and little endian platforms.
> > 
> > I think what Grant was saying is that iowrite32 being the same as
> > iowrite32be is a bug, because iowrite32 is documented to be little-endian.
> 
> Can you pointed me to that documentation?

Documented was maybe a term that is bit too strong in this case ;-)

Documentation/memory-barriers.txt documents that iowrite32 is the same
as either writel or outl, depending on the source of the mapping.

Both include/asm-generic/io.h and include/asm-generic/iomap.h define
variants of iowrite32 and iowrite32be, but the definition in io.h is
actually broken.

> > This is probably fine as long as you don't have any PCI devices,
> > but if you ever get PCI support, it won't work.
> 
> Microblaze have PCI support but I don't have the board for testing.

Ok, I see.
 
> > Also, it heavily confuses other developers such as Grant and me
> > if one architecture defines things to mean something completely
> > different from the other architectures.
> 
> As I see will be good to review microblaze io.h and use generic one.

The generic io.h is lacking in a number of ways and should really
be improved. Guan Xuetao also fell into the same trap with the
unicore32 port.

The problem is that I copied asm/io.h from mn10300, which seemed
generic enough, but it really doesn't work correctly with PCI.
There is one patch for this that I did in the unicore32 tree,
I should probably go through it and fix everything else that sticks
out.

	Arnd
