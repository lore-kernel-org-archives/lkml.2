Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab2DNIy2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 04:54:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab2DNIy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 04:54:26 -0400
From: Lubos Lunak <l.lunak@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
Date: Sat, 14 Apr 2012 10:54:23 +0200
User-Agent: KMail/1.9.10
Cc: Peter Seebach <peter.seebach@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <201204132124.21294.l.lunak@suse.cz> <201204141021.28906.l.lunak@suse.cz> <CA+55aFwmZiWfqEF3-Lb_d1jHZQf2Od+oGQ_hfe0CYu8fBTU8nw@mail.gmail.com>
In-Reply-To: <CA+55aFwmZiWfqEF3-Lb_d1jHZQf2Od+oGQ_hfe0CYu8fBTU8nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_/sTiPY5taHpi46e"
Message-Id: <201204141054.23935.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_/sTiPY5taHpi46e
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 14 of April 2012, Linus Torvalds wrote:
> On Sat, Apr 14, 2012 at 1:21 AM, Lubos Lunak <l.lunak@suse.cz> wrote:
> > =A0How about the patch? Are there any *actual* problems with it or can =
it
> > please go in?
>
> If we're going to change that thing, I'd actually prefer to just move
> it inside the #ifdef __KERNEL__ entirely, and get rid of the cplusplus
> case.
>
> IOW, something like this (obviously white-space-mangled) patch:
=2E..
> which protects the kernel NULL definition along with the whole
> offsetof and true/false ones too. And just gets rid of the insane C++
> case entirely.

 That's what the original version of my patch did, but Arnd pointed out tha=
t=20
other exported headers might use NULL and thus not be self-contained in=20
userspace after this change, breaking backwards source compatibility. But I=
'd=20
expect such breakages to be rather unlikely (stddef.h is probably pulled in=
=20
by pretty much everything), so if you're fine with it, I'm ok with this=20
solution too.

=2D-=20
 Lubos Lunak
 l.lunak@suse.cz

--Boundary-00=_/sTiPY5taHpi46e
Content-Type: message/rfc822;
  name="forwarded message"
Content-Transfer-Encoding: 7bit
Content-Description: Lubos Lunak <l.lunak@suse.cz>: [PATCH] do not export kernel's NULL #define to userspace
Content-Disposition: inline

Subject: [PATCH] do not export kernel's NULL #define to userspace
From: Lubos Lunak <l.lunak@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org
Date: Wed, 21 Mar 2012 14:08:24 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Message-Id: <201203211408.25040.l.lunak@suse.cz>
X-Length: 1543
X-UID: 26267

GCC's NULL is actually __null, which allows detecting some questionable
NULL usage and warn about it. Moreover each platform/compiler should have
its own stddef.h anyway (which is different from linux/stddef.h).
So there's no good reason to leak kernel's NULL to userspace and
override what the compiler provides.

Signed-off-by: Lubo=C5=A1 Lu=C5=88=C3=A1k <l.lunak@suse.cz>
=2D--
 include/linux/stddef.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 6a40c76..1747b67 100644
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
=2D-=20
1.7.3.4
=2D-=20
 Lubos Lunak
 l.lunak@suse.cz

--Boundary-00=_/sTiPY5taHpi46e--
