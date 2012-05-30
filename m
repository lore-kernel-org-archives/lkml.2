Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2E3Uei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:34:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab2E3Ueg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:34:36 -0400
Date: Wed, 30 May 2012 16:34:28 -0400
From: Jason Baron <jbaron@redhat.com>
To: shawn <shawnlandden@gmail.com>
Cc: Jim Cromie <jim.cromie@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-arm@vger.kernel.org
Subject: Re: =?utf-8?Q?include=2Flinux=2Fdynamic=5F?=
 =?utf-8?Q?debug=2Eh=3A111=3A2=3A_error=3A_implicit_declaration_of_functio?=
 =?utf-8?B?biDigJhzdHJzdHLigJk=?=
Message-ID: <20120530203428.GB16686@redhat.com>
References: <1338334286.2658.536.camel@shawn-ssd>
 <CAJfuBxweY7sG2KZDPHsrOP6iu8sQxw8EvCKA1QtGnDFKA92zag@mail.gmail.com>
 <1338342203.2658.544.camel@shawn-ssd>
 <CAJfuBxwP_p4Y4pp50qfEts4zoOkJ16Hj_Yu68q3qd7=5UMLeiw@mail.gmail.com>
 <1338387021.23168.18.camel@shawn-ssd>
 <CAJfuBxxkMJbmvQMCZx=6GUqJ8c6VnT8jaRTKA-OWZLa0gG7kUw@mail.gmail.com>
 <1338406801.23168.74.camel@shawn-ssd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1338406801.23168.74.camel@shawn-ssd>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 12:40:01PM -0700, shawn wrote:
> summary:
> 
> the recently added to arm, CONFIG_KERNEL_XZ is broken because
> arch/arm/boot/compressed/decompress.c defines _LINUX_STRING_H
> overriding <linux/string.h> used in include/linux/dynamic_debug.h:111
> 

If arch/arm/boot/compressed/decompress.c is going to define
'_LINUX_STRING_H', I think it needs to provide any string functions that
might be missing. Thus in this case, if you add a:

extern char * strstr(const char *, const char *);

right before:

#include "../../../../lib/decompress_unxz.c",

does that fix things?

Thanks,

-Jason


