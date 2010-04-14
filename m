Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0DNH6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 03:58:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:37802 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab0DNH6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 03:58:10 -0400
Date: Wed, 14 Apr 2010 09:58:08 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tony Vroon <tony@linx.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
Message-ID: <20100414075808.GA4202@tiehlicka.suse.cz>
References: <20100401133923.GA4104@tiehlicka.suse.cz>
 <201004130101.54117.rjw@sisk.pl>
 <20100413082756.GA5233@tiehlicka.suse.cz>
 <201004132253.37432.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004132253.37432.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13-04-10 22:53:37, Rafael J. Wysocki wrote:
> On Tuesday 13 April 2010, Michal Hocko wrote:
> > On Tue 13-04-10 01:01:54, Rafael J. Wysocki wrote:
> > > On Saturday 10 April 2010, Rafael J. Wysocki wrote:
> > > > On Friday 09 April 2010, Tony Vroon wrote:
> > > > > On Fri, 2010-04-09 at 22:42 +0200, Rafael J. Wysocki wrote:
> > > > > > Please check if the patch below changes anything.
> > > > > >  drivers/acpi/wakeup.c |    4 ++--
> > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > 
> > > > > That didn't change the behaviour for me, sorry.
> > > > 
> > > > Well, I would be sorry if it did, because the patch removed some useful code. :-)
> > > > 
> > > > > (I made sure to go through a full power down session before trying the
> > > > > patched kernel)
> > > > 
> > > > Thanks for testing.  So it looks like we don't disable the GPE during power off.
> > > > 
> > > > I'll try to figure out what's going on, please stay tuned.
> > > 
> > > Can you please check if the patch below changes the behavior?
> > 
> > Unfortunately, it didn't help either (I have tried on top of the fresh
> > rc4).
> 
> That gets really weird.
> 
> > > ---
> > >  drivers/acpi/wakeup.c |    6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > Index: linux-2.6/drivers/acpi/wakeup.c
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/acpi/wakeup.c
> > > +++ linux-2.6/drivers/acpi/wakeup.c
> > > @@ -63,17 +63,17 @@ void acpi_enable_wakeup_device(u8 sleep_
> > >  	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
> > >  		struct acpi_device *dev =
> > >  			container_of(node, struct acpi_device, wakeup_list);
> > > +		u8 action = ACPI_GPE_ENABLE;
> 
> Can you try to change the above to ACPI_GPE_DISABLE and retest, please?

Unfortunately didn't help as well...
Just for reference:

diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
index 248b473..f23c08f 100644
--- a/drivers/acpi/wakeup.c
+++ b/drivers/acpi/wakeup.c
@@ -63,7 +63,7 @@ void acpi_enable_wakeup_device(u8 sleep_state)
 	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
 		struct acpi_device *dev =
 			container_of(node, struct acpi_device, wakeup_list);
-		u8 action = ACPI_GPE_ENABLE;
+		u8 action = ACPI_GPE_DISABLE;
 
 		if (!dev->wakeup.flags.valid)
 			continue;
> 
> > >  		if (!dev->wakeup.flags.valid)
> > >  			continue;
> > >  
> > >  		if ((!dev->wakeup.state.enabled && !dev->wakeup.prepare_count)
> > >  		    || sleep_state > (u32) dev->wakeup.sleep_state)
> > > -			continue;
> > > +			action = ACPI_GPE_DISABLE;
> > >  
> > > -		/* The wake-up power should have been enabled already. */
> > >  		acpi_set_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number,
> > > -				ACPI_GPE_ENABLE);
> > > +				action);
> > >  	}
> > >  }
> 
> Rafael

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
