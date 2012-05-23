Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab2EWJQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:16:36 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:52609 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2EWJQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:16:34 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, Shai@scalemp.com,
        ido@wizery.com
Subject: Re: [PATCH v4 0/2] Move x86_cpu_to_apicid to the __read_mostly section
Date: Wed, 23 May 2012 12:16:29 +0300
Message-ID: <1415723.ntIHEoaamI@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.2 (Linux/3.2.0-24-generic; KDE/4.8.2; i686; ; )
In-Reply-To: <5555210.ryZGheQWJb@vlad>
References: <1744141.b5asW8k6jC@vlad> <20120521201958.GB10848@gmail.com> <5555210.ryZGheQWJb@vlad>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 22, 2012 18:55:41 Vlad Zolotarov wrote:
> > > I have no fundamental prefer to either approach, but the
> > > direction taken should be justified explicitly, with numbers,
> > > arguments, etc. - also a short blurb somewhere in the headers
> > > that explains when they should be used, so that others can be
> > > aware of vSMP's special needs here.
> > 
> > I.e. *numbers* are needed: roughly how many percpu variables in
> > a defconfig of one type versus the other type. This settles the
> > question whether we want to identify read-mostly or
> > write-frequently variables, to address this particular problem
> > ...
> 

Ingo, here is the proposal to the patch (series) description:

------------------------------------------------------------------------------------------------
Added "read-mostly" qualifier to the following variables in smp.h:
 - cpu_sibling_map
 - cpu_core_map
 - cpu_llc_shared_map
 - cpu_llc_id
 - cpu_number
 - x86_cpu_to_apicid
 - x86_bios_cpu_apicid
 - x86_cpu_to_logical_apicid

As long as all the variables above are only written during the initialization,
this change is meant to prevent the false sharing. More specifically, on vSMP 
Foundation platform x86_cpu_to_apicid shared the same internode_cache_line 
with frequently written lapic_events.

>From the analysis of the first 33 per_cpu variables  out of 219 (memories they 
describe, to be more specific) the 8 have read_mostly nature 
(tlb_vector_offset, cpu_loops_per_jiffy, xen_debug_irq, etc.) and 25 are 
frequently written (irq_stack_union, gdt_page, exception_stacks, idt_desc, 
etc.). Assuming that the spread of the rest of the per_cpu variables is 
similar, identifying the read mostly memories will make more sense in terms of 
long-term code maintenance comparing to identifying frequently written 
memories.
---------------------------------------------------------------------------------------------------

Pls., tell me if the above looks satisfactory to u in light of all your 
previous remarks.

If yes - I'll respin the series with the description above.

thanks,
vlad
