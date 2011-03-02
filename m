Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab1CBVNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:13:14 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52167 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab1CBVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:13:12 -0500
Message-ID: <4D6EB2C3.7040704@kernel.org>
Date: Wed, 02 Mar 2011 13:12:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table handling
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com> <20110302100400.GK19669@htj.dyndns.org> <20110302102530.GB3319@htj.dyndns.org> <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com> <20110302154215.GN3319@htj.dyndns.org>
In-Reply-To: <20110302154215.GN3319@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D6EB2D0.00A6,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 07:42 AM, Tejun Heo wrote:
> Hey,
> 
> On Wed, Mar 02, 2011 at 06:30:59AM -0800, David Rientjes wrote:
>> Acked-by: David Rientjes <rientjes@google.com>
>>
>> There's also this in numa_emulation() that isn't a safe assumption:
>>
>>         /* make sure all emulated nodes are mapped to a physical node */
>>         for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
>>                 if (emu_nid_to_phys[i] == NUMA_NO_NODE)
>>                         emu_nid_to_phys[i] = 0;
>>
>> Node id 0 is not always online depending on how you setup your SRAT.  I'm 
>> not sure why emu_nid_to_phys[] would ever map a fake node id that doesn't 
>> exist to a physical node id rather than NUMA_NO_NODE, so I think it can 
>> just be removed.  Otherwise, it should be mapped to a physical node id 
>> that is known to be online.
> 
> Unless I screwed up, that behavior isn't new.  It just put in a
> different form.  Looking through the code... Okay, I think node 0
> always exists.  SRAT PXM isn't used as node number directly.  It goes
> through acpi_map_pxm_to_node() which allocates nids from 0 up.
> amdtopology also guarantees the existence of node 0, so I think we're
> in the safe and that probably is the reason why we had the above
> behavior in the first place.
> 
> IIRC, there are other places which assume the existence of node 0.
> Whether it's a good idea or not, I'm not sure but requring node 0 to
> be always allocated doesn't sound too wrong to me.  Maybe we can add
> BUG_ON() if node 0 is offline somewhere.


When first socket does not have memory, we will not node 0 online.
and cpu_to_node() will have those cpus round to near node like node1 or node7.

BTW: this conf get broken several times, and get fixed several times.

Yinghai
