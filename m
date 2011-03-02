Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1CBPnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:43:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1CBPnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:43:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OosojTybwGPxUoZuujWw/FD3ozEV80EXZIxWTnExf5HG4x1/JH3LVbOzWvoj5KbLrS
         p30rVoombY+L/pjNHoTP4OsL4nBi4ule+Ls3DTqG5TDso6R0zPeNVwaDaw0S0Wxkbp4m
         AgXNPDLIo+sB2lGDAJe1jPlL1jGOBzreOuK8o=
Date: Wed, 2 Mar 2011 16:42:15 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110302154215.GN3319@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org>
 <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Mar 02, 2011 at 06:30:59AM -0800, David Rientjes wrote:
> Acked-by: David Rientjes <rientjes@google.com>
> 
> There's also this in numa_emulation() that isn't a safe assumption:
> 
>         /* make sure all emulated nodes are mapped to a physical node */
>         for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
>                 if (emu_nid_to_phys[i] == NUMA_NO_NODE)
>                         emu_nid_to_phys[i] = 0;
> 
> Node id 0 is not always online depending on how you setup your SRAT.  I'm 
> not sure why emu_nid_to_phys[] would ever map a fake node id that doesn't 
> exist to a physical node id rather than NUMA_NO_NODE, so I think it can 
> just be removed.  Otherwise, it should be mapped to a physical node id 
> that is known to be online.

Unless I screwed up, that behavior isn't new.  It just put in a
different form.  Looking through the code... Okay, I think node 0
always exists.  SRAT PXM isn't used as node number directly.  It goes
through acpi_map_pxm_to_node() which allocates nids from 0 up.
amdtopology also guarantees the existence of node 0, so I think we're
in the safe and that probably is the reason why we had the above
behavior in the first place.

IIRC, there are other places which assume the existence of node 0.
Whether it's a good idea or not, I'm not sure but requring node 0 to
be always allocated doesn't sound too wrong to me.  Maybe we can add
BUG_ON() if node 0 is offline somewhere.

Thanks.

-- 
tejun
