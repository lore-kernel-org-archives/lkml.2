Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab0FLCyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 22:54:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982Ab0FLCyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 22:54:24 -0400
Date: Fri, 11 Jun 2010 19:54:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>
Subject: Re: mmotm 2010-06-11-16-40 uploaded
Message-Id: <20100611195421.6b723910.akpm@linux-foundation.org>
In-Reply-To: <AANLkTin1cUkn_Cw5P0AR8NTx5prNF34bajZD0bPoavP2@mail.gmail.com>
References: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
	<AANLkTin1cUkn_Cw5P0AR8NTx5prNF34bajZD0bPoavP2@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jun 2010 10:43:31 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> On Sat, Jun 12, 2010 at 7:40 AM,  <akpm@linux-foundation.org> wrote:
> > The mm-of-the-moment snapshot 2010-06-11-16-40 has been uploaded to
> >
> > __ http://userweb.kernel.org/~akpm/mmotm/
> >
> > and will soon be available at
> >
> > __ git://zen-kernel.org/kernel/mmotm.git
> >
> 
> Hi, andrew
> 
> building failed with:
>   AS      arch/x86/kernel/entry_32.o
> /home/dave/src/linux-2.6.35/arch/x86/include/asm/olpc_ofw.h: Assembler messages:
> /home/dave/src/linux-2.6.35/arch/x86/include/asm/olpc_ofw.h:29: Error:
> no such instruction: `static inline void
> olpc_ofw_detect_range(void){}'
> make[2]: *** [arch/x86/kernel/entry_32.o] Error 1
> make[1]: *** [arch/x86/kernel] Error 2
> make: *** [arch/x86] Error 2
> 
> Attached a patch to fix it (I have not appropriate email client now,
> sorry for the inconvenience )

Thanks.

We can simplify things a bit I think...

#ifndef _ASM_X86_OLPC_OFW_H
#define _ASM_X86_OLPC_OFW_H

/* hardcode addresses to make life easier dealing w/ VMALLOC_END and others */
#define OLPC_OFW_START 0xff800000UL
#define OLPC_OFW_SIZE (PGDIR_SIZE)
#define OLPC_OFW_END (OLPC_OFW_START + OLPC_OFW_SIZE)

#ifndef __ASSEMBLER__

#ifdef CONFIG_OLPC_OPENFIRMWARE

/* address of OFW callback interface; will be NULL if OFW isn't found */
extern int (*olpc_ofw_cif)(int *);

/* page dir entry containing OFW's current memory */
extern pgdval_t olpc_ofw_pgd;

/* run an OFW command by calling into the firmware */
extern int olpc_ofw(const char *name, int nr_args, int nr_res, ...);

/* determine/ensure OFW lives in the proper place in (virtual) memory */
void olpc_ofw_detect_range(void);

#else	/* CONFIG_OLPC_OPENFIRMWARE */

static inline void olpc_ofw_detect_range(void) { }

#endif	/* CONFIG_OLPC_OPENFIRMWARE */

#endif	/* __ASSEMBLER__ */

#endif


--- a/arch/x86/include/asm/olpc_ofw.h~x86-olpc-add-support-for-calling-into-openfirmware-fix-fix
+++ a/arch/x86/include/asm/olpc_ofw.h
@@ -6,10 +6,10 @@
 #define OLPC_OFW_SIZE (PGDIR_SIZE)
 #define OLPC_OFW_END (OLPC_OFW_START + OLPC_OFW_SIZE)
 
-#ifdef CONFIG_OLPC_OPENFIRMWARE
-
 #ifndef __ASSEMBLER__
 
+#ifdef CONFIG_OLPC_OPENFIRMWARE
+
 /* address of OFW callback interface; will be NULL if OFW isn't found */
 extern int (*olpc_ofw_cif)(int *);
 
@@ -22,14 +22,12 @@ extern int olpc_ofw(const char *name, in
 /* determine/ensure OFW lives in the proper place in (virtual) memory */
 void olpc_ofw_detect_range(void);
 
-#endif
-
-#else
+#else	/* CONFIG_OLPC_OPENFIRMWARE */
 
-#ifndef __ASSEMBLER__
 static inline void olpc_ofw_detect_range(void) { }
-#endif
 
-#endif
+#endif	/* CONFIG_OLPC_OPENFIRMWARE */
+
+#endif	/* __ASSEMBLER__ */
 
 #endif
_

