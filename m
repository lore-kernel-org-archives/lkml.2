Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0DSPTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:19:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47079 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0DSPTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:19:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
Date: Mon, 19 Apr 2010 17:19:53 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Tony Vroon <tony@linx.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20100401133923.GA4104@tiehlicka.suse.cz> <201004162000.29861.rjw@sisk.pl> <20100419115942.GC5160@tiehlicka.suse.cz>
In-Reply-To: <20100419115942.GC5160@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004191719.53602.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 April 2010, Michal Hocko wrote:
> On Fri 16-04-10 20:00:29, Rafael J. Wysocki wrote:
> > On Wednesday 14 April 2010, Michal Hocko wrote:
> > > On Tue 13-04-10 22:53:37, Rafael J. Wysocki wrote:
> > > > On Tuesday 13 April 2010, Michal Hocko wrote:
> > > > > On Tue 13-04-10 01:01:54, Rafael J. Wysocki wrote:
> > > > > > On Saturday 10 April 2010, Rafael J. Wysocki wrote:
> > > > > > > On Friday 09 April 2010, Tony Vroon wrote:
> > > > > > > > On Fri, 2010-04-09 at 22:42 +0200, Rafael J. Wysocki wrote:
> > > > > > > > > Please check if the patch below changes anything.
> > > > > > > > >  drivers/acpi/wakeup.c |    4 ++--
> > > > > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > > > 
> > > > > > > > That didn't change the behaviour for me, sorry.
> > > > > > > 
> > > > > > > Well, I would be sorry if it did, because the patch removed some useful code. :-)
> > > > > > > 
> > > > > > > > (I made sure to go through a full power down session before trying the
> > > > > > > > patched kernel)
> > > > > > > 
> > > > > > > Thanks for testing.  So it looks like we don't disable the GPE during power off.
> > > > > > > 
> > > > > > > I'll try to figure out what's going on, please stay tuned.
> > > > > > 
> > > > > > Can you please check if the patch below changes the behavior?
> > > > > 
> > > > > Unfortunately, it didn't help either (I have tried on top of the fresh
> > > > > rc4).
> > > > 
> > > > That gets really weird.
> > > > 
> > > > > > ---
> > > > > >  drivers/acpi/wakeup.c |    6 +++---
> > > > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > > > 
> > > > > > Index: linux-2.6/drivers/acpi/wakeup.c
> > > > > > ===================================================================
> > > > > > --- linux-2.6.orig/drivers/acpi/wakeup.c
> > > > > > +++ linux-2.6/drivers/acpi/wakeup.c
> > > > > > @@ -63,17 +63,17 @@ void acpi_enable_wakeup_device(u8 sleep_
> > > > > >  	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
> > > > > >  		struct acpi_device *dev =
> > > > > >  			container_of(node, struct acpi_device, wakeup_list);
> > > > > > +		u8 action = ACPI_GPE_ENABLE;
> > > > 
> > > > Can you try to change the above to ACPI_GPE_DISABLE and retest, please?
> > > 
> > > Unfortunately didn't help as well...
> > > Just for reference:
> > > 
> > > diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
> > > index 248b473..f23c08f 100644
> > > --- a/drivers/acpi/wakeup.c
> > > +++ b/drivers/acpi/wakeup.c
> > > @@ -63,7 +63,7 @@ void acpi_enable_wakeup_device(u8 sleep_state)
> > >  	list_for_each_safe(node, next, &acpi_wakeup_device_list) {
> > >  		struct acpi_device *dev =
> > >  			container_of(node, struct acpi_device, wakeup_list);
> > > -		u8 action = ACPI_GPE_ENABLE;
> > > +		u8 action = ACPI_GPE_DISABLE;
> > 
> > That probably means the chipset enables the GPEs by itself _after_ we've
> > disabled them in acpi_enable_wakeup_device().
> 
> Is this something BIOS specific?
> 
> > 
> > Unfortunately, I can't reproduce the issue on any of my test boxes and it's
> > hard to find the source of the problem staring at the code.
> 
> Are there any debug options I can turn on to provide some information?

We can only check what the kernel tells us before power off, but all that seems
correct.

> Btw. what exactly does this mean? In what state is the laptop while it
> is turned off and GPE is enabled?

If a GPE is enabled, then some part of the chipset has power provided so that
it can signal wakeup.

I'll look into it a bit more later today.

Thanks,
Rafael
