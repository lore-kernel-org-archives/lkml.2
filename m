Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab1CAUE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:04:56 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59677 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab1CAUEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:04:55 -0500
Date: Tue, 1 Mar 2011 14:04:46 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: Performance/resume issues on Toshiba NB305
Message-ID: <20110301200446.GA2235@thinkpad-t410>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Len Brown <lenb@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Venkatesh Pallipadi <venki@google.com>
References: <20110225164239.GA24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6>
 <20110225212142.GC24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 10:47:16PM +0100, Thomas Gleixner wrote:
> On Fri, 25 Feb 2011, Seth Forshee wrote:
> > On Fri, Feb 25, 2011 at 09:37:39PM +0100, Thomas Gleixner wrote:
> > > On Fri, 25 Feb 2011, Seth Forshee wrote:
> > > That seems to be related to low power states. When the machine goes
> > > idle we switch into lower power states and that requires to use the
> > > hpet instead of the local apic timer as that one stops.
> > > 
> > > You could verify that theory by booting with processor.max_cstate=1
> > 
> > This fixes the performance in combination with intel_idle.max_cstate=0.
> > Alternately, intel_idle.max_cstate=1 works. But the resume still hangs.
> 
> That was expected :)
> 
> > Is the answer to quirk the machine to avoid deep C-states, or is there
> > some better way I can fix this?
> 
> Let's wait for the intel and acpi folks. It would be interesting what
> the new intel toy says to your BIOS.

Since the discussion on this issue died without really getting anywhere,
I went ahead and threw together the patch below to disable anything
deeper than C1 for this machine. I hope a better solution can be found,
but if not would something like this be an acceptable workaround?

As for the hangs during resume, unless someone has a better suggestion I
guess I'll start looking into forcing the HPET to remain in periodic
mode throughout suspend.

Thanks,
Seth

---

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 1fa091e..7d88540 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -61,6 +61,7 @@
 #include <linux/sched.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
+#include <linux/dmi.h>
 #include <asm/mwait.h>
 
 #define INTEL_IDLE_VERSION "0.4"
@@ -441,6 +442,32 @@ static int intel_idle_cpuidle_devices_init(void)
 }
 
 
+/*
+ * dmi_disable_cstates()
+ * Disable states beyond C1 for broken machines
+ */
+static int __init dmi_disable_cstates(const struct dmi_system_id *d)
+{
+	if (max_cstate == MWAIT_MAX_NUM_CSTATES - 1) {
+		pr_notice(PREFIX "%s detected, disabling C-states past C1\n",
+			  d->ident);
+		max_cstate = 1;
+	}
+}
+
+/* List of systems with known idle problems */
+static struct dmi_system_id __initdata bad_cstate_dmi_table[] = {
+	{
+		.callback	= dmi_disable_cstates,
+		.ident		= "Toshiba NB305",
+		.matches	= {
+			DMI_MATCH(DMI_BOARD_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_BOARD_NAME, "NPVAA"),
+		},
+	},
+	{}
+};
+
 static int __init intel_idle_init(void)
 {
 	int retval;
@@ -449,6 +476,9 @@ static int __init intel_idle_init(void)
 	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
 		return -ENODEV;
 
+	/* Check for known-bad hardware */
+	dmi_check_system(bad_cstate_dmi_table);
+
 	retval = intel_idle_probe();
 	if (retval)
 		return retval;
-- 
1.7.4.1

