Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2JJN1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:27:31 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34016 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2JJN12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:27:28 -0400
Message-ID: <1349875217.23493.25.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: dock: Remove redundant ACPI NS walk
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        shli@fusionio.com
Date: Wed, 10 Oct 2012 07:20:17 -0600
In-Reply-To: <5074CBEB.4040500@jp.fujitsu.com>
References: <1347481849-17973-1-git-send-email-toshi.kani@hp.com>
	 <5074CBEB.4040500@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 10:14 +0900, Yasuaki Ishimatsu wrote:
> Hi Toshi,
> 
> Sorry for late reply.
> 
> 2012/09/13 5:30, Toshi Kani wrote:
> > Combined two ACPI namespace walks, which look for dock stations
> > and then bays separately, into a single walk.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> 
> I have not tested the patch. But it looks good to me.
> 
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Hi Yasuaki,

Thanks for the review!  I did test the patch with _DCK and PNP0C0A in
ACPI.

-Toshi


> 
> Thanks,
> Yasuaki Ishimatsu
> 
> >   drivers/acpi/dock.c |   26 +++++++-------------------
> >   1 files changed, 7 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> > index 88eb143..ae4ebf2 100644
> > --- a/drivers/acpi/dock.c
> > +++ b/drivers/acpi/dock.c
> > @@ -1016,44 +1016,32 @@ static int dock_remove(struct dock_station *ds)
> >   }
> >   
> >   /**
> > - * find_dock - look for a dock station
> > + * find_dock_and_bay - look for dock stations and bays
> >    * @handle: acpi handle of a device
> >    * @lvl: unused
> > - * @context: counter of dock stations found
> > + * @context: unused
> >    * @rv: unused
> >    *
> > - * This is called by acpi_walk_namespace to look for dock stations.
> > + * This is called by acpi_walk_namespace to look for dock stations and bays.
> >    */
> >   static __init acpi_status
> > -find_dock(acpi_handle handle, u32 lvl, void *context, void **rv)
> > +find_dock_and_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
> >   {
> > -	if (is_dock(handle))
> > +	if (is_dock(handle) || is_ejectable_bay(handle))
> >   		dock_add(handle);
> >   
> >   	return AE_OK;
> >   }
> >   
> > -static __init acpi_status
> > -find_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
> > -{
> > -	/* If bay is a dock, it's already handled */
> > -	if (is_ejectable_bay(handle) && !is_dock(handle))
> > -		dock_add(handle);
> > -	return AE_OK;
> > -}
> > -
> >   static int __init dock_init(void)
> >   {
> >   	if (acpi_disabled)
> >   		return 0;
> >   
> > -	/* look for a dock station */
> > +	/* look for dock stations and bays */
> >   	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> > -			    ACPI_UINT32_MAX, find_dock, NULL, NULL, NULL);
> > +		ACPI_UINT32_MAX, find_dock_and_bay, NULL, NULL, NULL);
> >   
> > -	/* look for bay */
> > -	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> > -			ACPI_UINT32_MAX, find_bay, NULL, NULL, NULL);
> >   	if (!dock_station_count) {
> >   		printk(KERN_INFO PREFIX "No dock devices found.\n");
> >   		return 0;
> > 
> 
> 


