Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1EXJgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:36:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63564 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1EXJf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HphCAIoL+ErrG3GNNwPSaf19mVPe6fEiUqa1gm3EmQBYVeYJSyE+ixVMsP8yyDBOW8
         G6NJ6S+ES0PFH1NQniCp9L8jqlcyhqdUKmv8KbbR3RLd4Pw/AvpekvOoVCm/4rn3FEPT
         h6fU4r36aQDc+iZuz7ehvpYWTnd2SnAvT69EI=
Date: Tue, 24 May 2011 11:35:53 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [GIT PULL] percpu changes for v2.6.40
Message-ID: <20110524093553.GA10334@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-2.6.40

The only interesting one is Eric's extra NOP removal from
percpu_cmpxchg16b_double().  Other commits shouldn't cause noticeable
behavior difference.  The extra merge commit is to pull in
non-critical fix patches which were waiting for further fixes during
2.6.39 cycle (only the merge commit itself is new).

When pulled into the current mainline, the following conflict occurs.

  #ifdef CONFIG_SMP
  #define CMPXCHG16B_EMU_CALL "call this_cpu_cmpxchg16b_emu\n\t" P6_NOP3
  #else
  #define CMPXCHG16B_EMU_CALL "call this_cpu_cmpxchg16b_emu\n\t" P6_NOP2
  #endif
  #define percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)			\
  ({									\
	  char __ret;							\
	  typeof(o1) __o1 = o1;						\
	  typeof(o1) __n1 = n1;						\
	  typeof(o2) __o2 = o2;						\
	  typeof(o2) __n2 = n2;						\
	  typeof(o2) __dummy;						\
  <<<<<<< HEAD
	  alternative_io("call this_cpu_cmpxchg16b_emu\n\t" ASM_NOP4,	\
  =======
	  alternative_io(CMPXCHG16B_EMU_CALL,				\
  >>>>>>> 6988f20fe04e9ef3aea488cb8ab57fbeb78e12f0
			 "cmpxchg16b " __percpu_prefix "(%%rsi)\n\tsetz %0\n\t",	\
			 X86_FEATURE_CX16,				\
			 ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),		\
			 "S" (&pcp1), "b"(__n1), "c"(__n2),		\
			 "a"(__o1), "d"(__o2) : "memory");		\
	  __ret;								\
  })

This is caused between b1e7734f02 (x86, percpu: Use ASM_NOP4 instead
of hardcoding P6_NOP4) and 5f55924dea (percpu: Avoid extra NOP in
percpu_cmpxchg16b_double).  The former updates P6_NOP4 used in
percpu_cmpxchg16b_double() to ASM_NOP4 while the latter makes the
whole thing into CMPXCHG16B_EMU_CALL macro which changes depending on
CONFIG_SMP.
    
Updating CMPXCHG16B_EMU_CALL macro to use ASM_NOP* and using it
resolves the conflict, which looks like the following.

  #ifdef CONFIG_SMP
  #define CMPXCHG16B_EMU_CALL "call this_cpu_cmpxchg16b_emu\n\t" ASM_NOP3
  #else
  #define CMPXCHG16B_EMU_CALL "call this_cpu_cmpxchg16b_emu\n\t" ASM_NOP2
  #endif
  #define percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)			\
  ({									\
	  char __ret;							\
	  typeof(o1) __o1 = o1;						\
	  typeof(o1) __n1 = n1;						\
	  typeof(o2) __o2 = o2;						\
	  typeof(o2) __n2 = n2;						\
	  typeof(o2) __dummy;						\
	  alternative_io(CMPXCHG16B_EMU_CALL,				\
			 "cmpxchg16b " __percpu_prefix "(%%rsi)\n\tsetz %0\n\t",	\
			 X86_FEATURE_CX16,				\
			 ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),		\
			 "S" (&pcp1), "b"(__n1), "c"(__n2),		\
			 "a"(__o1), "d"(__o2) : "memory");		\
	  __ret;								\
  })

Just in case, the merged tree is available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git merged-2.6.40

Thanks.

Eric Dumazet (1):
      percpu: Avoid extra NOP in percpu_cmpxchg16b_double

Mike Frysinger (2):
      percpu: Cast away printk format warning
      percpu: Unify input section names

Tejun Heo (2):
      percpu: Always align percpu output section to PAGE_SIZE
      Merge branch 'fixes-2.6.39' into for-2.6.40

 arch/alpha/kernel/vmlinux.lds.S    |    2 +-
 arch/arm/kernel/vmlinux.lds.S      |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S |    2 +-
 arch/cris/kernel/vmlinux.lds.S     |    2 +-
 arch/frv/kernel/vmlinux.lds.S      |    2 +-
 arch/m32r/kernel/vmlinux.lds.S     |    2 +-
 arch/mips/kernel/vmlinux.lds.S     |    2 +-
 arch/mn10300/kernel/vmlinux.lds.S  |    2 +-
 arch/parisc/kernel/vmlinux.lds.S   |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S  |    2 +-
 arch/s390/kernel/vmlinux.lds.S     |    2 +-
 arch/sh/kernel/vmlinux.lds.S       |    2 +-
 arch/sparc/kernel/vmlinux.lds.S    |    2 +-
 arch/tile/kernel/vmlinux.lds.S     |    2 +-
 arch/um/include/asm/common.lds.S   |    2 +-
 arch/x86/include/asm/percpu.h      |    7 +++-
 arch/x86/kernel/vmlinux.lds.S      |    2 +-
 arch/xtensa/kernel/vmlinux.lds.S   |    2 +-
 include/asm-generic/vmlinux.lds.h  |   61 +++++++++++++++++++-----------------
 kernel/workqueue.c                 |    4 +--
 mm/percpu.c                        |    6 ++-
 21 files changed, 60 insertions(+), 52 deletions(-)

--
tejun
