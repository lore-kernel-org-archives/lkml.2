Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab1G3WeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 18:34:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38526 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab1G3WeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 18:34:14 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH v2 0/2] Add support for architectural random number generator
Date: Sat, 30 Jul 2011 15:26:21 -0700
Message-Id: <1312064783-9033-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated version of the previous patchset, implementing the "single
long" interface, adding get_random_int() enabling, and fixing a few bugs.

Git tree also available:

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-rdrand.git rdrand-2

This is a proposed patchset to enable the new x86 RDRAND instruction,
labelled "Bull Mountain Technology" by Intel.  It is a different beast
than any other hardware random number generator that I have personally
encountered: it is not just a random number source, but contains a
high bandwidth random number generator, an AES cryptographic whitener,
and integrity monitoring all in hardware.

For technical documentation see:

http://software.intel.com/en-us/articles/download-the-latest-bull-mountain-software-implementation-guide/

This proposed patchset enables RDRAND bypass for current users of the
nonblocking random pool (that is, for /dev/urandom and its equvalent
in-kernel users) but not for the blocking pool (/dev/random).  This is
because RDRAND, although reseeded way more frequently than what is
practical to do in software, is technically a nonblocking source that
can behave as a PRNG.  It can be used as a source for randomness for
/dev/random, but that is not addressed by this patchset.

Changes in version 2:
- Have a single hook per pool (blocking, nonblocking) that returns an
  unsigned long.  The loops to fill an arbitrary buffer has moved to
  generic code.
- Invoke the nonblocking hook to service get_random_int() if it is
  available.  (Note: we could in theory do this for random32() as
  well, however, I have made the assumption that random32() is used
  when speed is the only thing that matters, and the current
  random32() implementation is extremely fast.)
- Correct the use of the nonblocking hook to preinitialize the pool
  data buffers.  Version 1 would incorrectly initialize the input pool
  three times.

This version still retains the indirect function call.  In the
particular case of x86 RDRAND, there is some machinery that we need
around the instruction which makes it slighly awkward to inline, and
the function call doesn't seem to add enough overhead that it is worth
making the interface uglier.

Total changes:

 Documentation/kernel-parameters.txt |    5 ++
 arch/x86/Kconfig                    |    9 +++
 arch/x86/kernel/Makefile            |    2 +
 arch/x86/kernel/rdrand.c            |   65 +++++++++++++++++
 arch/x86/kernel/rdrand_asm.S        |   57 +++++++++++++++
 drivers/char/random.c               |  134 ++++++++++++++++++++++++++++++++++-
 include/linux/random.h              |   14 ++++
 7 files changed, 285 insertions(+), 1 deletions(-)
