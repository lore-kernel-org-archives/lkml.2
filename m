Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030579Ab2CUOJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:09:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144Ab2CUOJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:09:29 -0400
From: Lubos Lunak <l.lunak@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] do not export kernel's NULL #define to userspace
Date: Wed, 21 Mar 2012 15:09:27 +0100
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201203211408.25040.l.lunak@suse.cz> <201203211332.06018.arnd@arndb.de>
In-Reply-To: <201203211332.06018.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_XEeaPzzIAE7BidB"
Message-Id: <201203211509.27977.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_XEeaPzzIAE7BidB
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 21 of March 2012, Arnd Bergmann wrote:
> On Wednesday 21 March 2012, Lubos Lunak wrote:
> > GCC's NULL is actually __null, which allows detecting some questionable
> > NULL usage and warn about it. Moreover each platform/compiler should ha=
ve
> > its own stddef.h anyway (which is different from linux/stddef.h).
> > So there's no good reason to leak kernel's NULL to userspace and
> > override what the compiler provides.
> >
> > Signed-off-by: Lubo=C5=A1 Lu=C5=88=C3=A1k <l.lunak@suse.cz>
>
> Yes, this looks like a bug, but I'm not sure that the solution is
> sufficient. Have you checked the other exported header files
> for whether they use NULL after including linux/stddef.h?

 I have checked that the kernel builds with this change, and I have checked=
=20
that the whole of LibreOffice compiles after the change. I'm not sure what=
=20
you mean exactly, are you asking me to manually inspect everything under=20
include/linux for NULL usage?

> If so, we might have to replace it with a __KERNEL_NULL constant
> or something, like we do for the stuff in linux/types.h, so we
> don't accidentally break user applications that rely on the
> header files to be self-contained.
>
> I think there is at least a NULL usage in linux/wireless.h and some
> netfilter headers.

 I see. How about the attached patch then?

=2D-=20
 Lubos Lunak
 l.lunak@suse.cz

--Boundary-00=_XEeaPzzIAE7BidB
Content-Type: text/x-diff;
  charset="utf-8";
  name="0001-do-not-export-kernel-s-NULL-define-to-userspace.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-do-not-export-kernel-s-NULL-define-to-userspace.patch"

=46rom 9be4118ed1bc6221d4f2a73cad69de33285b0b2a Mon Sep 17 00:00:00 2001
=46rom: Lubos Lunak <l.lunak@suse.cz>
Date: Wed, 21 Mar 2012 14:04:31 +0100
Subject: [PATCH] do not export kernel's NULL #define to userspace
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

GCC's NULL is actually __null, which allows detecting some questionable
NULL usage and warn about it. Moreover each platform/compiler should have
its own stddef.h anyway (which is different from linux/stddef.h).
So there's no good reason to leak kernel's NULL to userspace and
override what the compiler provides. Include <stddef.h> in that
case to make sure linux headers are self-contained in userspace as well.

Signed-off-by: Lubo=C5=A1 Lu=C5=88=C3=A1k <l.lunak@suse.cz>
=2D--
 include/linux/stddef.h |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 6a40c76..1db853b 100644
=2D-- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -3,14 +3,10 @@
=20
 #include <linux/compiler.h>
=20
+#ifdef __KERNEL__
+
 #undef NULL
=2D#if defined(__cplusplus)
=2D#define NULL 0
=2D#else
 #define NULL ((void *)0)
=2D#endif
=2D
=2D#ifdef __KERNEL__
=20
 enum {
 	false	=3D 0,
@@ -23,6 +19,8 @@ enum {
 #else
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 #endif
+#else /* __KERNEL__ */
+#include <stddef.h>
 #endif /* __KERNEL__ */
=20
 #endif
=2D-=20
1.7.3.4


--Boundary-00=_XEeaPzzIAE7BidB--
