Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1LVH5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 02:57:39 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:58680 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914Ab1LVH5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 02:57:36 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqcAAEnh8k5tg0Xn/2dsb2JhbABCm1CQWYEGgXIBAQQBOhwjEAgDDgMEAQEvFCUDEw4Th3oCtzUTi3wElH6SNQ
Date: Thu, 22 Dec 2011 08:57:34 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maxim Uvarov <maxim.uvarov@oracle.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH] hpwd watchdog mark page executable
Message-ID: <20111222075734.GL23376@infomag.iguana.be>
References: <1323131139-32451-1-git-send-email-maxim.uvarov@oracle.com> <1323131139-32451-2-git-send-email-maxim.uvarov@oracle.com> <20111220165059.4e79a416.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220165059.4e79a416.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> > Mark hpwdt watchdog pages executable to prevent failing:
> > BUG: unable to handle kernel paging request at c00f0000
> >  IP: [<c00f0000>] 0xc00effff
> >  *pdpt = 0000000000b7c001 *pde = 0000000000cf5067 *pte = 80000000000f0163
> >  Oops: 0011 [#1] SMP
> >
> > ...
> >
> > --- a/drivers/watchdog/hpwdt.c
> > +++ b/drivers/watchdog/hpwdt.c
> > @@ -335,6 +335,8 @@ static int __devinit detect_cru_service(void)
> >  	if (p == NULL)
> >  		return -ENOMEM;
> >  
> > +	set_memory_x((unsigned long)p & PAGE_MASK, ROM_SIZE >> PAGE_SHIFT);
> > +
> >  	for (q = p; q < p + ROM_SIZE; q += 16) {
> >  		rc = bios32_present(q);
> >  		if (!rc)
> 
> Odd.  Either nobody else is using this driver, or there's something
> special about your setup.  Are you able to explain this?  
> 
> Also, do you believe that this fix should be backported into earlier
> stable kernels and if so, why?

See attached the patch that the driver author has sent in and which is in linux-next since 2 days.
This is a reworked version (due to nmi changes) but the original comment from Thomas Mingarelli was:
> This is needed for SLES11 SP2 and the latest upstream kernel as it appears the
> NX Execute Disable has grown in its control.
> I have tested this against the SLES11 SP2 kernel, the 3.0.4 upstream stable
> kernel, and the latest upstream kernel in development (which this patch is
> created against).

Kind regards,
Wim.
-------------------------------------------------------------------------------------------------
From: Mingarelli, Thomas
Sent: Monday, November 07, 2011 10:59 AM
To: Wim Van Sebroeck
Cc: Mingarelli, Thomas
Subject: [hpwdt patch] Changes to handle NX secure bit in 32bit path

This patch makes use of the set_memory_x() kernel API in order
to make necessary BIOS calls to source NMIs.
Signed-off by: Thomas Mingarelli <thomas.mingarelli@hp.com>

diff -up ./drivers/watchdog/hpwdt.c.ORIG ./drivers/watchdog/hpwdt.c
--- ./drivers/watchdog/hpwdt.c.ORIG	2011-11-07 10:46:37.000000000 -0600
+++ ./drivers/watchdog/hpwdt.c	2011-11-07 10:50:59.000000000 -0600
@@ -230,6 +230,7 @@ static int __devinit cru_detect(unsigned
 
 	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
 
+	set_memory_x((unsigned long)bios32_entrypoint, (2 * PAGE_SIZE));
 	asminline_call(&cmn_regs, bios32_entrypoint);
 
 	if (cmn_regs.u1.ral != 0) {
@@ -247,8 +248,10 @@ static int __devinit cru_detect(unsigned
 		if ((physical_bios_base + physical_bios_offset)) {
 			cru_rom_addr =
 				ioremap(cru_physical_address, cru_length);
-			if (cru_rom_addr)
+			if (cru_rom_addr) {
+				set_memory_x((unsigned long)cru_rom_addr, cru_length);
 				retval = 0;
+			}
 		}
 
 		printk(KERN_DEBUG "hpwdt: CRU Base Address:   0x%lx\n",


