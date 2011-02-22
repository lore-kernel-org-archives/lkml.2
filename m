Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab1BVANQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 19:13:16 -0500
Received: from smtp-out.google.com ([74.125.121.67]:45836 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab1BVANO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=dXGJOoWBD4Sv3NIuC04CAyVyFsUKve53GiZqsN0IMtQvUJjvJtS0IYU6Ox1Vzr2YHF
         REz3moGGronhioTwJCjA==
Date: Mon, 21 Feb 2011 16:13:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ACPI: Minimize X2APIC initial messages
In-Reply-To: <4D62CE23.1030102@sgi.com>
Message-ID: <alpine.DEB.2.00.1102211555000.23557@chino.kir.corp.google.com>
References: <20110219024705.308511527@gulag1.americas.sgi.com> <20110219024705.559950799@gulag1.americas.sgi.com> <alpine.DEB.2.00.1102191637290.27722@chino.kir.corp.google.com> <4D62CE23.1030102@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Mike Travis wrote:

> > > Minimize X2APIC messages by printing 8 per line and dropping
> > > the "enabled" flag since that's assumed.  It will still print
> > > "disabled" if necessary.
> > > 
> > > v2: updated to apply to x86-tip
> > > 
> > 
> > For each patch in this series, it would be tremendously helpful to show what
> > format the current output is in and what the format is after the patch is
> > applied.
> 
> Will do.  I actually did think about this, as seeing a huge amount
> of console output is a relatively rare occurrence... ;-)
> 
> > 
> > > Signed-off-by: Mike Travis <travis@sgi.com>
> > > Reviewed-by: Jack Steiner <steiner@sgi.com>
> > > Reviewed-by: Robin Holt <holt@sgi.com>
> > > ---
> > >  arch/x86/kernel/acpi/boot.c |    3 +++
> > >  drivers/acpi/tables.c       |   16 +++++++++++-----
> > >  2 files changed, 14 insertions(+), 5 deletions(-)
> > > 
> > > --- linux.orig/arch/x86/kernel/acpi/boot.c
> > > +++ linux/arch/x86/kernel/acpi/boot.c
> > > @@ -903,6 +903,9 @@ static int __init acpi_parse_madt_lapic_
> > >  	if (!count) {
> > >  		x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC,
> > >  					acpi_parse_x2apic, MAX_LOCAL_APIC);
> > > +		/* insure trailing newline is output */
> > 
> > s/insure/ensure/
> 
> Oops. ;-)
> > 
> > > +		pr_cont("\n");
> > 
> > I know that this is the only code that passes ACPI_MADT_TYPE_LOCAL_X2APIC.
> > That said, this line really has no place in the caller.
> 
> x2apic is probably the only type of system that can grow so large as to
> need worrying about overflowing the log buffer.  That said, there is
> logic in printk() to add a missing '\n'.  Should I just rely on that
> and leave this out?
> 

It's really a shame that it can't be dealt with in the call to 
acpi_table_parse_madt() even if it's just for ACPI_MADT_TYPE_LOCAL_X2APIC.  
The above would be a last resort if there was absolutely no way that you 
can determine which is the last entry to be printed.  I just thought I'd 
comment on it in the hope that you'd find some clever way of avoiding the 
newline in the caller :)

> > 
> > > +
> > >  		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
> > >  					acpi_parse_lapic, MAX_LOCAL_APIC);
> > >  	}
> > > --- linux.orig/drivers/acpi/tables.c
> > > +++ linux/drivers/acpi/tables.c
> > > @@ -66,11 +66,17 @@ void acpi_table_print_madt_entry(struct
> > >  		{
> > >  			struct acpi_madt_local_x2apic *p =
> > >  			    (struct acpi_madt_local_x2apic *)header;
> > > -			printk(KERN_INFO PREFIX
> > > -			       "X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
> > > -			       p->local_apic_id, p->uid,
> > > -			       (p->lapic_flags & ACPI_MADT_ENABLED) ?
> > > -			       "enabled" : "disabled");
> > > +
> > > +			if ((p->uid & 7) == 0)
> > > +				pr_info(PREFIX "X2APIC apic_id=uid:");
> > > +
> > > +			pr_cont(" %02x=%02x%s%s",
> > > +				p->local_apic_id, p->uid,
> > > +				/* assume "enabled" unless "disabled" */
> > > +				(p->lapic_flags & ACPI_MADT_ENABLED) ?
> > > +					"" : " disabled",
> > 
> > Because you're printing only " disabled" when ACPI_MADT_ENABLED is not set,
> > this seems like the format of the line would be ambiguous with regard to
> > which entry it applies to.  I could imagine a line such as
> > 
> > 	X2APIC apic_id=uid: 01=01 disabled 02=02
> > 
> > and then we're left wondering which entry is actually disabled.  I'd prefer
> > "01=01(disabled) 02=02" instead.
> 
> Yes, thanks.  That does make more sense.
> > 
> > Also, why did you drop the "0x" prefixes from the current format?
> 
> With 4096 cores that removes 8k bytes from the log buffer.  Do we really
> need the 0x everywhere?  At what point does the context imply hex?
> 

I personally always prefer the "0x" prefix when you're outputting hex 
because it may not be clear from the value itself.  The VM sometimes 
outputs pfns in base-10 and sometimes in base-16 and it's very confusing 
unless you look at the implementation, for example.  I don't think "0x" is 
egregious long and is worth adding to remove any ambiguity in the value.
