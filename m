Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab0GNOGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:06:10 -0400
Received: from smtp.nokia.com ([192.100.105.134]:57180 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab0GNOGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:06:04 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kbuild@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?q?Sebastian=20Dalfu=C3=9F?= <sd@sedf.de>,
        Oliver Hartkopp <oliver@hartkopp.net>,
        Michael Guntsche <mike@it-loops.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
        Alek Du <alek.du@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Russell King <rmk@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] implement size_append in perl
Date: Wed, 14 Jul 2010 17:01:03 +0300
Message-Id: <1279116063-4499-1-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.rc1.1.gb2842
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Jul 2010 14:01:52.0808 (UTC) FILETIME=[1C8C5280:01CB235D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation has been several times fixed to work around
different shells and build environments and it remains a somewhat tricky
shell script. This patch replaces all the dependencies by a single line
of perl. Build dependency on perl is not new, so that shouldn't be a
problem.

The new implementation does exactly what it's supposed to: it outputs
a little-endian 32-bit unsigned integer of a file's length.

This might simplify matters with different build environments and
different shells and is also considerably shorter and hopefully more
readable.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: Sebastian Dalfuß <sd@sedf.de>
Cc: Oliver Hartkopp <oliver@hartkopp.net>
Cc: Michael Guntsche <mike@it-loops.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Cc: Alek Du <alek.du@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
 scripts/Makefile.lib |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 54fd1b7..5bfd872 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -213,21 +213,7 @@ cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
 
 # Bzip2 and LZMA do not include size in file... so we have to fake that;
 # append the size as a 32-bit littleendian number as gzip does.
-size_append = printf $(shell						\
-dec_size=0;								\
-for F in $1; do								\
-	fsize=$$(stat -c "%s" $$F);					\
-	dec_size=$$(expr $$dec_size + $$fsize);				\
-done;									\
-printf "%08x\n" $$dec_size |						\
-	sed 's/\(..\)/\1 /g' | {					\
-		read ch0 ch1 ch2 ch3;					\
-		for ch in $$ch3 $$ch2 $$ch1 $$ch0; do			\
-			printf '%s%03o' '\\' $$((0x$$ch)); 		\
-		done;							\
-	}								\
-)
-
+size_append = $(PERL) -e 'print pack("V", (stat "$(lastword $1)")[7])'
 quiet_cmd_bzip2 = BZIP2   $@
 cmd_bzip2 = (cat $(filter-out FORCE,$^) | \
 	bzip2 -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
-- 
1.7.1

