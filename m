Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0DZPFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 11:05:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab0DZPFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 11:05:06 -0400
Date: Mon, 26 Apr 2010 17:05:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tony Vroon <tony@linx.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
Message-ID: <20100426150503.GA4005@tiehlicka.suse.cz>
References: <20100401133923.GA4104@tiehlicka.suse.cz>
 <20100419115942.GC5160@tiehlicka.suse.cz>
 <201004191719.53602.rjw@sisk.pl>
 <201004250435.42779.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004250435.42779.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 25-04-10 04:35:42, Rafael J. Wysocki wrote:
> On Monday 19 April 2010, Rafael J. Wysocki wrote:
> > On Monday 19 April 2010, Michal Hocko wrote:
> > > On Fri 16-04-10 20:00:29, Rafael J. Wysocki wrote:
> > > > On Wednesday 14 April 2010, Michal Hocko wrote:
> > > > > On Tue 13-04-10 22:53:37, Rafael J. Wysocki wrote:
> > > > > > On Tuesday 13 April 2010, Michal Hocko wrote:
> > > > > > > On Tue 13-04-10 01:01:54, Rafael J. Wysocki wrote:
> > > > > > > > On Saturday 10 April 2010, Rafael J. Wysocki wrote:
> > > > > > > > > On Friday 09 April 2010, Tony Vroon wrote:
> > > > > > > > > > On Fri, 2010-04-09 at 22:42 +0200, Rafael J. Wysocki wrote:
> > > > > > > > > > > Please check if the patch below changes anything.
> > > > > > > > > > >  drivers/acpi/wakeup.c |    4 ++--
> > > > > > > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > > > > > 
> > > > > > > > > > That didn't change the behaviour for me, sorry.
> > > > > > > > > 
> > > > > > > > > Well, I would be sorry if it did, because the patch removed some useful code. :-)
> > > > > > > > > 
> > > > > > > > > > (I made sure to go through a full power down session before trying the
> > > > > > > > > > patched kernel)
> > > > > > > > > 
> > > > > > > > > Thanks for testing.  So it looks like we don't disable the GPE during power off.
> > > > > > > > > 
> > > > > > > > > I'll try to figure out what's going on, please stay tuned.
> > > > > > > > 
> > > > > > > > Can you please check if the patch below changes the behavior?
> > > > > > > 
> > > > > > > Unfortunately, it didn't help either (I have tried on top of the fresh
> > > > > > > rc4).
> > > > > > 
> > > > > > That gets really weird.
> > > > > > 
> > > > > > > > ---
> > > > > > > >  drivers/acpi/wakeup.c |    6 +++---
> > > > > > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > > > > > 
> > > > > > > > Index: linux-2.6/drivers/acpi/wakeup.c
> > > > > > > > ===================================================================
> > > > > > > > --- linux-2.6.orig/drivers/acpi/wakeup.c
> > > > > > > > +++ linux-2.6/drivers/acpi/wakeup.c
> > > > > > > > @@ -63,17 +63,17 @@ void acpi_enable_wakeup_device(u8 sleep_
> > > > > > > >  	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
> > > > > > > >  		struct acpi_device *dev =
> > > > > > > >  			container_of(node, struct acpi_device, wakeup_list);
> > > > > > > > +		u8 action = ACPI_GPE_ENABLE;
> > > > > > 
> > > > > > Can you try to change the above to ACPI_GPE_DISABLE and retest, please?
> > > > > 
> > > > > Unfortunately didn't help as well...
> > > > > Just for reference:
> > > > > 
> > > > > diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
> > > > > index 248b473..f23c08f 100644
> > > > > --- a/drivers/acpi/wakeup.c
> > > > > +++ b/drivers/acpi/wakeup.c
> > > > > @@ -63,7 +63,7 @@ void acpi_enable_wakeup_device(u8 sleep_state)
> > > > >  	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
> > > > >  		struct acpi_device *dev =
> > > > >  			container_of(node, struct acpi_device, wakeup_list);
> > > > > -		u8 action = ACPI_GPE_ENABLE;
> > > > > +		u8 action = ACPI_GPE_DISABLE;
> > > > 
> > > > That probably means the chipset enables the GPEs by itself _after_ we've
> > > > disabled them in acpi_enable_wakeup_device().
> > > 
> > > Is this something BIOS specific?
> > > 
> > > > 
> > > > Unfortunately, I can't reproduce the issue on any of my test boxes and it's
> > > > hard to find the source of the problem staring at the code.
> > > 
> > > Are there any debug options I can turn on to provide some information?
> > 
> > We can only check what the kernel tells us before power off, but all that seems
> > correct.
> > 
> > > Btw. what exactly does this mean? In what state is the laptop while it
> > > is turned off and GPE is enabled?
> > 
> > If a GPE is enabled, then some part of the chipset has power provided so that
> > it can signal wakeup.
> > 
> > I'll look into it a bit more later today.
> 
> Please try the patch below.  It kind of restores the previous behavior,
> let's see if it changes anything.

Again, no success. Just to make sure that I didn't screw anything. I
have used just the following patch on top of the clean rc5 (your patch
has failed with some rejects but I guess that the following should do
the same):

commit 65eafe4a504e3bb2c13b4feb8590dc52e7439baa
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sun Apr 25 04:35:42 2010 +0200

diff --git a/drivers/acpi/acpica/evgpeblk.c b/drivers/acpi/acpica/evgpeblk.c
index fef7219..b6e1e0c 100644
--- a/drivers/acpi/acpica/evgpeblk.c
+++ b/drivers/acpi/acpica/evgpeblk.c
@@ -367,7 +367,7 @@ acpi_ev_match_prw_and_gpe(acpi_handle obj_handle,
 	union acpi_operand_object *pkg_desc;
 	union acpi_operand_object *obj_desc;
 	u32 gpe_number;
-	acpi_status status;
+	acpi_status status = AE_OK;
 
 	ACPI_FUNCTION_TRACE(ev_match_prw_and_gpe);
 
@@ -447,12 +447,13 @@ acpi_ev_match_prw_and_gpe(acpi_handle obj_handle,
 							gpe_block->
 							block_base_number];
 
+		status = acpi_ev_disable_gpe(gpe_event_info);
 		gpe_event_info->flags |= ACPI_GPE_CAN_WAKE;
 	}
 
       cleanup:
 	acpi_ut_remove_reference(pkg_desc);
-	return_ACPI_STATUS(AE_OK);
+	return_ACPI_STATUS(status);
 }
 
 /*******************************************************************************

> 
> Rafael
> 
> ---
>  drivers/acpi/acpica/evgpeblk.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/acpica/evgpeblk.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/acpica/evgpeblk.c
> +++ linux-2.6/drivers/acpi/acpica/evgpeblk.c
> @@ -364,7 +364,7 @@ acpi_ev_match_prw_and_gpe(acpi_handle ob
>  	union acpi_operand_object *pkg_desc;
>  	union acpi_operand_object *obj_desc;
>  	u32 gpe_number;
> -	acpi_status status;
> +	acpi_status status = AE_OK;
>  
>  	ACPI_FUNCTION_TRACE(ev_match_prw_and_gpe);
>  
> @@ -439,13 +439,15 @@ acpi_ev_match_prw_and_gpe(acpi_handle ob
>  	if (gpe_device == target_gpe_device) {
>  		gpe_event_info = acpi_ev_gpeblk_event_info(gpe_block,
>  							   gpe_number);
> -		if (gpe_event_info)
> +		if (gpe_event_info) {
> +			status = acpi_ev_disable_gpe(gpe_event_info);
>  			gpe_event_info->flags |= ACPI_GPE_CAN_WAKE;
> +		}
>  	}
>  
>        cleanup:
>  	acpi_ut_remove_reference(pkg_desc);
> -	return_ACPI_STATUS(AE_OK);
> +	return_ACPI_STATUS(status);
>  }
>  
>  /*******************************************************************************
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
