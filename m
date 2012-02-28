Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965785Ab2B1V2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:28:15 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:48921 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2B1V2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:28:13 -0500
Date: Tue, 28 Feb 2012 13:27:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lenb@kernel.org, Yong Zhang <yong.zhang0@gmail.com>,
        deepthi@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH RFC] acpi: Fix unprotected smp_processor_id() in
 acpi_processor_cst_has_changed()
Message-ID: <20120228212744.GL2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120223205805.GA31838@linux.vnet.ibm.com>
 <20120228071943.GE1112@zhy>
 <20120228133013.GE2465@linux.vnet.ibm.com>
 <201202282157.53804.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202282157.53804.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022821-7408-0000-0000-0000030D5690
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 09:57:53PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, February 28, 2012, Paul E. McKenney wrote:
> > On Tue, Feb 28, 2012 at 03:19:43PM +0800, Yong Zhang wrote:
> > > On Thu, Feb 23, 2012 at 12:58:05PM -0800, Paul E. McKenney wrote:
> > > > The acpi_processor_cst_has_changed() function is invoked from a
> > > > CPU_ONLINE or CPU_DEAD function, which might well execute on CPU 0
> > > > even though the CPU being hotplugged is some other CPU.  In addition,
> > > > acpi_processor_cst_has_changed() invokes smp_processor_id() without
> > > > protection, resulting in splats when onlining CPUs.
> > > > 
> > > > This commit therefore changes the smp_processor_id() to pr->id, as is
> > > > used elsewhere in the code, for example, in acpi_processor_add().
> > > > 
> > > > This works for me, but I don't claim to understand ACPI.
> > > > 
> > > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > 
> > > Got the same warning.
> > > And the patch works on my side.
> > > 
> > > Tested-by: Yong Zhang <yong.zhang0@gmail.com>
> > 
> > Thank you, I have added your Tested-by (and Srivatsa's Reviewed-by,
> > for that matter).
> > 
> > Any takers for this, or should I just push it up the -tip tree?
> 
> I think this patch is for Len, either through ACPI, or through the idle tree.
> Len?

Whichever way it is supposed to go, it reminds me of the need for it every
time I forget to merge it in before testing.  ;-)

> Anyway:
> 
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Thank you, applied!  The patch appears below with the recent review,
testing, and ack.

							Thanx, Paul

------------------------------------------------------------------------

acpi: Fix unprotected smp_processor_id() in acpi_processor_cst_has_changed()

The acpi_processor_cst_has_changed() function is invoked from a
CPU_ONLINE or CPU_DEAD function, which might well execute on CPU 0
even though the CPU being hotplugged is some other CPU.  In addition,
acpi_processor_cst_has_changed() invokes smp_processor_id() without
protection, resulting in splats when onlining CPUs.

This commit therefore changes the smp_processor_id() to pr->id, as is
used elsewhere in the code, for example, in acpi_processor_add().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Tested-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0e8e2de..9e57b06 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1159,8 +1159,7 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 	 * to make the code that updates C-States be called once.
 	 */
 
-	if (smp_processor_id() == 0 &&
-			cpuidle_get_driver() == &acpi_idle_driver) {
+	if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
 
 		cpuidle_pause_and_lock();
 		/* Protect against cpu-hotplug */

