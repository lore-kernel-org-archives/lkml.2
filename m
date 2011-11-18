Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab1KRTiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:38:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50179 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab1KRTiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:38:07 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-embedded@vger.kernel.org, x86@kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH RFC 0/5] Speed booting by sorting exception tables at build time.
Date: Fri, 18 Nov 2011 11:37:43 -0800
Message-Id: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

I noticed when booting MIPS64 kernels that sorting of the main
__ex_table was taking a long time (2,692,220 cycles or 3.3 mS at
800MHz to be exact).  That is not too bad for real silicon
implementations, but when running on a slow simulator, it can be
significant.

I can get this down to about 1,000,000 cycles by supplying a custom
swap function for the sort, but even better is to eliminate it
entirely by doing the sort at build time. That is the idea behind
this patch set.

Here is more or less what I did:

o A flag word is added to the kernel to indicate that the __ex_table
  is already sorted.  sort_main_extable() checks this and if it is
  clear, returns without doing the sort.

o I shamelessly stole code from recordmcount and created a new build
  time helper program 'sortextable'.  This is run on the final vmlinux
  image, it sorts the table, and then clears the flag word.

Potential areas for improvement:

o Sort module exception tables too.

o Get rit of the flag word, and assume that if an architecture supports
  build time sorting, that it must have been done.

o Add support for architectures other than MIPS and x86

Any comments most welcome,

David Daney (5):
  scripts: Add sortextable to sort the kernel's exception table.
  extable: Skip sorting if sorted at build time.
  kbuild/extable: Hook up sortextable into the build system.
  MIPS:  Select BUILDTIME_EXTABLE_SORT
  x86: Select BUILDTIME_EXTABLE_SORT

 Makefile              |   10 ++
 arch/mips/Kconfig     |    1 +
 arch/x86/Kconfig      |    1 +
 init/Kconfig          |    3 +
 kernel/extable.c      |    8 ++-
 scripts/.gitignore    |    1 +
 scripts/Makefile      |    1 +
 scripts/sortextable.c |  273 +++++++++++++++++++++++++++++++++++++++++++++++++
 scripts/sortextable.h |  168 ++++++++++++++++++++++++++++++
 9 files changed, 465 insertions(+), 1 deletions(-)
 create mode 100644 scripts/sortextable.c
 create mode 100644 scripts/sortextable.h

-- 
1.7.2.3

