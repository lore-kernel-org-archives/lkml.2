Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab1CCUAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:00:52 -0500
Received: from smtp-out.google.com ([216.239.44.51]:12357 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab1CCUAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:00:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=BC82cXE5kvgbBo1oxi1Dajq1tbRWeJNnBYhNE+YtR0fZ/EVQPxcD7Jg9eTPGtHmP93
         OqdwCxotp7eQun5e5S9A==
Date: Thu, 3 Mar 2011 12:00:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
In-Reply-To: <20110302154215.GN3319@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1103031155490.9993@chino.kir.corp.google.com>
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com> <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org> <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com> <20110302154215.GN3319@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Tejun Heo wrote:

> > There's also this in numa_emulation() that isn't a safe assumption:
> > 
> >         /* make sure all emulated nodes are mapped to a physical node */
> >         for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
> >                 if (emu_nid_to_phys[i] == NUMA_NO_NODE)
> >                         emu_nid_to_phys[i] = 0;
> > 
> > Node id 0 is not always online depending on how you setup your SRAT.  I'm 
> > not sure why emu_nid_to_phys[] would ever map a fake node id that doesn't 
> > exist to a physical node id rather than NUMA_NO_NODE, so I think it can 
> > just be removed.  Otherwise, it should be mapped to a physical node id 
> > that is known to be online.
> 
> Unless I screwed up, that behavior isn't new.  It just put in a
> different form.  Looking through the code... Okay, I think node 0
> always exists.  SRAT PXM isn't used as node number directly.  It goes
> through acpi_map_pxm_to_node() which allocates nids from 0 up.
> amdtopology also guarantees the existence of node 0, so I think we're
> in the safe and that probably is the reason why we had the above
> behavior in the first place.
> 

The node may not have any memory or may be offline, which means we 
shouldn't be mapping fake nodes to it.  There shouldn't be any code that 
can't handle emu_nid_to_phys[] being NUMA_NO_NODE, otherwise there's a 
design issue.

> IIRC, there are other places which assume the existence of node 0.
> Whether it's a good idea or not, I'm not sure but requring node 0 to
> be always allocated doesn't sound too wrong to me.  Maybe we can add
> BUG_ON() if node 0 is offline somewhere.
> 

There shouldn't be because you can't guarantee it is online, it's not a 
BUG_ON() condition, it can easily be done if the pxm for node 0 in the 
SRAT is empty or non-existant.
