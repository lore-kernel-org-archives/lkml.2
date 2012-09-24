Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab2IXRnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:43:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46090 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab2IXRnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:43:01 -0400
Date: Mon, 24 Sep 2012 21:42:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Mark Salter <msalter@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: sys_kcmp (was: Re: [PATCH 1/2] ARM: add finit_module syscall to
 ARM)
Message-ID: <20120924174256.GD24172@moon>
References: <CAMuHMdXVKvaCoJTRb4O+Z4GuifzTEopdcRfRHBahQmpuX+Xi0w@mail.gmail.com>
 <20120922114549.GA11610@moon>
 <20120922132046.GA4260@flint.arm.linux.org.uk>
 <20120922114723.d7f07fb6.akpm@linux-foundation.org>
 <1348503709.20929.40.camel@deneb.redhat.com>
 <20120924164942.GH16532@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924164942.GH16532@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 08:49:42PM +0400, Cyrill Gorcunov wrote:
> > I got past that with:
> > 
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index 01ef030..14e394d 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -118,6 +118,7 @@ void reset_security_ops(void);
> >  extern unsigned long mmap_min_addr;
> >  extern unsigned long dac_mmap_min_addr;
> >  #else
> > +#define mmap_min_addr          0UL
> >  #define dac_mmap_min_addr      0UL
> >  #endif
> > 

I think better to add CONFIG_MMU test here.
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: prctl: prctl_set_mm -- Don't test for mmap_min_addr on non-MMU config

In case if CONFIG_MMU is not set the @mmap_min_addr
is undefined leading to build error. Thus test for
it iif CONFIG_MMU is present.

Note this code snippet depends on CONFIG_CHECKPOINT_RESTORE=y.

Reported-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 kernel/sys.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1865,7 +1865,11 @@ static int prctl_set_mm(int opt, unsigne
 	if (opt == PR_SET_MM_EXE_FILE)
 		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
 
+#ifdef CONFIG_MMU
 	if (addr >= TASK_SIZE || addr < mmap_min_addr)
+#else
+	if (addr >= TASK_SIZE)
+#endif
 		return -EINVAL;
 
 	error = -EINVAL;
