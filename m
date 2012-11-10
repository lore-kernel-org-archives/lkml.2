Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2KJTV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 14:21:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45464 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2KJTV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 14:21:57 -0500
Date: Sat, 10 Nov 2012 14:21:55 -0500 (EST)
Message-Id: <20121110.142155.1166520917218665957.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several build/bug fixes for sparc, including:

1) Configuring a mix of static vs. modular sparc64 crypto modules
   didn't work, remove an ill-conceived attempt to only have to build
   the device match table for these drivers once to fix the problem.

   Reported by Meelis Roos.

2) Make the montgomery multiple/square and mpmul instructions actually
   usable in 32-bit tasks.  Essentially this involves providing 32-bit
   userspace with a way to use a 64-bit stack when it needs to.

3) Our sparc64 atomic backoffs don't yield cpu strands properly on
   Niagara chips.  Use pause instruction when available to achieve
   this, otherwise use a benign instruction we know blocks the
   strand for some time.

4) Wire up kcmp

5) Fix the build of various drivers by removing the unnecessary
   blocking of OF_GPIO when SPARC.

6) Fix unintended regression wherein of_address_to_resource stopped
   being provided.  Fix from Andreas Larsson.

7) Fix NULL dereference in leon_handle_ext_irq(), also from Andreas
   Larsson.

Please pull, thanks a lot.

The following changes since commit 1d47091ac6bf1286d708ebcd3f2b69d7c682916b:

  Merge tag 'usb-3.7-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2012-10-26 10:26:36 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc master

for you to fetch changes up to 226f7cea949303a3e1911999a9a2c71b0a708e73:

  sparc64: Fix build with mix of modular vs. non-modular crypto drivers. (2012-11-09 20:55:16 -0800)

----------------------------------------------------------------
Andreas Larsson (3):
      sparc: Add sparc support for platform_get_irq()
      sparc32, leon: Check for existent irq_map entry in leon_handle_ext_irq
      of/address: sparc: Declare of_address_to_resource() as an extern function for sparc again

David S. Miller (9):
      sparc64: Make montmul/montsqr/mpmul usable in 32-bit threads.
      sparc64: Fix cpu strand yielding.
      sparc64: Use pause instruction when available.
      sparc64: Improvde documentation and readability of atomic backoff code.
      sparc: Wire up sys_kcmp.
      qlogicpti: Fix build warning.
      sparc: Allow OF_GPIO on sparc.
      sparc: Support atomic64_dec_if_positive properly.
      sparc64: Fix build with mix of modular vs. non-modular crypto drivers.

 arch/sparc/Kconfig                      |  1 +
 arch/sparc/crypto/Makefile              | 16 ++++++++--------
 arch/sparc/crypto/aes_glue.c            |  2 ++
 arch/sparc/crypto/camellia_glue.c       |  2 ++
 arch/sparc/crypto/crc32c_glue.c         |  2 ++
 arch/sparc/crypto/des_glue.c            |  2 ++
 arch/sparc/crypto/md5_glue.c            |  2 ++
 arch/sparc/crypto/sha1_glue.c           |  2 ++
 arch/sparc/crypto/sha256_glue.c         |  2 ++
 arch/sparc/crypto/sha512_glue.c         |  2 ++
 arch/sparc/include/asm/atomic_64.h      |  4 +++-
 arch/sparc/include/asm/backoff.h        | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 arch/sparc/include/asm/compat.h         |  5 +++--
 arch/sparc/include/asm/processor_64.h   | 17 ++++++++++++++++-
 arch/sparc/include/asm/prom.h           |  5 +++++
 arch/sparc/include/asm/thread_info_64.h |  5 +++++
 arch/sparc/include/asm/ttable.h         | 24 ++++++++++++++++--------
 arch/sparc/include/uapi/asm/unistd.h    |  7 ++++++-
 arch/sparc/kernel/entry.h               |  7 +++++++
 arch/sparc/kernel/leon_kernel.c         |  6 ++++--
 arch/sparc/kernel/perf_event.c          | 22 ++++++++++++++++------
 arch/sparc/kernel/process_64.c          | 42 +++++++++++++++++++++++-------------------
 arch/sparc/kernel/ptrace_64.c           |  4 ++--
 arch/sparc/kernel/setup_64.c            | 21 +++++++++++++++++++++
 arch/sparc/kernel/sys_sparc_64.c        |  5 +++++
 arch/sparc/kernel/systbls_32.S          |  1 +
 arch/sparc/kernel/systbls_64.S          |  2 ++
 arch/sparc/kernel/unaligned_64.c        | 36 +++++++++++++++++++++++-------------
 arch/sparc/kernel/visemul.c             | 23 ++++++++++++++---------
 arch/sparc/kernel/vmlinux.lds.S         |  5 +++++
 arch/sparc/kernel/winfixup.S            |  2 ++
 arch/sparc/lib/atomic_64.S              | 16 +++++++++++++++-
 arch/sparc/lib/ksyms.c                  |  1 +
 arch/sparc/math-emu/math_64.c           |  2 +-
 drivers/base/platform.c                 |  7 +++++++
 drivers/gpio/Kconfig                    |  2 +-
 drivers/scsi/qlogicpti.c                | 13 +------------
 include/linux/of_address.h              |  2 ++
 38 files changed, 291 insertions(+), 97 deletions(-)
