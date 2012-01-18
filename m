Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab2ARIAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 03:00:47 -0500
Received: from mail.de.keymile.com ([195.8.104.1]:51894 "HELO
	mail.de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753111Ab2ARIAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 03:00:47 -0500
From: Gerlando Falauto <gerlando.falauto@keymile.com>
To: linux-kernel@vger.kernel.org
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Holger Brunck <holger.brunck@keymile.com>
Subject: [PATCH 0/1] genirq: drop synchronize_irq() unless CONFIG_SMP
Date: Wed, 18 Jan 2012 08:59:56 +0100
Message-Id: <1326873597-19188-1-git-send-email-gerlando.falauto@keymile.com>
X-Mailer: git-send-email 1.7.1
X-ESAFE-STATUS: [srvhellgate.de.keymile.net] Mail clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up until 2.6.28, synchronize_irq() was only implemented
when CONFIG_SMP was defined, and this was consistent
between kernel/irq/manage.c and include/linux/hardirq.h

At some point before 2.6.29, a second condition
became necessary, CONFIG_GENERIC_HARDIRQS, and this was
still consistent in that both files showed some

 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)

Then before 2.6.30:

:commit 3aa551c9b4c40018f0e261a178e3d25478dc04a9
:Author: Thomas Gleixner <tglx@linutronix.de>
:Date:   Mon Mar 23 18:28:15 2009 +0100
:
:    genirq: add threaded interrupt handler support

changed this so that include/linux/hardirq.h declares a function when
 #if defined(CONFIG_SMP) || defined(CONFIG_GENERIC_HARDIRQS)
whereas kernel/irq/manage.c always defines one anyway.

Since synchronize_irq() only makes sense under SMP, we both declare
and define one when CONFIG_SMP=y.

CONFIG_GENERIC_HARDIRQS is a necessary condition for compiling
kernel/irq/manage.c, so if you are not using it you should implement
your own.

This fixes startup deadlocks in SMP-unaware drivers which call
disable_irq() within its own handler, and used to work
(by chance), up until 2.6.29.

Other drivers were fixed by changing disable_irq() to
disable_irq_nosync(), with references to the above patch,
like for instance:

:commit f43ab901005c2bb3c5440e91b6efae9f5db02e7c
:Author: Nelson Castillo <arhuaco@freaks-unidos.net>
:Date:   Tue May 12 13:26:47 2009 -0700
:
:    mfd: pcf50633: fix unsafe disable_irq()

:commit 950312ce22696ddfa42a957bdadaa9c24151e679
:Author: Andrew Randrianasulu <randrik_a@yahoo.com>
:Date:   Thu May 14 11:29:27 2009 -0700
:
:    MIPS: IP32: Fix hang on shutdown in power button interrupt handler.

:commit 7e9e05cad94217498e4d9bd6ef7137b4e9e7ed64
:Author: Ralf Baechle <ralf@linux-mips.org>
:Date:   Sat May 16 12:23:45 2009 +0100
:
:    MIPS: IP22: Fix hang in power button interrupt handler

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Holger Brunck <holger.brunck@keymile.com>
Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>

Gerlando Falauto (1):
  genirq: drop synchronize_irq() unless CONFIG_SMP

 include/linux/hardirq.h |    2 +-
 kernel/irq/manage.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