> 
> On Wed, 2012-05-30 at 11:53 -0600, Jim Cromie wrote: 
> > On Wed, May 30, 2012 at 8:10 AM, shawn <shawnlandden@gmail.com> wrote:
> > > On Wed, 2012-05-30 at 02:35 -0600, Jim Cromie wrote:
> > >> On Tue, May 29, 2012 at 7:43 PM, shawn <shawnlandden@gmail.com> wrote:
> > >> > jim,
> > >> > On Tue, 2012-05-29 at 19:11 -0600, Jim Cromie wrote:
> > >> >> On Tue, May 29, 2012 at 5:31 PM, shawn <shawnlandden@gmail.com> wrote:
> > >> >> >  SHIPPED arch/arm/boot/compressed/lib1funcs.S
> > >> >> > In file included from include/linux/kernel.h:23:0,
> > >> >> >                 from
> > >> >> > arch/arm/boot/compressed/../../../../lib/xz/xz_private.h:15,
> > >> >> >                 from
> > >> >> > arch/arm/boot/compressed/../../../../lib/decompress_unxz.c:145,
> > >> >> >                 from arch/arm/boot/compressed/decompress.c:50:
> > >> >> > include/linux/dynamic_debug.h: In function
> > >> >> > ‘ddebug_dyndbg_module_param_cb’:
> > >> >> > include/linux/dynamic_debug.h:111:2: error: implicit declaration of
> > >> >> > function ‘strstr’ [-Werror=implicit-function-declaration]
> > >> >> >
> > >> >> > git blame shows b48420c1d3019ce8d84fb8e58f4ca86b8e3655b8 as introducing
> > >> >> > this call
> > >> >>
> > >> >> that symbol should have been provided by line 100
> > >> >>
> > >> >>      98 #else
> > >> >>      99
> > >> >>     100 #include <linux/string.h>
> > >> >>     101 #include <linux/errno.h>
> > >> >> ...
> > >> >>     108 static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
> > >> >>     109                                                 const char *modname)
> > >> >>     110 {
> > >> >>     111         if (strstr(param, "dyndbg")) {
> > >> >
> > >> >> which has:
> > >> >>
> > >> >>      74 #ifndef __HAVE_ARCH_STRSTR
> > >> >>      75 extern char * strstr(const char *, const char *);
> > >> >>      76 #endif
> > >> >> does your arch have __HAVE_ARCH_STRSTR ?
> > >> >> if so, is strstr exported under different conditions ??
> > >> > a git grep __HAVE_ARCH_STRSTR did not show and such defines in the arm
> > >> > tree
> > >>
> > >> thats odd - you should have gotten the generic one then.
> > >>
> > >> >> Can you send me
> > >> >> arch/arm/boot/compressed/decompress.i  ?
> > >> > I didn't have that file after the failure, but
> > >>
> > >> nor would you with success, but you did the right thing below..
> > >>
> > >> > make arch/arm/boot/compressed/decompress.i
> > >> >
> > >> > summoned it, also including string.o from that folder (which was present
> > >> > after the failure)
> > >> >
> > >> > I am compiling on amd64, using
> > >> > export ARCH=arm
> > >> > and
> > >> > CONFIG_CROSS_COMPILE="arm-linux-gnueabi-"
> > >> >
> > >> >
> > >> > I have had issues with the cross compiler not always being called since
> > >> > the 3.5 merge window opened up, (ld reporting corrupted binary files and
> > >> > gcc saying it doesn't understand arm-specific flags) and have not yet
> > >> > compiled a post-v3.4 successful kernel. This could be a symptom of that.
> > >> > (esp as the host arch, x86 DOES have __HAVE_ARCH_STRSTR)
> > >> >
> > >>
> > >> hmm
> > >> CONFIG_CROSS_COMPILE is new in 3.5-rc isnt it ?
> > >> what happens if you do it the old (3.4) way ?
> > > No, CONFIG_CROSS_COMPILE is not new, I've been doing it this way for a
> > > few versions, before with the emdebian cross toolchain. in meuconfig it
> > > shows up under: General Config --> Cross-compiler tool prefix
> > 
> > Ah yes - I see its not new (far from it)
> > 
> > commit 84336466011c589b6af554f2f2f1fcfa1a5c1437
> > Author: Roland McGrath <roland@redhat.com>
> > Date:   Mon Dec 21 16:24:06 2009 -0800
> > 
> >     kconfig CROSS_COMPILE option
> > 
> > 
> > > This is the arm toolchain that is in the Ubuntu repos.
> > >
> > > http://packages.ubuntu.com/precise/gcc-4.6-arm-linux-gnueabi
> > 
> > I went ahead and installed the arm toolchain from kernel.org,
> > and got what look to be errors like you mentioned:
> > 
> > [jimc@groucho linux-2.6-dep]$ make
> > make[1]: Nothing to be done for `all'.
> > make[1]: Nothing to be done for `relocs'.
> >   CHK     include/linux/version.h
> >   CHK     include/generated/utsrelease.h
> >   CC      kernel/bounds.s
> > cc1: error: unrecognized command line option '-m64'
> > cc1: error: unrecognized command line option '-mno-red-zone'
> > cc1: error: unrecognized command line option '-mcmodel=kernel'
> > cc1: error: unrecognized command line option '-maccumulate-outgoing-args'
> > make[1]: *** [kernel/bounds.s] Error 1
> > make: *** [prepare0] Error 2
> > 
> > this is with toolchain dir in the front of the path, after doing
> > make ARCH=arm defconfig
> > make xconfig # and adding the cross-compile value
> > 
> > I got much further when I kept ARCH=arm as make arg;
> > it completed the build.  Youre getting it from the environment,
> > which should be the same, but its worth a try...
> > 
> > [jimc@groucho linux-2.6-dep]$ file vmlinux*
> > vmlinux:   ELF 32-bit LSB executable, ARM, version 1, statically
> > linked, not stripped
> > vmlinux.o: ELF 32-bit LSB relocatable, ARM, version 1, not stripped
> > 
> > FWIW, this was an in-src build, my attempt at O=../build-arm spat at me.
> > 
> > 
> > > And I have successfully built kernels with this toolchain, and the
> > > debian native arm 4.6 compiler, at the same time, using distcc. (however
> > > I turned both distcc and ccache off for the error I sent)
> > >
> > > After having the issues with 3.5, I reinstalled, well parts of the tools
> > > chain with apt-get install --reinstall.
> > >
> > > What is the old way to cross-compile?
> > 
> > from the config help text:
> > 
> > Same as running 'make CROSS_COMPILE=prefix-' but stored for
> > default make runs in this kernel build directory. You don't
> > need to set this unless you want the configured kernel build
> > directory to select the cross-compiler automatically.
> > 
> > FWIW, it sounds more fiddly than using the now-quite-mature
> > CROSS_COMPILE config-item
> > 
> > 
> > 
> > >> What toolchain are you using ?
> > >> can you replicate it using something here ?
> > >>
> > >> http://kernel.org/pub/tools/crosstool/
> > 
> > Since I got a build using this, you should give it a go.
> > If it works, file a bug report with ubuntu.
> 
> arch/arm/boot/compressed/decompress.c
> 
> has
> 
> #define _LINUX_STRING_H_
> 
> which prevents <linux/string.h> from loading
> 
> 
> therefore: xz_private.h cannot include <linux/kernel.h>, or
> arch/arm/boot/compressed/decompress.c must define strstr
> 
> I tried to remove the #include <linux/kernel.h> 
> from xz_private.h, and replace it with more specific includes but cannot
> because lib/xz/xz_dec_lzma2.c uses min() which is defined in the
> <linux/kernel.h> header
> 
>   CC      arch/arm/boot/compressed/decompress.o
> In file included from include/linux/kernel.h:23:0,
>                  from
> arch/arm/boot/compressed/../../../../lib/xz/xz_private.h:15,
>                  from
> arch/arm/boot/compressed/../../../../lib/decompress_unxz.c:145,
>                  from arch/arm/boot/compressed/decompress.c:50:
> include/linux/dynamic_debug.h: In function
> ‘ddebug_dyndbg_module_param_cb’:
> include/linux/dynamic_debug.h:111:2: error: implicit declaration of
> function ‘strstr’ [-Werror=implicit-function-declaration]
> 
> > 
> > >
> > > --
> > > -Shawn Landden
> > >
> > 
> > let me know how you get on,
> > ( learning from others' pain is one of the values of empathy! )
> > 
> > Jim
> 
> 
> -- 
> -Shawn Landden
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
