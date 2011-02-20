Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1BTBv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 20:51:28 -0500
Received: from smtp-out.google.com ([74.125.121.67]:4007 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1BTBvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 20:51:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=v6jxQaHMPbRMs67mccDnTnziv1bj0sjKNODjesdGQBd2x0hPgfqrIz9hg6DPBEs6tE
         lkyq9wXdZLGoOo0wqfgg==
Date: Sat, 19 Feb 2011 17:50:51 -0800 (PST)
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
In-Reply-To: <20110219024705.559950799@gulag1.americas.sgi.com>
Message-ID: <alpine.DEB.2.00.1102191637290.27722@chino.kir.corp.google.com>
References: <20110219024705.308511527@gulag1.americas.sgi.com> <20110219024705.559950799@gulag1.americas.sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Mike Travis wrote:

> Minimize X2APIC messages by printing 8 per line and dropping
> the "enabled" flag since that's assumed.  It will still print
> "disabled" if necessary.
> 
> v2: updated to apply to x86-tip
> 

For each patch in this series, it would be tremendously helpful to show 
what format the current output is in and what the format is after the 
patch is applied.

> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Jack Steiner <steiner@sgi.com>
> Reviewed-by: Robin Holt <holt@sgi.com>
> ---
>  arch/x86/kernel/acpi/boot.c |    3 +++
>  drivers/acpi/tables.c       |   16 +++++++++++-----
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> --- linux.orig/arch/x86/kernel/acpi/boot.c
> +++ linux/arch/x86/kernel/acpi/boot.c
> @@ -903,6 +903,9 @@ static int __init acpi_parse_madt_lapic_
>  	if (!count) {
>  		x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC,
>  					acpi_parse_x2apic, MAX_LOCAL_APIC);
> +		/* insure trailing newline is output */

s/insure/ensure/

> +		pr_cont("\n");

I know that this is the only code that passes ACPI_MADT_TYPE_LOCAL_X2APIC.  
That said, this line really has no place in the caller.

> +
>  		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
>  					acpi_parse_lapic, MAX_LOCAL_APIC);
>  	}
> --- linux.orig/drivers/acpi/tables.c
> +++ linux/drivers/acpi/tables.c
> @@ -66,11 +66,17 @@ void acpi_table_print_madt_entry(struct
>  		{
>  			struct acpi_madt_local_x2apic *p =
>  			    (struct acpi_madt_local_x2apic *)header;
> -			printk(KERN_INFO PREFIX
> -			       "X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
> -			       p->local_apic_id, p->uid,
> -			       (p->lapic_flags & ACPI_MADT_ENABLED) ?
> -			       "enabled" : "disabled");
> +
> +			if ((p->uid & 7) == 0)
> +				pr_info(PREFIX "X2APIC apic_id=uid:");
> +
> +			pr_cont(" %02x=%02x%s%s",
> +				p->local_apic_id, p->uid,
> +				/* assume "enabled" unless "disabled" */
> +				(p->lapic_flags & ACPI_MADT_ENABLED) ?
> +					"" : " disabled",

Because you're printing only " disabled" when ACPI_MADT_ENABLED is not 
set, this seems like the format of the line would be ambiguous with regard 
to which entry it applies to.  I could imagine a line such as

	X2APIC apic_id=uid: 01=01 disabled 02=02

and then we're left wondering which entry is actually disabled.  I'd 
prefer "01=01(disabled) 02=02" instead.

Also, why did you drop the "0x" prefixes from the current format?

> +				/* nl every 8th item */
> +				(p->uid & 7) == 7 ? "\n" : "");
>  		}
>  		break;
>  
