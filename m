Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0DUWhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:37:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab0DUWhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:37:35 -0400
Date: Wed, 21 Apr 2010 15:28:52 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, astarikovskiy@suse.de, ben@decadent.org.uk,
       len.brown@intel.com, stable@kernel.org, stable-commits@vger.kernel.org
Subject: Re: patch acpi-ec-allow-multibyte-access-to-ec.patch added to
 2.6.33-stable tree
Message-ID: <20100421222852.GB26266@suse.de>
References: <1271877703610@kroah.org>
 <4BCF7092.2050501@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCF7092.2050501@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 02:39:30PM -0700, Stefan Bader wrote:
> gregkh@suse.de wrote:
> > This is a note to let you know that we have just queued up the patch titled
> > 
> >     Subject: ACPI: EC: Allow multibyte access to EC
> > 
> > to the 2.6.33-stable tree.  Its filename is
> > 
> >     acpi-ec-allow-multibyte-access-to-ec.patch
> > 
> > A git repo of this tree can be found at 
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > 
> > From ben@decadent.org.uk  Wed Apr 21 12:11:57 2010
> > From: Alexey Starikovskiy <astarikovskiy@suse.de>
> > Date: Sat, 10 Apr 2010 02:18:35 +0100
> > Subject: ACPI: EC: Allow multibyte access to EC
> > To: stable@kernel.org
> > Cc: Len Brown <len.brown@intel.com>, 563313@bugs.debian.org, Alexey Starikovskiy <astarikovskiy@suse.de>
> > Message-ID: <1270862315.2176.69.camel@localhost>
> > 
> > 
> > From: Alexey Starikovskiy <astarikovskiy@suse.de>
> > 
> > commit dadf28a10c3eb29421837a2e413ab869ebd upstream
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=14667
> > 
> > [bwh: Backport to 2.6.32; same applies to 2.6.33]
> > 
> > Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
> > Signed-off-by: Len Brown <len.brown@intel.com>
> > Cc: Ben Hutchings <ben@decadent.org.uk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/acpi/acpica/exprep.c |   12 ++++++++++++
> >  drivers/acpi/ec.c            |   35 +++++++++--------------------------
> >  2 files changed, 21 insertions(+), 26 deletions(-)
> > 
> > --- a/drivers/acpi/acpica/exprep.c
> > +++ b/drivers/acpi/acpica/exprep.c
> > @@ -468,6 +468,18 @@ acpi_status acpi_ex_prep_field_value(str
> >  
> >  		acpi_ut_add_reference(obj_desc->field.region_obj);
> >  
> > +		/* allow full data read from EC address space */
> > +		if (obj_desc->field.region_obj->region.space_id ==
> > +			ACPI_ADR_SPACE_EC) {
> > +			if (obj_desc->common_field.bit_length > 8)
> > +				obj_desc->common_field.access_bit_width =
> > +				ACPI_ROUND_UP(obj_desc->common_field.
> > +							bit_length, 8);
> > +				obj_desc->common_field.access_byte_width =
> > +				ACPI_DIV_8(obj_desc->common_field.
> > +							access_bit_width);
> > +		}
> > +
> >  		ACPI_DEBUG_PRINT((ACPI_DB_BFIELD,
> >  				  "RegionField: BitOff %X, Off %X, Gran %X, Region %p\n",
> >  				  obj_desc->field.start_field_bit_offset,
> > --- a/drivers/acpi/ec.c
> > +++ b/drivers/acpi/ec.c
> > @@ -589,12 +589,12 @@ static u32 acpi_ec_gpe_handler(void *dat
> >  
> >  static acpi_status
> >  acpi_ec_space_handler(u32 function, acpi_physical_address address,
> > -		      u32 bits, acpi_integer *value,
> > +		      u32 bits, acpi_integer *value64,
> >  		      void *handler_context, void *region_context)
> >  {
> >  	struct acpi_ec *ec = handler_context;
> > -	int result = 0, i;
> > -	u8 temp = 0;
> > +	int result = 0, i, bytes = bits / 8;
> > +	u8 *value = (u8 *)value64;
> >  
> >  	if ((address > 0xFF) || !value || !handler_context)
> >  		return AE_BAD_PARAMETER;
> > @@ -602,32 +602,15 @@ acpi_ec_space_handler(u32 function, acpi
> >  	if (function != ACPI_READ && function != ACPI_WRITE)
> >  		return AE_BAD_PARAMETER;
> >  
> > -	if (bits != 8 && acpi_strict)
> > -		return AE_BAD_PARAMETER;
> > -
> > -	if (EC_FLAGS_MSI)
> > +	if (EC_FLAGS_MSI || bits > 8)
> >  		acpi_ec_burst_enable(ec);
> >  
> > -	if (function == ACPI_READ) {
> > -		result = acpi_ec_read(ec, address, &temp);
> > -		*value = temp;
> > -	} else {
> > -		temp = 0xff & (*value);
> > -		result = acpi_ec_write(ec, address, temp);
> > -	}
> > -
> > -	for (i = 8; unlikely(bits - i > 0); i += 8) {
> > -		++address;
> > -		if (function == ACPI_READ) {
> > -			result = acpi_ec_read(ec, address, &temp);
> > -			(*value) |= ((acpi_integer)temp) << i;
> > -		} else {
> > -			temp = 0xff & ((*value) >> i);
> > -			result = acpi_ec_write(ec, address, temp);
> > -		}
> > -	}
> > +	for (i = 0; i < bytes; ++i, ++address, ++value)
> > +		result = (function == ACPI_READ) ?
> > +			acpi_ec_read(ec, address, value) :
> > +			acpi_ec_write(ec, address, *value);
> >  
> > -	if (EC_FLAGS_MSI)
> > +	if (EC_FLAGS_MSI || bits > 8)
> >  		acpi_ec_burst_disable(ec);
> >  
> >  	switch (result) {
> > 
> > 
> > Patches currently in stable-queue which might be from astarikovskiy@suse.de are
> > 
> > queue-2.6.33/acpi-ec-allow-multibyte-access-to-ec.patch
> > --
> > To unsubscribe from this list: send the line "unsubscribe stable-commits" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Hi Greg,
> 
> make sure to also pick the following one as it fixes a regression caused by the
> mulitbyte access patch.
> 
> commit 2060c44576c79086ff24718878d7edaa7384a985
> Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> Date:   Fri Apr 16 15:36:40 2010 -0400
> 
>     ACPI: EC: Limit burst to 64 bits

Thanks, I didn't see that one.

I've now queued it up.

greg k-h
