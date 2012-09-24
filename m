Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2IXSQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:16:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab2IXSQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:16:31 -0400
Subject: Re: sys_kcmp (was: Re: [PATCH 1/2] ARM: add finit_module syscall to
 ARM)
From: Mark Salter <msalter@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Date: Mon, 24 Sep 2012 14:16:09 -0400
In-Reply-To: <20120924174256.GD24172@moon>
References: <CAMuHMdXVKvaCoJTRb4O+Z4GuifzTEopdcRfRHBahQmpuX+Xi0w@mail.gmail.com>
	 <20120922114549.GA11610@moon>
	 <20120922132046.GA4260@flint.arm.linux.org.uk>
	 <20120922114723.d7f07fb6.akpm@linux-foundation.org>
	 <1348503709.20929.40.camel@deneb.redhat.com> <20120924164942.GH16532@moon>
	 <20120924174256.GD24172@moon>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1348510573.20929.44.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 21:42 +0400, Cyrill Gorcunov wrote:
> On Mon, Sep 24, 2012 at 08:49:42PM +0400, Cyrill Gorcunov wrote:
> > > I got past that with:
> > > 
> > > diff --git a/include/linux/security.h b/include/linux/security.h
> > > index 01ef030..14e394d 100644
> > > --- a/include/linux/security.h
> > > +++ b/include/linux/security.h
> > > @@ -118,6 +118,7 @@ void reset_security_ops(void);
> > >  extern unsigned long mmap_min_addr;
> > >  extern unsigned long dac_mmap_min_addr;
> > >  #else
> > > +#define mmap_min_addr          0UL
> > >  #define dac_mmap_min_addr      0UL
> > >  #endif
> > > 
> 
> I think better to add CONFIG_MMU test here.

Well, my patch was just something quick to get the kernel to build, but
thinking about it a bit, I still prefer it. The CONFIG_MMU check is in
security.h already so I think it is less clutter and better for future
code which may use mmap_min_addr. In any case, the compiler will drop
any test for "x < 0UL" so the end result is the same.

> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: prctl: prctl_set_mm -- Don't test for mmap_min_addr on non-MMU config
> 
> In case if CONFIG_MMU is not set the @mmap_min_addr
> is undefined leading to build error. Thus test for
> it iif CONFIG_MMU is present.
> 
> Note this code snippet depends on CONFIG_CHECKPOINT_RESTORE=y.
> 
> Reported-by: Mark Salter <msalter@redhat.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  kernel/sys.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6.git/kernel/sys.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/sys.c
> +++ linux-2.6.git/kernel/sys.c
> @@ -1865,7 +1865,11 @@ static int prctl_set_mm(int opt, unsigne
>  	if (opt == PR_SET_MM_EXE_FILE)
>  		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
>  
> +#ifdef CONFIG_MMU
>  	if (addr >= TASK_SIZE || addr < mmap_min_addr)
> +#else
> +	if (addr >= TASK_SIZE)
> +#endif
>  		return -EINVAL;
>  
>  	error = -EINVAL;


