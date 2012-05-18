Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967842Ab2ERWY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:24:59 -0400
Received: from mail1.windriver.com ([147.11.146.13]:48143 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967775Ab2ERWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:24:55 -0400
Date: Fri, 18 May 2012 18:24:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Sam Ravnborg <sam@ravnborg.org>
CC: <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Eric B Munson <emunson@mgebm.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] kvm: make asm-generic/kvm_para.h have an ifdef
 __KERNEL__ block
Message-ID: <20120518222441.GD15256@windriver.com>
References: <1337363979-5121-1-git-send-email-paul.gortmaker@windriver.com>
 <20120518184217.GA17367@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120518184217.GA17367@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] kvm: make asm-generic/kvm_para.h have an ifdef __KERNEL__ block] On 18/05/2012 (Fri 20:42) Sam Ravnborg wrote:

> On Fri, May 18, 2012 at 01:59:39PM -0400, Paul Gortmaker wrote:
> > There are two functions in this asm-generic file.  Looking at
> > other arch which do not use the generic version, these two fcns
> > are within an #ifdef __KERNEL__ block, so make the generic one
> > consistent with those.
> > 
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > 
> > diff --git a/include/asm-generic/kvm_para.h b/include/asm-generic/kvm_para.h
> > index 9a7bbad..5cba37f 100644
> > --- a/include/asm-generic/kvm_para.h
> > +++ b/include/asm-generic/kvm_para.h
> > @@ -1,6 +1,7 @@
> >  #ifndef _ASM_GENERIC_KVM_PARA_H
> >  #define _ASM_GENERIC_KVM_PARA_H
> >  
> > +#ifdef __KERNEL__
> >  
> >  /*
> >   * This function is used by architectures that support kvm to avoid issuing
> > @@ -16,4 +17,6 @@ static inline unsigned int kvm_arch_para_features(void)
> >  	return 0;
> >  }
> >  
> > +#endif	/* _KERNEL__ */
> > +
> >  #endif
> 
> I do not have this file in my tree...

It appears in linux-next with this commit:

commit 3b5d56b9317fa7b5407dff1aa7b115bf6cdbd494
Author: Eric B Munson <emunson@mgebm.net>
Date:   Sat Mar 10 14:37:26 2012 -0500

    kvmclock: Add functions to check if the host has stopped the vm

Additional stub is added to it in this commit (also linux-next):

commit 1f15d10984c854e077da5aa1a23f901496b49773
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Fri Apr 20 18:21:46 2012 -0300

    KVM: add kvm_arch_para_features stub to asm-generic/kvm_para.h

> But in general we should try to separate out exporeted stuff in their own headers,
> so no new files should ever use __KERNEL__.
> 
> Either everything or nothing is exported.

I cant argue with that.  So, just for context, the issue I was looking
at was this failure in linux-next:

CHECK   include/asm (32 files)
/scratch/kisskb/build/linux-next_parisc-defconfig_parisc/usr/include/asm/kvm_para.h:1:
included file 'asm-generic/kvm_para.h' is not exported
make[3]: ***
[/scratch/kisskb/build/linux-next_parisc-defconfig_parisc/usr/include/asm/.check]
Error 123
make[3]: Target `__headerscheck' not remade because of errors.
make[2]: *** [headers_check] Error 2
make[1]: *** [vmlinux] Error 2

http://kisskb.ellerman.id.au/kisskb/buildresult/6337975/

The above is pa-risc, but it also appears on any arch using the generic
header, instead of an arch specific one, like sparc:

http://kisskb.ellerman.id.au/kisskb/buildresult/6291409/

My patch doesn't fix this issue, but I thought it made sense at the
time, just based on the comparison to the other arch specific versions
of the same file.  I'm fine with junking it and leaving you guys to
decide what is best to export and where [for headers_check].

Thanks,
Paul.
