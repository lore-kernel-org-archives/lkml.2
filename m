Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1EDRhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:37:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55438 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab1EDRhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:37:37 -0400
Date: Wed, 4 May 2011 11:37:35 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Valdis.Kletnieks@vt.edu
Cc: scameron@beardog.cce.hp.com, Tomas Henzl <thenzl@redhat.com>,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Subject: Re: [PATCH 01/16] hpsa: do readl after writel in main i/o path to
	ensure commands don't get lost.
Message-ID: <20110504173735.GB22953@parisc-linux.org>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com> <20110503195849.5478.13229.stgit@beardog.cce.hp.com> <4DC13566.5070203@redhat.com> <20110504125212.GC5997@beardog.cce.hp.com> <10639.1304530101@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10639.1304530101@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 01:28:21PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 04 May 2011 07:52:12 CDT, scameron@beardog.cce.hp.com said:
> > On Wed, May 04, 2011 at 01:15:50PM +0200, Tomas Henzl wrote:
> > > On 05/03/2011 09:58 PM, Stephen M. Cameron wrote:
> > > > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> > > >  	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
> > > >  		c->Header.Tag.lower);
> > > >  	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
> > > > +	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
> 
> > I just put it there to make it clear that it ignoring the return of readl is 
> > done intentionally, not accidentally.  If this goes against some coding convention,
> > whatever, I'm not super attached to the (void), but I did put it there on purpose,
> > and would have done it in cciss as well, had I thought of it at the time.
> 
> This probably needs a comment like
> 	/* don't care - dummy read just to force write posting to chipset */
> or similar.  I'm assuming it's just functioning as a barrier-type flush of some sort?

It's a PCI write flush.  It's not clear to me why it's needed here,
though.  The write will eventually get to the device; why we need to
make the CPU wait around for it to actually get there doesn't make sense.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
