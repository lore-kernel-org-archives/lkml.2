Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3AHT4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 14:56:17 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:43194
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756209Ab3AHT4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 14:56:16 -0500
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail03.sonyusa.com;EFVD:NLI
X-SpamScore: 6
X-BigFish: VPS6(zz853kc8kzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh17326ahz2fh2a8h668h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h1155h)
Message-ID: <50EC7ABF.1080901@am.sony.com>
Date: Tue, 8 Jan 2013 11:59:59 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <ak@linux.intel.com>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: Problem with ld-version.sh (scripts/Makefile.lto helper tool)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

I'm experimenting with your LTO kernel tree and found something strange with
your helper script: scripts/ld-version.sh

It doesn't seem to produce sensible numbers for the linker version:

I have version 2.23.51.0.5 of the Linux binutils.
But the version produced by scripts/ld-version.sh is weird.

$ /opt/binutils-2.23.51.0.5/bin/ld -version
GNU ld (Linux/GNU Binutils) 2.23.51.0.5.20121110
Copyright 2012 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License version 3 or (at your option) a later version.
This program has absolutely no warranty.

$ /opt/binutils-2.23.51.0.5/bin/ld -version | scripts/ld-version.sh
22810005

The number of digits reserved for the third portion of the version string
is only 1, and it should be 2.  The '51' is combining with the '23' to
produce the '28' in the strings produced by ld-version.sh

I would recommend changing the script (and the Makefile.lto that
depends on it) as follows:

diff --git a/scripts/Makefile.lto b/scripts/Makefile.lto
index da54968..74a17e2 100644
--- a/scripts/Makefile.lto
+++ b/scripts/Makefile.lto
@@ -16,7 +16,7 @@ ifneq ($(call cc-option,${LTO_CFLAGS},n),n)
 # We need HJ Lu's Linux binutils because mainline binutils does not
 # support mixing assembler and LTO code in the same ld -r object.
 # XXX check if the gcc plugin ld is the expected one too
-ifeq ($(call ld-ifversion,-ge,22710001,y),y)
+ifeq ($(call ld-ifversion,-ge,222510001,y),y)
 # should use -flto=jobserver, but we need a fix for http://gcc.gnu.org/PR50639
         LTO_CFLAGS := -flto -fno-toplevel-reorder
         LTO_FINAL_CFLAGS := -fuse-linker-plugin -flto=$(shell getconf _NPROCESSORS_ONLN) -fno-toplevel-reorder
diff --git a/scripts/ld-version.sh b/scripts/ld-version.sh
index 7eb0b76..6aed2be 100755
--- a/scripts/ld-version.sh
+++ b/scripts/ld-version.sh
@@ -3,6 +3,6 @@
 	{
 	gsub(".*)", "");
 	split($1,a, ".");
-	print a[1]*10000000 + a[2]*100000 + a[3]*10000 + a[4]*100 + a[5];
+	print a[1]*100000000 + a[2]*1000000 + a[3]*10000 + a[4]*100 + a[5];
 	exit
 	}

I presume that the required version of binutils is actually 2.22.51.0.1, and not
2.27.<something> (which appears to not exist yet).

 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

