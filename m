Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab0KOTNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:13:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933505Ab0KOTNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:13:43 -0500
Date: Mon, 15 Nov 2010 20:12:49 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jim Bos <jim876@xs4all.nl>, Andi Kleen <andi@firstfloor.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
 <20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
 <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
 <20101115105446.GD7269@basil.fritz.box>
 <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
 <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com>
 <4CE17098.8090000@xs4all.nl>
 <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>
 <4CE17C4B.1070305@xs4all.nl>
 <20101115185848.GI2583@sunsite.ms.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="QNDPHrPUIc00TOLW"
Content-Disposition: inline
In-Reply-To: <20101115185848.GI2583@sunsite.ms.mff.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QNDPHrPUIc00TOLW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 15, 2010 at 07:58:48PM +0100, Jakub Jelinek wrote:
> Now, not sure why this happens, as there is
>     case GIMPLE_ASM:
>       for (i = 0; i < gimple_asm_nclobbers (stmt); i++)
>         {
>           tree op = gimple_asm_clobber_op (stmt, i);
>           if (simple_cst_equal(TREE_VALUE (op), memory_identifier_string) == 1)
>             {
>               if (dump_file)
>                 fprintf (dump_file, "    memory asm clobber is not const/pure");
>               /* Abandon all hope, ye who enter here. */
>               local->pure_const_state = IPA_NEITHER;
>             }
>         }
> Debugging...

Ah, the problem is that memory_identifier_string is only initialized in
ipa-reference.c's initialization, so it can be (and is in this case) NULL in
ipa-pure-const.c.

Two possible fixes (the latter is apparently what is used in
tree-ssa-operands.c, so is probably sufficient).  Guess ipa-reference.c
should be changed to do the same and just drop memory_identifier_string.

	Jakub

--QNDPHrPUIc00TOLW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=1

--- gcc/ipa-pure-const.c.jj	2010-08-11 16:06:19.000000000 +0200
+++ gcc/ipa-pure-const.c	2010-11-15 20:06:36.121310614 +0100
@@ -460,7 +460,10 @@ check_stmt (gimple_stmt_iterator *gsip, 
       for (i = 0; i < gimple_asm_nclobbers (stmt); i++)
 	{
 	  tree op = gimple_asm_clobber_op (stmt, i);
-	  if (simple_cst_equal(TREE_VALUE (op), memory_identifier_string) == 1)
+	  if (TREE_CODE (TREE_VALUE (op)) == STRING_CST
+	      && TREE_STRING_LENGTH (TREE_VALUE (op)) == sizeof ("memory")
+	      && memcmp (TREE_STRING_POINTER (TREE_VALUE (op)), "memory",
+			 sizeof ("memory")) == 0)
 	    {
               if (dump_file)
                 fprintf (dump_file, "    memory asm clobber is not const/pure");

--QNDPHrPUIc00TOLW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=2

--- gcc/ipa-pure-const.c.jj	2010-08-11 16:06:19.000000000 +0200
+++ gcc/ipa-pure-const.c	2010-11-15 20:07:51.463716989 +0100
@@ -460,7 +460,7 @@ check_stmt (gimple_stmt_iterator *gsip, 
       for (i = 0; i < gimple_asm_nclobbers (stmt); i++)
 	{
 	  tree op = gimple_asm_clobber_op (stmt, i);
-	  if (simple_cst_equal(TREE_VALUE (op), memory_identifier_string) == 1)
+	  if (strcmp (TREE_STRING_POINTER (TREE_VALUE (link)), "memory") == 0)
 	    {
               if (dump_file)
                 fprintf (dump_file, "    memory asm clobber is not const/pure");

--QNDPHrPUIc00TOLW--
