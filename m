Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab2B1Nam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:30:42 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:57215 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab2B1Nak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:30:40 -0500
Date: Tue, 28 Feb 2012 05:30:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: deepthi@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH RFC] acpi: Fix unprotected smp_processor_id() in
 acpi_processor_cst_has_changed()
Message-ID: <20120228133013.GE2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120223205805.GA31838@linux.vnet.ibm.com>
 <20120228071943.GE1112@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228071943.GE1112@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022813-6148-0000-0000-000003D0964C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 03:19:43PM +0800, Yong Zhang wrote:
> On Thu, Feb 23, 2012 at 12:58:05PM -0800, Paul E. McKenney wrote:
> > The acpi_processor_cst_has_changed() function is invoked from a
> > CPU_ONLINE or CPU_DEAD function, which might well execute on CPU 0
> > even though the CPU being hotplugged is some other CPU.  In addition,
> > acpi_processor_cst_has_changed() invokes smp_processor_id() without
> > protection, resulting in splats when onlining CPUs.
> > 
> > This commit therefore changes the smp_processor_id() to pr->id, as is
> > used elsewhere in the code, for example, in acpi_processor_add().
> > 
> > This works for me, but I don't claim to understand ACPI.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Got the same warning.
> And the patch works on my side.
> 
> Tested-by: Yong Zhang <yong.zhang0@gmail.com>

Thank you, I have added your Tested-by (and Srivatsa's Reviewed-by,
for that matter).

Any takers for this, or should I just push it up the -tip tree?

							Thanx, Paul

> > diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> > index 0e8e2de..9e57b06 100644
> > --- a/drivers/acpi/processor_idle.c
> > +++ b/drivers/acpi/processor_idle.c
> > @@ -1159,8 +1159,7 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
> >  	 * to make the code that updates C-States be called once.
> >  	 */
> >  
> > -	if (smp_processor_id() == 0 &&
> > -			cpuidle_get_driver() == &acpi_idle_driver) {
> > +	if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
> >  
> >  		cpuidle_pause_and_lock();
> >  		/* Protect against cpu-hotplug */
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Only stand for myself
> 

