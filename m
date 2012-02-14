Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab2BNBMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:12:42 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:64198 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611Ab2BNBMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:12:39 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19+PQo/dKYzGNRUoIoapRLK
Date: Mon, 13 Feb 2012 17:12:28 -0800
From: Tony Lindgren <tony@atomide.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, Anders Kaseorg <andersk@ksplice.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-omap@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] modpost: Fix section warnings for ARM for many
 compilers
Message-ID: <20120214011228.GM1426@atomide.com>
References: <20120213212401.GH1426@atomide.com>
 <20120213222652.GL14173@pengutronix.de>
 <20120213225118.GC31482@n2100.arm.linux.org.uk>
 <878vk6cl5z.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878vk6cl5z.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell <rusty@rustcorp.com.au> [120213 16:07]:
> On Mon, 13 Feb 2012 22:51:18 +0000, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > On Mon, Feb 13, 2012 at 11:26:52PM +0100, Uwe Kleine-König wrote:
> > > On Mon, Feb 13, 2012 at 01:24:01PM -0800, Tony Lindgren wrote:
> > > Maybe:
> > > 
> > > #ifndef R_ARM_CALL
> > > #warning "you're elf.h include is outdated"
> > 
> > "You are elf.h include is outdated" does not make sense.
> > 
> > Why are you calling Tony an elf.h include?
> 
> Because he knew it would attract the attention of pedants to the patch?
> :)

I've been called worse than that :)
 
> Just do the #ifndef, and skip the warning.  There's not much the poor
> user receiving the warning can do about it.

OK
 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Assuming your ack applies for this patch below, let me know if that's
not the case.  
Regards,

Tony


From: Tony Lindgren <tony@atomide.com>
Date: Mon, 13 Feb 2012 12:30:09 -0800
Subject: [PATCH] modpost: Fix section warnings for ARM for many compilers

It turns out that many compilers don't show section warnings on ARM
currently because handling for ARM_CALL relocs are missing from
modpost.c.

Based on commit c2e26114 ([ARM] 3205/1: Handle new EABI relocations when
loading kernel modules) it seems that R_ARM_PC24, R_ARM_CALL and
R_ARM_JUMP24 can be handled the same way.

Note that at least Debian libc6-dev is missing defines for both
R_ARM_CALL and R_ARM_JUMP24 in /usr/include/elf.h. So for now
we need to define them in modpost.c if not defined.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1494,6 +1494,13 @@ static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 	return 0;
 }
 
+#ifndef R_ARM_CALL
+#define R_ARM_CALL	28
+#endif
+#ifndef R_ARM_JUMP24
+#define R_ARM_JUMP24	29
+#endif
+
 static int addend_arm_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 {
 	unsigned int r_typ = ELF_R_TYPE(r->r_info);
@@ -1505,6 +1512,8 @@ static int addend_arm_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
 		              (elf->symtab_start + ELF_R_SYM(r->r_info));
 		break;
 	case R_ARM_PC24:
+	case R_ARM_CALL:
+	case R_ARM_JUMP24:
 		/* From ARM ABI: ((S + A) | T) - P */
 		r->r_addend = (int)(long)(elf->hdr +
 		              sechdr->sh_offset +
