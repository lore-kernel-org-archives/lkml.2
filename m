Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab2DSWAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:00:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46729 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab2DSWAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:00:12 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v2 0/5] Speed booting by sorting exception tables at build time.
Date: Thu, 19 Apr 2012 14:59:54 -0700
Message-Id: <1334872799-14589-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

v2: Cosmetic changes only.  Cleanup makefile indentation.  Rebase MIPS
    and x86 Kconfig changes against 3.4-rc2.

    Michal Marek had suggested using $(call cmd,sortextable), but I
    wasn't able to figure out a good way to do that *and* have it print
    'SORTEX vmlinux', so I left it as I originally had it.

v1:

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

o Get rid of the flag word, and assume that if an architecture supports
  build time sorting, that it must have been done.

o Add support for architectures other than MIPS and x86

David Daney (5):
  scripts: Add sortextable to sort the kernel's exception table.
  extable: Skip sorting if sorted at build time.
  kbuild/extable: Hook up sortextable into the build system.
  MIPS: Select BUILDTIME_EXTABLE_SORT
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

