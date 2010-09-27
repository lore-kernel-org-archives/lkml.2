Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab0I0Tsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:48:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60920 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab0I0Tsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TzumJcTvnsSA/0tVSZEB/93XOj3KjinbaX7Yyu+4Xqgn3libW+sxtv/Lz+Zd324qu4
         NHvu2l00vgQk4uGxEs8sSLGaNepysH+u+wtPoFMfH5ktweShNlOtGtrc7+3PjaEbcidp
         uDSreqkilZtcAnr0DwzK0HeUEEoe14xY/vo+M=
MIME-Version: 1.0
In-Reply-To: <20100908152036.643594727@linutronix.de>
References: <20100908152036.643594727@linutronix.de>
Date: Mon, 27 Sep 2010 21:48:34 +0200
Message-ID: <AANLkTin23sJT+OqjDqjyk-Gr5r-GfJ_03Q1WUqNLCzgH@mail.gmail.com>
Subject: Re: [RFC trollpatch 1/1] genirq: Remove the fits all and nothing
 __do_IRQ() code
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, linux-alpha@vger.kernel.org,
        linux-cris-kernel@axis.com, Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Greg Ungerer <gerg@uclinux.org>, Jeff Dike <jdike@addtoit.com>,
        linux-parisc@vger.kernel.org, Chris Zankel <chris@zankel.net>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 8:14 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> __do_IRQ() has been deprecated after a two years migration phase in
>  The following architectures are still using __do_IRQ():
>
>  alpha, cris, ia64, h8300, m32r, m68knommu, parisc, um
>

Maybe I'm naive but shouldn't this path work?
Does um need some extra work?

The linux executable aborts immediately when I apply my patch.

---cut---
Locating the bottom of the address space ... 0x10000
Locating the top of the address space ... 0xc0000000
Core dump limits :
        soft - 0
        hard - NONE
Checking that ptrace can change system call numbers...OK
Checking syscall emulation patch for ptrace...OK
Checking advanced syscall emulation patch for ptrace...OK
Checking for tmpfs mount on /dev/shm...nothing mounted on /dev/shm
Checking PROT_EXEC mmap in /tmp/...OK
Checking for the skas3 patch in the host:
  - /proc/mm...not found: No such file or directory
  - PTRACE_FAULTINFO...not found
  - PTRACE_LDT...not found
UML running in SKAS0 mode
Aborted
---cut---

diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index ec2b8da..ae950e0 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -147,3 +147,8 @@ config KERNEL_STACK_ORDER
          This option determines the size of UML kernel stacks.  They will
          be 1 << order pages.  The default is OK unless you're running Valgrind
          on UML, in which case, set this to 3.
+
+config GENERIC_HARDIRQS_NO__DO_IRQ
+       def_bool y
+
+
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index a3f0b04..3d44535 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -334,7 +334,7 @@ unsigned int do_IRQ(int irq, struct uml_pt_regs *regs)
 {
        struct pt_regs *old_regs = set_irq_regs((struct pt_regs *)regs);
        irq_enter();
-       __do_IRQ(irq);
+       generic_handle_irq(irq);
        irq_exit();
        set_irq_regs(old_regs);
        return 1;
