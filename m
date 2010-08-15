Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab0HOP0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 11:26:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48916 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab0HOP00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 11:26:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R9j3DBMM3WcmdJra/OkJe4qmctl7EuiBpyZEbubzzEqz6avzHCiquxFBWr1LqWczZH
         5G7n0BRqafiZ8JgJgk9DsDA781t79Q7uXdvIJoA62FBR3Snlss1xUjHd9Gb3/onPY/iD
         +uEISaxqlsuk7DpbkAV7xVehW0FzQTw7At6iA=
Date: Sun, 15 Aug 2010 12:24:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Don't write io_apic ID if it is not changed
Message-ID: <20100815082446.GA5629@lenovo>
References: <4C66FEA9.3040303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C66FEA9.3040303@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 01:38:01PM -0700, Yinghai Lu wrote:
> 
> For 32bit mptable path, setup_ids_from_mpc() always write io apic id
> register, even there is no change needed.
> 
> So try to do that when they are different bewteen reading out and mptable
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/apic/io_apic.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -2125,7 +2125,6 @@ void __init setup_ioapic_ids_from_mpc(vo
>  			physids_or(phys_id_present_map, phys_id_present_map, tmp);
>  		}
>  
> -
>  		/*
>  		 * We need to adjust the IRQ routing table
>  		 * if the ID changed.
> @@ -2137,9 +2136,12 @@ void __init setup_ioapic_ids_from_mpc(vo
>  						= mp_ioapics[apic_id].apicid;
>  
>  		/*
> -		 * Read the right value from the MPC table and
> -		 * write it into the ID register.
> +		 * Update the ID register according to the right value from
> +		 *  the MPC table if they are different.
>  		 */
> +		if (mp_ioapics[apic_id].apicid == reg_00.bits.ID)
> +			continue;
> +
>  		apic_printk(APIC_VERBOSE, KERN_INFO
>  			"...changing IO-APIC physical APIC ID to %d ...",
>  			mp_ioapics[apic_id].apicid);

As far as I see, this was done by a purpose in former code. Consider the
situation when mp_ioapics[apic_id].apicid >= get_physical_broadcast().
By code flow (io_apic.c:2099) this set

		if (mp_ioapics[apic_id].apicid >= get_physical_broadcast()) {
			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
				apic_id, mp_ioapics[apic_id].apicid);
			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
				reg_00.bits.ID);
--->			mp_ioapics[apic_id].apicid = reg_00.bits.ID;
		}

So with your patch we always hit "continue" without real changing of ID which
is not correct.

But perhaps I miss something?

	-- Cyrill
