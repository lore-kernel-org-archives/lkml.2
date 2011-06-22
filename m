Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1FVGep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:34:45 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:33448 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1FVGen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:34:43 -0400
Date: Wed, 22 Jun 2011 08:34:41 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: __packed vs. __attribute__((packed)) in kernel headers
Message-ID: <20110622063441.GA1740@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent commit 3627924acf70a changed __attribute__ ((packed)) to
__packed in some UBI headers. This breaks the build of busybox:

  CC      miscutils/ubi_attach_detach.o
In file included from miscutils/ubi_attach_detach.c:27:0:
/usr/include/mtd/ubi-user.h:330:3: error: conflicting types for ‘__packed’
/usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
/usr/include/mtd/ubi-user.h:372:3: error: conflicting types for ‘__packed’
/usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
...

But this kind of change is suggested by checkpatch.pl:
  WARN("__packed is preferred over __attribute__((packed))\n

One possible solution would be to let the "scripts/headers_install.pl"
script automatically substitute __packed with __attribute__((packed)):

diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
index efb3be1..e0dc065 100644
--- a/scripts/headers_install.pl
+++ b/scripts/headers_install.pl
@@ -35,6 +35,7 @@ foreach my $file (@files) {
 		$line =~ s/([\s(])__iomem\s/$1/g;
 		$line =~ s/\s__attribute_const__\s/ /g;
 		$line =~ s/\s__attribute_const__$//g;
+		$line =~ s/\s__packed/__attribute__((packed))/g;
 		$line =~ s/^#include <linux\/compiler.h>//;
 		$line =~ s/(^|\s)(inline)\b/$1__$2__/g;
 		$line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;

Any thoughts?

-- 
Markus
