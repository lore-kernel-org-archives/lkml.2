Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab1GaV14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 17:27:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60163 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab1GaV1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 17:27:42 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH v3 0/3] Add support for architectural random number generator
Date: Sun, 31 Jul 2011 14:26:53 -0700
Message-Id: <1312147616-29125-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <CA+55aFy5iRjCigmK-eddkP8Wqy_qFDZRd6PV5d0XFE3p8ws1Bg@mail.gmail.com>
References: <CA+55aFy5iRjCigmK-eddkP8Wqy_qFDZRd6PV5d0XFE3p8ws1Bg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version of the patchset uses inlines with alternatives as
proposed by Linus.  In order to avoid the issue of "random" vs
"urandom", this hooks into *only* the kernel consumer interfaces
get_random_bytes() and get_random_int(); this means that legacy users
of /dev/urandom in userspace will not get direct use RDRAND, but those
can be eventually converted to using RDRAND directly in userspace.

We can, of course, still both pools randomness via rngd or a future
in-kernel mechanism as proposed by Matt.

Since there was a minor amount of confusion I want to clarify: RDRAND
architecturally has weaker security guarantees than the documented
interface for /dev/random, so we can't just replace all users of
extract_entropy() with RDRAND.

Git tree also available:

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-rdrand.git rdrand-3

Again, for technical documentation see:

http://software.intel.com/en-us/articles/download-the-latest-bull-mountain-software-implementation-guide/

Changes in version 3:
- Use inline hooks.
- Enable get_random_int() and get_random_bytes() only, in other words
  only enable the in-kernel users.
- Drop the preinitialization of the random pools; since they are only
  used for userspace consumers when RDRAND is available, they can be fed
  entropy via the input mechanism.

Total changes:
 Documentation/kernel-parameters.txt |    5 ++
 arch/x86/Kconfig                    |    9 ++++
 arch/x86/include/asm/archrandom.h   |   75 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/Makefile        |    1 +
 arch/x86/kernel/cpu/common.c        |    2 +
 arch/x86/kernel/cpu/rdrand.c        |   73 ++++++++++++++++++++++++++++++++++
 drivers/char/random.c               |   25 ++++++++++-
 include/linux/random.h              |   13 ++++++
 8 files changed, 200 insertions(+), 3 deletions(-)
