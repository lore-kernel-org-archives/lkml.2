Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab1KCUlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 16:41:50 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:39375 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1KCUlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 16:41:49 -0400
Subject: Re: [GIT PULL] UML changes for 3.2
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Foley <pefoley2@verizon.net>, Michal Marek <mmarek@suse.cz>
In-Reply-To: <1320348750.14409.249.camel@x61.thuisdomein>
References: <4EB14F51.1050004@nod.at>
	 <1320348750.14409.249.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 21:41:39 +0100
Message-ID: <1320352899.14409.260.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 20:32 +0100, Paul Bolle wrote:
> This is now mainline commit 5c48b108ecbf6505d929e64d50dace13ac2bdf34. It
> broke "make update-po-config", as its symlink trick (again) fails.
> Perhaps the people involved in commit
> bdc69ca4cf972494ad06d1271760d94fdbb2e6b9 ("kconfig: change
> update-po-config to reflect new layout of arch/um") care (they're CC'd).

0) Something as simple as this might be a fix:
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 82d2eb2..69087e3 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -84,8 +84,8 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
            --directory=$(srctree) --directory=$(objtree)           \
            --output $(obj)/config.pot
        $(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
-       $(Q)ln -fs Kconfig.x86 arch/um/Kconfig
-       $(Q)(for i in `ls $(srctree)/arch/*/Kconfig`;    \
+       $(Q)(for i in `ls $(srctree)/arch/*/Kconfig      \
+                                       $(srctree)/arch/*/um/Kconfig`; \
            do                                           \
                echo "  GEN $$i";                        \
                $(obj)/kxgettext $$i                     \
@@ -93,7 +93,6 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
            done )
        $(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
            --output $(obj)/linux.pot
-       $(Q)rm -f $(srctree)/arch/um/Kconfig
        $(Q)rm -f $(obj)/config.pot
 
 PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig

That might even keep working if - one day - arch/ia64/um/Kconfig and
arch/powerpc/um/Kconfig pop up.

1) Note that running make update-po-config seems to do what it's
supposed to do. But it also prints this warning
    arch/um/Kconfig.common:66:warning: environment variable SUBARCH undefined

(I haven't checked if it's new.) It seems harmless. I don't know what
should be done to make it go away.


Paul Bolle

