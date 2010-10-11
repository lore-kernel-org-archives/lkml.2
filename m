Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0JKTFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:05:09 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:58202 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab0JKTFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:05:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19635.24543.793716.40892@pilspetsen.it.uu.se>
Date: Mon, 11 Oct 2010 21:05:03 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Thorsten Glaser <tg@mirbsd.de>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent
 kernels
In-Reply-To: <Pine.BSM.4.64L.1010111218040.23471@herc.mirbsd.org>
References: <20101007174948.GT19804@ZenIV.linux.org.uk>
	<AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
	<20101010144952.GF19804@ZenIV.linux.org.uk>
	<AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com>
	<20101010235256.GG19804@ZenIV.linux.org.uk>
	<20101011024103.GH19804@ZenIV.linux.org.uk>
	<20101011043632.GA2566@cynthia.pants.nu>
	<20101011044808.GI19804@ZenIV.linux.org.uk>
	<Pine.BSM.4.64L.1010111218040.23471@herc.mirbsd.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thorsten Glaser writes:
 > Mikael Pettersson dixit:
 > 
 > >It's gcc PR41302 which was fixed for gcc trunk on November 4 2009
 > >in r153890.  The patch backports easily to gcc-4.4 and solves the
 > >test case there (manual inspection using a cross).  It also backports
 > 
 > [x] send unidiff
 > 
 > I’ll include that in my gcc build and then forward it to Debian
 > once I got a working gcc, unless you want to push that to them
 > already.

This is what I have had in my repo since November last year,
but it's only been minimally tested in a cross.  Please push
if/once it passes bootstrap + regtest.

gcc/

2009-11-10  Mikael Pettersson  <mikpe@it.uu.se>

	Backport from mainline:
	2009-11-04  Maxim Kuvyrkov  <maxim@codesourcery.com>

	PR target/41302
	* config/m68k/m68k.c (m68k_reg_present_p): New static function.
	(m68k_ok_for_sibcall_p): Handle different result return locations.

gcc/testsuite/

2009-11-10  Mikael Pettersson  <mikpe@it.uu.se>

	Backport from mainline:
	2009-11-04  Carlos O'Donell  <carlos@codesourcery.com>

	PR target/41302
	* gcc.target/m68k/pr41302.c: New test.

--- gcc-4.4.2/gcc/config/m68k/m68k.c.~1~	2008-11-19 17:24:10.000000000 +0100
+++ gcc-4.4.2/gcc/config/m68k/m68k.c	2009-11-10 00:10:06.000000000 +0100
@@ -1374,6 +1374,30 @@ flags_in_68881 (void)
   return cc_status.flags & CC_IN_68881;
 }
 
+/* Return true if PARALLEL contains register REGNO.  */
+static bool
+m68k_reg_present_p (const_rtx parallel, unsigned int regno)
+{
+  int i;
+
+  if (REG_P (parallel) && REGNO (parallel) == regno)
+    return true;
+
+  if (GET_CODE (parallel) != PARALLEL)
+    return false;
+
+  for (i = 0; i < XVECLEN (parallel, 0); ++i)
+    {
+      const_rtx x;
+
+      x = XEXP (XVECEXP (parallel, 0, i), 0);
+      if (REG_P (x) && REGNO (x) == regno)
+	return true;
+    }
+
+  return false;
+}
+
 /* Implement TARGET_FUNCTION_OK_FOR_SIBCALL_P.  */
 
 static bool
@@ -1386,6 +1410,26 @@ m68k_ok_for_sibcall_p (tree decl, tree e
   if (CALL_EXPR_STATIC_CHAIN (exp))
     return false;
 
+  if (!VOID_TYPE_P (TREE_TYPE (DECL_RESULT (cfun->decl))))
+    {
+      /* Check that the return value locations are the same.  For
+	 example that we aren't returning a value from the sibling in
+	 a D0 register but then need to transfer it to a A0 register.  */
+      rtx cfun_value;
+      rtx call_value;
+
+      cfun_value = FUNCTION_VALUE (TREE_TYPE (DECL_RESULT (cfun->decl)),
+				   cfun->decl);
+      call_value = FUNCTION_VALUE (TREE_TYPE (exp), decl);
+
+      /* Check that the values are equal or that the result the callee
+	 function returns is superset of what the current function returns.  */
+      if (!(rtx_equal_p (cfun_value, call_value)
+	    || (REG_P (cfun_value)
+		&& m68k_reg_present_p (call_value, REGNO (cfun_value)))))
+	return false;
+    }
+
   kind = m68k_get_function_kind (current_function_decl);
   if (kind == m68k_fk_normal_function)
     /* We can always sibcall from a normal function, because it's
@@ -4583,6 +4627,9 @@ m68k_libcall_value (enum machine_mode mo
   return gen_rtx_REG (mode, D0_REG);
 }
 
+/* Location in which function value is returned.
+   NOTE: Due to differences in ABIs, don't call this function directly,
+   use FUNCTION_VALUE instead.  */
 rtx
 m68k_function_value (const_tree valtype, const_tree func ATTRIBUTE_UNUSED)
 {
--- gcc-4.4.2/gcc/testsuite/gcc.target/m68k/pr41302.c.~1~	1970-01-01 01:00:00.000000000 +0100
+++ gcc-4.4.2/gcc/testsuite/gcc.target/m68k/pr41302.c	2009-11-04 13:09:17.000000000 +0100
@@ -0,0 +1,14 @@
+/* { dg-do compile } */
+/* { dg-options "-O2" } */
+/* { dg-final { scan-assembler "move.l \%d0,\%a0" { target *linux* } } } */
+
+struct pts {
+  int c;
+};
+
+unsigned int bar (struct pts *a, int b);
+
+struct pts * foo (struct pts *a, int b)
+{
+  return (struct pts *) bar (a, b);
+}
