Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab1EBLNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 07:13:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab1EBLNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 07:13:39 -0400
Date: Mon, 2 May 2011 13:13:37 +0200
From: Michal Marek <mmarek@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Jones <davej@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
Message-ID: <20110502111337.GA15769@sepie.suse.cz>
References: <20110502121817.645d544e.sfr@canb.auug.org.au>
 <20110502022417.GA11804@redhat.com>
 <20110502134524.40da4245.sfr@canb.auug.org.au>
 <20110502142454.a7091ad5.sfr@canb.auug.org.au>
 <20110502145338.7be2fdbc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502145338.7be2fdbc.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 02:53:38PM +1000, Stephen Rothwell wrote:
> Hi Dave,
> 
> hmmm,
> 
> On my build machine:
> $ /opt/cross/gcc-4.4.5-nolibc/x86_64-linux/bin/x86_64-linux-gcc -Wno-unused-but-set-variable -c -xc /dev/null -o /tmp/xx.o; echo $?
> 0
> $ /opt/cross/gcc-4.4.5-nolibc/x86_64-linux/bin/x86_64-linux-gcc -Wunused-but-set-variable -c -xc /dev/null -o /tmp/xx.o; echo $?
> cc1: error: unrecognized command line option "-Wunused-but-set-variable"
> 1
> $ gcc -Wno-unused-but-set-variable -c -xc /dev/null -o /tmp/xx.o; echo $?
> 0
> $ gcc -Wunused-but-set-variable -c -xc /dev/null -o /tmp/xx.o; echo $?
> cc1: error: unrecognized command line option "-Wunused-but-set-variable"
> 1

I reproduced this myself with 4.5.1 and 4.6.0 and was about to file a
bug at gcc.gnu.org, but I learned that this is a feature :-(, see here:
http://gcc.gnu.org/PR28322 . It treats invalid -Wno-* options as
warnings and it only issues them when there is another warning or error
in the source.

I have a patch below, but after learning the above, I'm going to rewrite
it to some more generic cc-disable-warning fuction, because it can hit
us anytime again.

Michal

Subject: [PATCH] kbuild: Fix passing -Wno-unused-but-set-variable to some gcc versions

Some versions of gcc will happily accept -Wno-<anything> in the
cc-option test and complain later when compiling some random file that
-Wno-unused-but-set-variable is not recognized. Work around this by
testing if gcc supports the -Wunused-but-set-variable option insteaed.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/Makefile b/Makefile
index 4527dc2..db6b6df 100644
--- a/Makefile
+++ b/Makefile
@@ -569,7 +569,12 @@ endif
 
 # This warning generated too much noise in a regular build.
 # Use make W=1 to enable this warning (see scripts/Makefile.build)
-KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+# We test for support of the -Wunused-but-set-variable option, because
+# some version of gcc will happily accept any -Wno-* switch and complain
+# later during build.
+ifeq ($(call cc-option-yn, -Wunused-but-set-variable), y)
+KBUILD_CFLAGS += -Wno-unused-but-set-variable
+endif
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
