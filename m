Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2G0XjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:39:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50727 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2G0Xi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:38:59 -0400
Date: Sat, 28 Jul 2012 00:38:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        Barry Song <21cnbao@gmail.com>, Vaibhav Bedia <vaibhav.bedia@ti.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, Nicolas Pitre <nico@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2] ARM: sched_clock: update epoch_cyc on resume
Message-ID: <20120727233829.GB14835@n2100.arm.linux.org.uk>
References: <1343184588-20239-1-git-send-email-ccross@android.com> <CACRpkdZv4p+QT3Y+=-xh5iJ=sr1_aahroxQ535QpzVD9e_ESJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZv4p+QT3Y+=-xh5iJ=sr1_aahroxQ535QpzVD9e_ESJA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 01:32:50AM +0200, Linus Walleij wrote:
> On Wed, Jul 25, 2012 at 4:49 AM, Colin Cross <ccross@android.com> wrote:
> 
> > Many clocks that are used to provide sched_clock will reset during
> > suspend.  If read_sched_clock returns 0 after suspend, sched_clock will
> > appear to jump forward.  This patch resets cd.epoch_cyc to the current
> > value of read_sched_clock during resume, which causes sched_clock() just
> > after suspend to return the same value as sched_clock() just before
> > suspend.
> >
> > In addition, during the window where epoch_ns has been updated before
> > suspend, but epoch_cyc has not been updated after suspend, it is unknown
> > whether the clock has reset or not, and sched_clock() could return a
> > bogus value.  Add a suspended flag, and return the pre-suspend epoch_ns
> > value during this period.
> >
> > The new behavior is triggered by calling setup_sched_clock_needs_suspend
> > instead of setup_sched_clock.
> >
> > Signed-off-by: Colin Cross <ccross@android.com>
> 
> Sweet!
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Have any of you looked at the patch I originally posted for doing this?
It needs updating but shows the overall principle - which is to ensure
that the epoch is up to date before suspending.

It doesn't deal with resume, because different timers behave differently,
and there's no real way to deal with that properly.  The important thing
that this patch does is to ensure sched_clock() doesn't ever go backwards.

 arch/arm/kernel/sched_clock.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index 9a46370..4be4019 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -10,6 +10,7 @@
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/syscore_ops.h>
 #include <linux/timer.h>
 
 #include <asm/sched_clock.h>
@@ -72,3 +73,20 @@ void __init sched_clock_postinit(void)
 {
 	sched_clock_poll(sched_clock_timer.data);
 }
+
+static int sched_clock_suspend(void)
+{
+	sched_clock_poll(sched_clock_timer.data);
+	return 0;
+}
+
+static struct syscore_ops sched_clock_ops = {
+	.suspend	= sched_clock_suspend,
+};
+
+static int __init sched_clock_syscore_init(void)
+{
+	register_syscore_ops(&sched_clock_ops);
+	return 0;
+}
+device_initcall(sched_clock_syscore_init);

