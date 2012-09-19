Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab2ISRiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:38:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab2ISRiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:38:06 -0400
Message-ID: <505A02F8.4040804@suse.de>
Date: Wed, 19 Sep 2012 13:38:00 -0400
From: Jeff Mahoney <jeffm@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH[ Makefile: Fix scripts_basic / archscripts build order
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SUSE kernel packages are built by doing the following:

make silentoldonfig
make prepare
make scripts
make clean

<capture file list used for building modules>

make -j$NCPUs

On parallel builds (also using -C/O=), this can occasionally fail with:
  HOSTCC  scripts/basic/fixdep
  /bin/sh: scripts/basic/fixdep: No such file or directory
  make[3]: *** [arch/x86/tools/relocs] Error 1
  make[2]: *** [archscripts] Error 2
  make[2]: *** Waiting for unfinished jobs....
  make[1]: *** [sub-make] Error 2
  make: *** [all] Error 2

The error can also be "Permission denied."

Without the make clean this works ok.

What seems to be happening is that fixdep exists so relocs is able to be
rebuilt, but then somewhere there is a FORCE rule that applies to fixdep
so it is rebuilt. If the timing is right, the relocs build can happen while
the fixdep rebuild is happening and we either get a non-executable fixdep
or a nonexistent fixdep.

This patch moves the archscripts dependency after scripts_basic so that
fixdep is always built after relocs. If I understand the build order
correctly, this should be the case since scripts_basic is essentially
a prereq of everything.

This was introduced by commit
6520fe55 (x86, realmode: 16-bit real-mode code support for relocs),
which added the archscripts dependency to archprepare.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -835,7 +835,7 @@ prepare1: prepare2 include/linux/version
                    include/config/auto.conf
 	$(cmd_crmodverdir)
 
-archprepare: archheaders archscripts prepare1 scripts_basic
+archprepare: archheaders scripts_basic archscripts prepare1
 
 prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=.

-- 
Jeff Mahoney
SUSE Labs
