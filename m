Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1FIUTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:19:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54590 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755555Ab1FIUTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:19:15 -0400
X-Sasl-enc: Wot0P/acIm9xc5kRrmL2LYu1sO9PiJUcBRfKlvTIzAXF 1307650754
Date: Thu, 9 Jun 2011 13:19:07 -0700
From: Greg KH <greg@kroah.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Brett Rudley <brudley@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 related)
Message-ID: <20110609201907.GC12792@kroah.com>
References: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
 <20110609184127.GA2760@kroah.com>
 <20110609195211.GG10107@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609195211.GG10107@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 12:52:12PM -0700, Henry Ptasinski wrote:
> On Thu, Jun 09, 2011 at 11:41:27AM -0700, Greg KH wrote:
> > On Thu, Jun 09, 2011 at 05:27:45PM +1000, Stephen Rothwell wrote:
> > > Hi Greg,
> > > 
> > > After merging the final tree, today's linux-next build (powerpc allyesconfig)
> > > failed like this:
> > > 
> > > drivers/staging/brcm80211/brcmsmac/ampdu.c: In function 'wlc_ampdu_dotxstatus':
> > > drivers/staging/brcm80211/brcmsmac/ampdu.c:840:17: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> > > drivers/staging/brcm80211/brcmsmac/ampdu.c:840:17: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> > > drivers/staging/brcm80211/brcmsmac/ampdu.c:848:8: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> > > drivers/staging/brcm80211/brcmsmac/ampdu.c:848:8: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> > > drivers/staging/brcm80211/brcmsmac/bmac.c: In function 'wlc_bmac_update_slot_timing':
> > > drivers/staging/brcm80211/brcmsmac/bmac.c:186:3: error: invalid operands to binary ^ (have 'volatile u16 *' and 'int')
> > > drivers/staging/brcm80211/brcmsmac/bmac.c:186:3: error: invalid operands to binary ^ (have 'volatile u16 *' and 'int')
> > > drivers/staging/brcm80211/brcmsmac/bmac.c:190:3: error: invalid operands to binary ^ (have 'volatile u16 *' and 'int')
> > > drivers/staging/brcm80211/brcmsmac/bmac.c:190:3: error: invalid operands to binary ^ (have 'volatile u16 *' and 'int')
> > > drivers/staging/brcm80211/brcmsmac/bmac.c: In function 'wlc_setband_inact':
> > > drivers/staging/brcm80211/brcmsmac/bmac.c:234:2: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> > > drivers/staging/brcm80211/brcmsmac/bmac.c:234:2: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> > > drivers/staging/brcm80211/brcmsmac/bmac.c: In function 'wlc_dpc':
> > > drivers/staging/brcm80211/brcmsmac/bmac.c:311:6: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> > > 
> > > (and lots more)
> > 
> > Fun :(
> > 
> > This looks messy.  It's a macro that is trying to be cute by doing:
> > #define R_REG(r) \
> >         ({ \
> >                 __typeof(*(r)) __osl_v; \
> >                 __asm__ __volatile__("sync"); \
> >                 __osl_v = bcmsdh_reg_read(NULL, (unsigned long)(r),\
> >                                           sizeof(*(r))); \
> >                 __asm__ __volatile__("sync"); \
> >                 __osl_v; \
> >         })
> > 
> > on big-endian, non-mips platforms.  Which I really doubt has ever
> > been tested before.
> 
> I think it was used on PPC once upon a time, but likely in a very different
> incarnation.
> 
> > Roland, Brett, any thoughts?
> > 
> > Should I just disable this module from being build on PPC as it doesn't
> > look like its ever been tested or run on that platform before.
> 
> Disabling the build on PPC for now sounds ok.  We'll work on cleaning up the
> macros and try to get some more platform test coverage.

Ok, I've done that now and pushed it to the staging-next tree.

greg k-h
