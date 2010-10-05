Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0JEDca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 23:32:30 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:53035 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603Ab0JEDc3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 23:32:29 -0400
Date: Mon, 4 Oct 2010 20:30:28 -0700
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] kbuild: remove duplicate -I flag in addtree
Message-ID: <20101005033028.GD10162@haskell.muteddisk.com>
Mail-Followup-To: Michal Marek <mmarek@suse.cz>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <1285553472-924-1-git-send-email-mfm@muteddisk.com>
 <20101004151045.GA5637@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20101004151045.GA5637@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:10 Mon 04 Oct     , Michal Marek wrote:
> On Sun, Sep 26, 2010 at 07:11:12PM -0700, matt mooney wrote:
> > When O= is used, any -I flag given that is not an absolute path gets
> > duplicated. The $(1) appended to the conditional clause covers the
> > absolute case, but due to being outside of the conditional statement
> > it gets added everytime.
> > 
> > Signed-off-by: matt mooney <mfm@muteddisk.com>
> > ---
> >  scripts/Kbuild.include |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> > index ed2773e..08c74ed 100644
> > --- a/scripts/Kbuild.include
> > +++ b/scripts/Kbuild.include
> > @@ -158,7 +158,7 @@ modbuiltin := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.modbuiltin obj
> >  # Prefix -I with $(srctree) if it is not an absolute path.
> >  # skip if -I has no parameter
> >  addtree = $(if $(patsubst -I%,%,$(1)), \
> > -$(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1))
> > +$(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1)),$(1)))
> 
> $ mkdir _build-new; make O=_build-new defconfig; make O=_build-new V=1 all
> fails with
> 
>   perl /home/mmarek/linux-2.6/kernel/timeconst.pl 1000 > kernel/timeconst.h
>   gcc -Wp,-MD,kernel/.time.o.d  -nostdinc -isystem /usr/lib64/gcc/x86_64-suse-linux/4.5/include -I/home/mmarek/linux-2.6/arch/x86/include -Iinclude  -I/home/mmarek/linux-2.6/include -include include/generated/autoconf.h  -I/home/mmarek/linux-2.6/kernel -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -m64 -mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(time)"  -D"KBUILD_MODNAME=KBUILD_STR(time)"  -c -o kernel/time.o /home/mmarek
> /linux-2.6/kernel/time.c
> /home/mmarek/linux-2.6/kernel/time.c:44:23: fatal error: timeconst.h: No such file or directory
> 
> The correct gcc line without your patch is 
>   gcc -Wp,-MD,kernel/.time.o.d  -nostdinc -isystem /usr/lib64/gcc/x86_64-suse-linux/4.5/include -I/home/mmarek/linux-2.6/arch/x86/include -Iinclude  -I/home/mmarek/linux-2.6/include -include include/generated/autoconf.h  -I/home/mmarek/linux-2.6/kernel -Ikernel -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -m64 -mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(time)"  -D"KBUILD_MODNAME=KBUILD_STR(time)"  -c -o kernel/time.o /ho
> me/mmarek/linux-2.6/kernel/time.c
> 
> The difference is that with your patch it is lacking the -Ikernel
> include, so it does not search for generated header files in $(obj).

Ugh! I tested it for an external module and I built every driver under media/
thinking this covered all cases. I completely forgot about generated files.

Thanks,
mfm
