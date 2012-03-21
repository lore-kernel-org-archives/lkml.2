Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960Ab2CUSh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:37:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab2CUShY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:37:24 -0400
From: Lubos Lunak <l.lunak@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] do not export kernel's NULL #define to userspace
Date: Wed, 21 Mar 2012 19:37:22 +0100
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201203211408.25040.l.lunak@suse.cz> <201203211509.27977.l.lunak@suse.cz> <201203211417.14306.arnd@arndb.de>
In-Reply-To: <201203211417.14306.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_i/haPM4M3O9tBQy"
Message-Id: <201203211937.22423.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_i/haPM4M3O9tBQy
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 21 of March 2012, Arnd Bergmann wrote:
> On Wednesday 21 March 2012, Lubos Lunak wrote:
> > > If so, we might have to replace it with a __KERNEL_NULL constant
> > > or something, like we do for the stuff in linux/types.h, so we
> > > don't accidentally break user applications that rely on the
> > > header files to be self-contained.
> > >
> > > I think there is at least a NULL usage in linux/wireless.h and some
> > > netfilter headers.
> >
> >  I see. How about the attached patch then?
>
> Strictly speaking, you should not include standard headers from kernel
> provided headers, and the problems would be similar to those before
> your patch: anyone who currently doesn't include <stddef.h> but has
> their own definition of NULL will still get a conflict from including
> a kernel header that includes <linux/stddef.h>.

 I guess I should point out that I'm not a kernel developer, I simply want to 
fix the problem that kernel headers redefine NULL to something suboptimal in 
userspace. So I don't know what the requirements on the headers are from the 
kernel side (and I wonder why you need your own NULL in the kernel when it 
comes with the compiler).

 Let me provide one more patch then, which only surrounds the NULL definition 
by #ifndef NULL instead of bluntly doing #undef NULL. That way kernel should 
keep using this NULL definition, while it won't be forced in userspace.

-- 
 Lubos Lunak
 l.lunak@suse.cz

--Boundary-00=_i/haPM4M3O9tBQy
Content-Type: text/x-diff;
  charset="utf-8";
  name="0001-do-not-redefine-userspace-s-NULL-define.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-do-not-redefine-userspace-s-NULL-define.patch"

=46rom 96e2b6caa5c52daade79635270ce96ce764fcd31 Mon Sep 17 00:00:00 2001
=46rom: =3D?UTF-8?q?Lubo=3DC5=3DA1=3D20Lu=3DC5=3D88=3DC3=3DA1k?=3D <l.lunak=
@suse.cz>
Date: Wed, 21 Mar 2012 19:32:02 +0100
Subject: [PATCH] do not redefine userspace's NULL #define
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

GCC's NULL is actually __null, which allows detecting some questionable
NULL usage and warn about it. Moreover each platform/compiler should have
its own stddef.h anyway (which is different from linux/stddef.h).
So there's no good reason to override what the compiler provides.
Keep the #define conditionally, in order to keep the headers self-contained.

Signed-off-by: Lubo=C5=A1 Lu=C5=88=C3=A1k <l.lunak@suse.cz>
=2D--
 include/linux/stddef.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 6a40c76..ce225a9 100644
=2D-- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -3,12 +3,13 @@
=20
 #include <linux/compiler.h>
=20
=2D#undef NULL
+#ifndef NULL
 #if defined(__cplusplus)
 #define NULL 0
 #else
 #define NULL ((void *)0)
 #endif
+#endif
=20
 #ifdef __KERNEL__
=20
=2D-=20
1.7.7


--Boundary-00=_i/haPM4M3O9tBQy--
