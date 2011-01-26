Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1AZKCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:02:15 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:12640 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab1AZKCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:02:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19775.61731.753606.576942@pilspetsen.it.uu.se>
Date: Wed, 26 Jan 2011 11:02:11 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Harald Dunkel <harri@afaics.de>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [Patch] make installkernel configurable from command line (was
 Re: how to avoid that install.sh goes mad, if I am not root?)
In-Reply-To: <20110125054800.GC13618@cr0.nay.redhat.com>
References: <4D388A08.1010004@afaics.de>
	<19768.44428.482148.361069@pilspetsen.it.uu.se>
	<ihbvd1$jbj$3@dough.gmane.org>
	<4D3A03CA.2060507@afaics.de>
	<20110124102159.GD5510@cr0.nay.redhat.com>
	<19773.26066.137666.718852@pilspetsen.it.uu.se>
	<20110125054800.GC13618@cr0.nay.redhat.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc: linux-kbuild's address corrected]

=?utf-8?Q?Am=C3=A9rico?= Wang writes:
 > On Mon, Jan 24, 2011 at 12:43:14PM +0100, Mikael Pettersson wrote:
 > >NAK -- this breaks existing setups which rely on /root/bin/installkernel
 > >being picked up automatically.
 > >
 > >Can you handle 'make INSTALLKERNEL=...' without breaking that please?
 > 
 > Yes, here we go.
 > 
 > --------->
 > 
 > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
 > 
 > ---
 > diff --git a/Makefile b/Makefile
 > index 1f47495..44abded 100644
 > --- a/Makefile
 > +++ b/Makefile
 > @@ -327,7 +327,7 @@ OBJCOPY		= $(CROSS_COMPILE)objcopy
 >  OBJDUMP		= $(CROSS_COMPILE)objdump
 >  AWK		= awk
 >  GENKSYMS	= scripts/genksyms/genksyms
 > -INSTALLKERNEL  := installkernel
 > +INSTALLKERNEL  ?= /sbin/installkernel
 >  DEPMOD		= /sbin/depmod
 >  KALLSYMS	= scripts/kallsyms
 >  PERL		= perl
 > diff --git a/arch/x86/boot/install.sh b/arch/x86/boot/install.sh
 > index d13ec1c..c8c9a92 100644
 > --- a/arch/x86/boot/install.sh
 > +++ b/arch/x86/boot/install.sh
 > @@ -33,8 +33,8 @@ verify "$3"
 >  
 >  # User may have a custom install script
 >  
 > -if [ -x ~/bin/${INSTALLKERNEL} ]; then exec ~/bin/${INSTALLKERNEL} "$@"; fi
 > -if [ -x /sbin/${INSTALLKERNEL} ]; then exec /sbin/${INSTALLKERNEL} "$@"; fi
 > +if [ -x ~/bin/installkernel ]; then exec ~/bin/installkernel "$@"; fi
 > +if [ -x "${INSTALLKERNEL}" ]; then exec "${INSTALLKERNEL}" "$@"; fi
 >  
 >  # Default install - same as make zlilo

Tested.  This works as far as not overriding root's ~/bin/installkernel
if it exists, but it fails to give precedence to an explicit command-line
INSTALLKERNEL=... over the built-in fallbacks.  I don't see an easy way
to fix that without first consolidating all archs' INSTALLKERNEL handling
into the top-level Makefile.

Not using make install and just invoking your own install script directly
works, so I'm not sure this is worth the trouble (unless you can unify all
archs' INSTALLKERNEL handling as a side-effect / cleanup).
