Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab2FULoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:44:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60256 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759371Ab2FULoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:44:01 -0400
Date: Thu, 21 Jun 2012 21:13:54 +0930
From: Alan Modra <amodra@gmail.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (powerpc
 related)
Message-ID: <20120621114354.GG20973@bubble.grove.modra.org>
References: <20120620175014.a822a766e0f91f7b44f48fa0@canb.auug.org.au>
 <1340256961.1998.11.camel@concordia>
 <1340259896.3942.2.camel@pasglop>
 <1340262473.1998.19.camel@concordia>
 <1340264307.1998.20.camel@concordia>
 <20120621104839.GE20973@bubble.grove.modra.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120621104839.GE20973@bubble.grove.modra.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 08:18:39PM +0930, Alan Modra wrote:
> Linker bug.  That's not a sibling call, but a normal function return
> via an out-of-line register restore function.

I couldn't see how this might be occurring, then I remembered the
kernel has this horrible practise of using ld -r to package object
files.  So linker generated functions might be munged together with
other functions.  Does this help?  (It won't if the kernel is
providing its own save/restore functions.)

Index: bfd/elf64-ppc.c
===================================================================
RCS file: /cvs/src/src/bfd/elf64-ppc.c,v
retrieving revision 1.387
diff -u -p -r1.387 elf64-ppc.c
@@ -6494,9 +6494,10 @@ ppc64_elf_func_desc_adjust (bfd *obfd AT
 
   /* Provide any missing _save* and _rest* functions.  */
   htab->sfpr->size = 0;
-  for (i = 0; i < sizeof (funcs) / sizeof (funcs[0]); i++)
-    if (!sfpr_define (info, &funcs[i]))
-      return FALSE;
+  if (!info->relocatable)
+    for (i = 0; i < sizeof (funcs) / sizeof (funcs[0]); i++)
+      if (!sfpr_define (info, &funcs[i]))
+	return FALSE;
 
   elf_link_hash_traverse (&htab->elf, func_desc_adjust, info);
 


-- 
Alan Modra
Australia Development Lab, IBM
