Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab1IALgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 07:36:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49774 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1IALgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 07:36:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFD: x32 ABI system call numbers
Date: Thu, 1 Sep 2011 13:35:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
References: <4E582577.2060805@zytor.com> <CA+55aFzEnGb3G2WeVNoS5e2D4poY5O6gJucnVnFRF51NUYkW8A@mail.gmail.com> <4E5E71A8.8090209@zytor.com>
In-Reply-To: <4E5E71A8.8090209@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011335.05663.arnd@arndb.de>
X-Provags-ID: V02:K0:O8UYQEe5yKvSo+XoprKhvUDv5F/xoP8oYZzm/mLXlvd
 cQtCjQ1pJJo432nSO8Xc0iR6GFUrvAR6SzKmxdrAes3ziOCS+z
 dVere6sJomRKzgfTlTx92dBH5wE/XtjJq0bK4afLRV3PmS8EUu
 NxkWvbG0gAYLXfs/I/Hl6YANQb1MppW1rfeQ+Z9k/INAgPATHV
 GrA3IhqyTHmCgn+28zVkqcrgA4y6LMlnoae9rCr46h0LKQw2s6
 jkNzAu3W/9otFA7dJjZtLqu7by3d4Qd73vEexYy82N+VZVDjBe
 uuDlH1tMJ4EecSv9U8AvUAjk/1GDakyiEkzfaJHmcSoBhLeIcU
 k1TsNTOln4ZMy3ghRhb8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 August 2011, H. Peter Anvin wrote:
> On 08/31/2011 10:19 AM, Linus Torvalds wrote:
> > 
> > I think tv_nsec was just overlooked, and people thought "it has no
> > legacy users that were 'int', so we'll just leave it at 'long', which
> > is guaranteed to be enough for nanoseconds that only needs a range of
> > 32 bits".
> > 
> > In contrast, tv_usec probably does have legacy users that are "int".
> > 
> > So POSIX almost certainly only looked backwards, and never thought
> > about users who would need to make it "long long" for compatibility
> > reasons.
> > 
> > The fact that *every*other*related*field* in POSIX/SuS has a typedef
> > exactly for these kinds of reasons just shows how stupid that "long
> > tv_nsec" thing is.
> > 
> > I suspect that on Linux we can just say "tv_nsec" is suseconds_t too.
> > Then we can make time_t and suseconds_t just match, and be "__s64" on
> > all new platforms.
> > 
> 
> Let me see if I can raise this with the POSIX committee.

Shall we go ahead with this patch for 3.1 in the meantime? This is the
least invasive way I can see to let OpenRISC use 64 bit time_t in the
released kernel.

The worst thing that can happen is that we will have to change it again
if this patch breaks something on OpenRISC, but if we don't do it now,
then we have one more architecture stuck with 32 bit time_t or we will
have to break its ABI.

I'm not completely convinced about the type we should use for tv_nsec
and tv_usec. The main worry I have is that common implementations
of timeval_add() or similar will require an expensive 64 bit division
on 32 bit systems, which they would not need with a 32 bit suseconds_t.
Should we use explicit padding instead in that case?

Interestingly, I noticed that parisc always uses a 32 bit suseconds_t,
even for its 64 bit ABI (which is not used all that much), so it has
implicit padding.

8<----
OpenRISC: change time_t and suseconds_t to 64 bit

time_t should really be 64 bit wide for all new ABIs including 32 bit
architectures, to allow having timestamps beyond 2038. For now, we
leave the default in asm-generic/posix-types to 32 bit wide, but the
plan is to change that in the next merge window so we reduce the
risk of breaking other architectures in the process.

In order to allow struct timespec/timeval to be free of padding, we
need suseconds_t to be the same size, and change the second member
of struct timespec to also be suseconds_t instead of long.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 11162e6..77bcc02 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -38,7 +38,6 @@ generic-y += msgbuf.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
-generic-y += posix_types.h
 generic-y += resource.h
 generic-y += rmap.h
 generic-y += scatterlist.h
diff --git a/arch/openrisc/include/asm/posix_types.h b/arch/openrisc/include/asm/posix_types.h
new file mode 100644
index 0000000..f0b2944
--- /dev/null
+++ b/arch/openrisc/include/asm/posix_types.h
@@ -0,0 +1,12 @@
+#ifndef __OPENRISC_POSIX_TIME_T
+#define __OPENRISC_POSIX_TIME_T
+
+typedef long long __kernel_suseconds_t;
+#define __kernel_suseconds_t __kernel_suseconds_t
+
+typedef long long __kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+#include <asm-generic/posix_types.h>
+
+#endif
diff --git a/include/asm-generic/posix_types.h b/include/asm-generic/posix_types.h
index 3dab008..0c53135 100644
--- a/include/asm-generic/posix_types.h
+++ b/include/asm-generic/posix_types.h
@@ -39,6 +39,10 @@ typedef unsigned int	__kernel_gid_t;
 typedef long		__kernel_suseconds_t;
 #endif
 
+#ifndef __kernel_time_t
+typedef long		__kernel_time_t;
+#endif
+
 #ifndef __kernel_daddr_t
 typedef int		__kernel_daddr_t;
 #endif
@@ -78,7 +82,6 @@ typedef long		__kernel_ptrdiff_t;
  */
 typedef long		__kernel_off_t;
 typedef long long	__kernel_loff_t;
-typedef long		__kernel_time_t;
 typedef long		__kernel_clock_t;
 typedef int		__kernel_timer_t;
 typedef int		__kernel_clockid_t;
diff --git a/include/linux/time.h b/include/linux/time.h
index b306178..207c0aa 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -12,8 +12,8 @@
 #ifndef _STRUCT_TIMESPEC
 #define _STRUCT_TIMESPEC
 struct timespec {
-	__kernel_time_t	tv_sec;			/* seconds */
-	long		tv_nsec;		/* nanoseconds */
+	__kernel_time_t		tv_sec;		/* seconds */
+	__kernel_suseconds_t	tv_nsec;	/* nanoseconds */
 };
 #endif
 
