Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab2G3RsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:48:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60672 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2G3RsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:48:21 -0400
Date: Mon, 30 Jul 2012 10:42:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Feng Tang <feng.tang@intel.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mail List <linux-kernel@vger.kernel.org>
Subject: Re: [Regression 3.4] tick_broadcast_mask is not restored after a CPU
 has been offline/onlined
Message-ID: <20120730174218.GA30772@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120730151559.772d4055@feng-i7>
 <20120730133913.GK2556@linux.vnet.ibm.com>
 <20120730230747.7637112a@feng-i7>
 <20120730170847.GE2391@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730170847.GE2391@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073017-7282-0000-0000-00000B7CD057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 10:08:47AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 30, 2012 at 11:07:47PM +0800, Feng Tang wrote:
> > Hi Paul,
> > 
> > On Mon, 30 Jul 2012 06:39:13 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > On Mon, Jul 30, 2012 at 03:15:59PM +0800, Feng Tang wrote:
> > > > Hi All,
> > > > 
> > > > When I debugged a suspend/resume bug, I found that tick_broadcast_mask is
> > > > not restored for a CPU after it is offline/onlined since kernel 3.4, while
> > > > it's fine for 3.3.
> > > 
> > > Could you please try 3.5?
> > 
> > Yes, it's the same for 3.5
> 
> Thank you for checking, Feng.
> 
> Len, the comment above the change says:
> 
> 	/*
> 	 * FIXME:  Design the ACPI notification to make it once per
> 	 * system instead of once per-cpu.  This condition is a hack
> 	 * to make the code that updates C-States be called once.
> 	 */
> 
> Is it time for this design-level change?  Or is there something obvious
> that I missed when fixing the smp_processor_id() splat?
> 
> I could revert back, but use raw_smp_processor_id() rather than
> smp_processor_id(), but that feels like papering over a problem rather
> than fixing it.

But should papering be appropriate, here is the patch.

							Thanx, Paul

------------------------------------------------------------------------

ACPI: Repair fix to unprotected smp_processor_id()

Commit 9505626d (ACPI: Fix unprotected smp_processor_id() in
acpi_processor_cst_has_changed()) introduced a suspend/resume bug.
This commit therefore introduces a bug-for-bug compatible fix for the
original problem.

Reported-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 47a8caa..19c151a 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1218,7 +1218,8 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 	 * to make the code that updates C-States be called once.
 	 */
 
-	if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
+	if (raw_smp_processor_id() == 0 &&
+	    cpuidle_get_driver() == &acpi_idle_driver) {
 
 		cpuidle_pause_and_lock();
 		/* Protect against cpu-hotplug */

