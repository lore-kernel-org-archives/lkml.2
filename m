Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab0DYCes (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 22:34:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39740 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0DYCeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 22:34:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
Date: Sun, 25 Apr 2010 04:35:42 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Tony Vroon <tony@linx.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20100401133923.GA4104@tiehlicka.suse.cz> <20100419115942.GC5160@tiehlicka.suse.cz> <201004191719.53602.rjw@sisk.pl>
In-Reply-To: <201004191719.53602.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004250435.42779.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 April 2010, Rafael J. Wysocki wrote:
> On Monday 19 April 2010, Michal Hocko wrote:
> > On Fri 16-04-10 20:00:29, Rafael J. Wysocki wrote:
> > > On Wednesday 14 April 2010, Michal Hocko wrote:
> > > > On Tue 13-04-10 22:53:37, Rafael J. Wysocki wrote:
> > > > > On Tuesday 13 April 2010, Michal Hocko wrote:
> > > > > > On Tue 13-04-10 01:01:54, Rafael J. Wysocki wrote:
> > > > > > > On Saturday 10 April 2010, Rafael J. Wysocki wrote:
> > > > > > > > On Friday 09 April 2010, Tony Vroon wrote:
> > > > > > > > > On Fri, 2010-04-09 at 22:42 +0200, Rafael J. Wysocki wrote:
> > > > > > > > > > Please check if the patch below changes anything.
> > > > > > > > > >  drivers/acpi/wakeup.c |    4 ++--
> > > > > > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > > > > 
> > > > > > > > > That didn't change the behaviour for me, sorry.
> > > > > > > > 
> > > > > > > > Well, I would be sorry if it did, because the patch removed some useful code. :-)
> > > > > > > > 
> > > > > > > > > (I made sure to go through a full power down session before trying the
> > > > > > > > > patched kernel)
> > > > > > > > 
> > > > > > > > Thanks for testing.  So it looks like we don't disable the GPE during power off.
> > > > > > > > 
> > > > > > > > I'll try to figure out what's going on, please stay tuned.
> > > > > > > 
> > > > > > > Can you please check if the patch below changes the behavior?
> > > > > > 
> > > > > > Unfortunately, it didn't help either (I have tried on top of the fresh
> > > > > > rc4).
> > > > > 
> > > > > That gets really weird.
> > > > > 
> > > > > > > ---
> > > > > > >  drivers/acpi/wakeup.c |    6 +++---
> > > > > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > > > > 
> > > > > > > Index: linux-2.6/drivers/acpi/wakeup.c
> > > > > > > ===================================================================
> > > > > > > --- linux-2.6.orig/drivers/acpi/wakeup.c
> > > > > > > +++ linux-2.6/drivers/acpi/wakeup.c
> > > > > > > @@ -63,17 +63,17 @@ void acpi_enable_wakeup_device(u8 sleep_
> > > > > > >  	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
> > > > > > >  		struct acpi_device *dev =
> > > > > > >  			container_of(node, struct acpi_device, wakeup_list);
> > > > > > > +		u8 action = ACPI_GPE_ENABLE;
> > > > > 
> > > > > Can you try to change the above to ACPI_GPE_DISABLE and retest, please?
> > > > 
> > > > Unfortunately didn't help as well...
> > > > Just for reference:
> > > > 
> > > > diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
> > > > index 248b473..f23c08f 100644
> > > > --- a/drivers/acpi/wakeup.c
> > > > +++ b/drivers/acpi/wakeup.c
> > > > @@ -63,7 +63,7 @@ void acpi_enable_wakeup_device(u8 sleep_state)
> > > >  	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
> > > >  		struct acpi_device *dev =
> > > >  			container_of(node, struct acpi_device, wakeup_list);
> > > > -		u8 action = ACPI_GPE_ENABLE;
> > > > +		u8 action = ACPI_GPE_DISABLE;
> > > 
> > > That probably means the chipset enables the GPEs by itself _after_ we've
> > > disabled them in acpi_enable_wakeup_device().
> > 
> > Is this something BIOS specific?
> > 
> > > 
> > > Unfortunately, I can't reproduce the issue on any of my test boxes and it's
> > > hard to find the source of the problem staring at the code.
> > 
> > Are there any debug options I can turn on to provide some information?
> 
> We can only check what the kernel tells us before power off, but all that seems
> correct.
> 
> > Btw. what exactly does this mean? In what state is the laptop while it
> > is turned off and GPE is enabled?
> 
> If a GPE is enabled, then some part of the chipset has power provided so that
> it can signal wakeup.
> 
> I'll look into it a bit more later today.

Please try the patch below.  It kind of restores the previous behavior,
let's see if it changes anything.

Rafael

---
 drivers/acpi/acpica/evgpeblk.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/acpi/acpica/evgpeblk.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evgpeblk.c
+++ linux-2.6/drivers/acpi/acpica/evgpeblk.c
@@ -364,7 +364,7 @@ acpi_ev_match_prw_and_gpe(acpi_handle ob
 	union acpi_operand_object *pkg_desc;
 	union acpi_operand_object *obj_desc;
 	u32 gpe_number;
-	acpi_status status;
+	acpi_status status = AE_OK;
 
 	ACPI_FUNCTION_TRACE(ev_match_prw_and_gpe);
 
@@ -439,13 +439,15 @@ acpi_ev_match_prw_and_gpe(acpi_handle ob
 	if (gpe_device == target_gpe_device) {
 		gpe_event_info = acpi_ev_gpeblk_event_info(gpe_block,
 							   gpe_number);
-		if (gpe_event_info)
+		if (gpe_event_info) {
+			status = acpi_ev_disable_gpe(gpe_event_info);
 			gpe_event_info->flags |= ACPI_GPE_CAN_WAKE;
+		}
 	}
 
       cleanup:
 	acpi_ut_remove_reference(pkg_desc);
-	return_ACPI_STATUS(AE_OK);
+	return_ACPI_STATUS(status);
 }
 
 /*******************************************************************************
