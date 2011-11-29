Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1K2GCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:02:42 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43359 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1K2GCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:02:41 -0500
X-AuditID: b753bd60-96e5dba00000359c-c7-4ed4757ed408
X-AuditID: b753bd60-96e5dba00000359c-c7-4ed4757ed408
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 0/4] x86: check stack overflows more reliably
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 29 Nov 2011 15:08:07 +0900
Message-ID: <20111129060806.11076.74583.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series adds the following three features about stack
overflow checking. The (3) feature works if the sysctl parameter
is enabled.

(1) add user mode vm check
    The kernel stack overflow is checked in stack_overflow_check(),
    which may wrongly detect the overflow if the user stack pointer
    points to the kernel stack intentionally or accidentally.
    To avoid this misdetection, bail out early if the user stack is
    used.

(2) check stack overflow in detail
    Currently, only kernel stack is checked for the overflow,
    which is not sufficient for systems that need a high reliability.
    To enhance it, expand stack overflow checking to IRQ and
    exception stacks.

(3) panic on stack overflow
    Currently, kernel messages are output on the detection of
    stack overflow. Similarly, its's not sufficient for systems
    that need a high reliability since it may corrupt data and the
    additional corruption may occur due to reading them. To enhance
    reliability, cause a panic for the overflows according to the
    sysctl parameter. In addition, it is also useful for analyzing
    the reason why it occurred using kdump which is a crash dumping
    mechanism. This option is disabled by default in sysctl.


Changes in v2:
 - Remove DEBUG_STACKOVERFLOW_DETAIL option in Kconfig.
 - Change the default overflow checking to the detail-check instead
   of original one that only checks the kernel stack overflow.
 - Remove the changes related to binary sysctl.

Thanks,

---

Mitsuo Hayasaka (4):
      x86: cleanup the range of stack overflow checking
      x86: panic on detection of stack overflow
      x86: check stack overflow in detail
      [BUGFIX] x86: add user_mode_vm check in stack_overflow_check


 Documentation/sysctl/kernel.txt |   14 ++++++++++++++
 arch/x86/Kconfig.debug          |    7 +++++--
 arch/x86/kernel/irq_32.c        |    2 ++
 arch/x86/kernel/irq_64.c        |   36 ++++++++++++++++++++++++++++++------
 include/linux/kernel.h          |    1 +
 kernel/sysctl.c                 |    9 +++++++++
 6 files changed, 61 insertions(+), 8 deletions(-)

-- 
Mitsuo Hayasaka (mitsuo.hayasaka.hu@hitachi.com)
