Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1FITFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:05:17 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33681 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848Ab1FITFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:05:15 -0400
X-Sasl-enc: CITAq6pL5s8jFY5vpCs/KFZAh+gMX9cUns5pRrTLoEQG 1307646314
Date: Thu, 9 Jun 2011 11:41:27 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, brudley@broadcom.com,
        henryp@broadcom.com, rvossen@broadcom.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 related)
Message-ID: <20110609184127.GA2760@kroah.com>
References: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 05:27:45PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the final tree, today's linux-next build (powerpc allyesconfig)
> failed like this:
> 
> drivers/staging/brcm80211/brcmsmac/ampdu.c: In function 'wlc_ampdu_dotxstatus':
> drivers/staging/brcm80211/brcmsmac/ampdu.c:840:17: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> drivers/staging/brcm80211/brcmsmac/ampdu.c:840:17: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> drivers/staging/brcm80211/brcmsmac/ampdu.c:848:8: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> drivers/staging/brcm80211/brcmsmac/ampdu.c:848:8: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> drivers/staging/brcm80211/brcmsmac/bmac.c: In function 'wlc_bmac_update_slot_timing':
> drivers/staging/brcm80211/brcmsmac/bmac.c:186:3: error: invalid operands to binary ^ (have 'volatile u16 *' and 'int')
> drivers/staging/brcm80211/brcmsmac/bmac.c:186:3: error: invalid operands to binary ^ (have 'volatile u16 *' and 'int')
> drivers/staging/brcm80211/brcmsmac/bmac.c:190:3: error: invalid operands to binary ^ (have 'volatile u16 *' and 'int')
> drivers/staging/brcm80211/brcmsmac/bmac.c:190:3: error: invalid operands to binary ^ (have 'volatile u16 *' and 'int')
> drivers/staging/brcm80211/brcmsmac/bmac.c: In function 'wlc_setband_inact':
> drivers/staging/brcm80211/brcmsmac/bmac.c:234:2: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> drivers/staging/brcm80211/brcmsmac/bmac.c:234:2: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> drivers/staging/brcm80211/brcmsmac/bmac.c: In function 'wlc_dpc':
> drivers/staging/brcm80211/brcmsmac/bmac.c:311:6: error: invalid operands to binary ^ (have 'volatile u32 *' and 'int')
> 
> (and lots more)

Fun :(

This looks messy.  It's a macro that is trying to be cute by doing:
#define R_REG(r) \
        ({ \
                __typeof(*(r)) __osl_v; \
                __asm__ __volatile__("sync"); \
                __osl_v = bcmsdh_reg_read(NULL, (unsigned long)(r),\
                                          sizeof(*(r))); \
                __asm__ __volatile__("sync"); \
                __osl_v; \
        })

on big-endian, non-mips platforms.  Which I really doubt has ever
been tested before.

Roland, Brett, any thoughts?

Should I just disable this module from being build on PPC as it doesn't
look like its ever been tested or run on that platform before.

> Also in several other files in drivers/staging/brcm80211/
> 
> Also:
> 
> drivers/staging/comedi/drivers.c: In function 'comedi_buf_alloc':
> drivers/staging/comedi/drivers.c:505:37: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
> In file included from drivers/staging/comedi/drivers/addi_apci_035.c:7:0:
> drivers/staging/comedi/drivers/addi-data/addi_common.c: In function 'i_ADDI_Attach':
> drivers/staging/comedi/drivers/addi-data/addi_common.c:2765:7: error: implicit declaration of function 'virt_to_bus'
> 
> (Also several other occurrences of that one)

I'll fix this up, it looks just like a #include that needs to be added.

thanks,

greg k-h
