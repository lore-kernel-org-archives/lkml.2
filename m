Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab0EABpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 21:45:18 -0400
Received: from [12.175.186.2] ([12.175.186.2]:41717 "EHLO
	vbn.0055647.lodgenet.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932629Ab0EABof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 21:44:35 -0400
X-Greylist: delayed 1493 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Apr 2010 21:44:33 EDT
Date: Wed, 28 Apr 2010 20:22:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@sony
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] acpi: Fall back to manually changing SCI_EN
In-Reply-To: <201004282058.20910.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1004282019240.2598@sony>
References: <1271711614-15527-1-git-send-email-mjg@redhat.com> <201004282058.20910.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 Apr 2010, Rafael J. Wysocki wrote:

> On Monday 19 April 2010, Matthew Garrett wrote:
> > The ACPI spec tells us that the ACPI SCI_EN bit is under hardware control
> > and shouldn't be touched by the OS. It seems that the Leading Other OS
> > ignores this and some machines expect this behaviour. We have a blacklist
> > for these, but given that we're able to detect the failure case and the
> > alternative to breaking the spec is letting the machine crash and burn,
> > let's try falling back when we know the alternative is a mostly-dead
> > machine.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> I guess we can try that, but I'd prefer it if that went into .35.
> 
> It _should_ be safe, but ...
> 
> Anyway, Acked-by: Rafael J. Wysocki <rjw@sisk.pl>


I'd like to push this patch in .34,
and in .35 remove the DMI list and the boot option.

One thing that has bothered me about the boot option
is that it writes SCI_EN instead of callin acpi_enable()
as opposed to in-addition-to acpi_enable().
If all acpi_enable() did was set SCI_EN, then it would
not make a difference.  However, acpi_enable() writes
SMI_CMD and we really have no idea what other stuff
the BIOS may do in SMM on this transition.

So if we don't end up reverting this one,
I'd really like to see the boot option gone in .35.

thanks,
Len Brown, Intel Open Source Technology Center
-
> > ---
> >  drivers/acpi/sleep.c |   16 +++++++++++++---
> >  1 files changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> > index f74834a..79df8d4 100644
> > --- a/drivers/acpi/sleep.c
> > +++ b/drivers/acpi/sleep.c
> > @@ -227,6 +227,7 @@ static int acpi_suspend_begin(suspend_state_t pm_state)
> >  static int acpi_suspend_enter(suspend_state_t pm_state)
> >  {
> >  	acpi_status status = AE_OK;
> > +	acpi_status enable_status = AE_OK;
> >  	unsigned long flags = 0;
> >  	u32 acpi_state = acpi_target_sleep_state;
> >  
> > @@ -254,10 +255,19 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
> >  	}
> >  
> >  	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
> > -	if (set_sci_en_on_resume)
> > +	if (!set_sci_en_on_resume)
> > +		enable_status = acpi_enable();
> > +
> > +	if (set_sci_en_on_resume || enable_status == AE_NO_HARDWARE_RESPONSE)
> > +		/* If we're still in legacy mode then we have a problem. The
> > +		 * spec tells us that this bit is under hardware control, but
> > +		 * there's no plausible way that the OS can transition back to
> > +		 * legacy mode so our choices here are to either ignore the
> > +		 * spec or crash and burn horribly. The latter doesn't seem
> > +		 * like it's ever going to be the preferable choice, so let's
> > +		 * live dangerously.
> > +		 */
> >  		acpi_write_bit_register(ACPI_BITREG_SCI_ENABLE, 1);
> > -	else
> > -		acpi_enable();
> >  
> >  	/* Reprogram control registers and execute _BFS */
> >  	acpi_leave_sleep_state_prep(acpi_state);
> --

