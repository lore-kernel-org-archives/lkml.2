Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab2EUKOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:14:40 -0400
Received: from relay.ihostexchange.net ([66.46.182.52]:6550 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab2EUKOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:14:39 -0400
From: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
To: Ingo Molnar <mingo@kernel.org>, Vlad Zolotarov <vlad@ScaleMP.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ido Yariv <ido@wizery.com>
Date: Mon, 21 May 2012 06:14:29 -0400
Subject: RE: [PATCH v3 0/2] Move x86_cpu_to_apicid to the __read_mostly
 section
Thread-Topic: [PATCH v3 0/2] Move x86_cpu_to_apicid to the __read_mostly
 section
Thread-Index: Ac03MQxb3olu9cELTJaGAnFJ8UMzbQACQ3rw
Message-ID: <9B14D1490DDECA4E974F6B9FC9EBAB317D295F4D11@VMBX108.ihostexchange.net>
References: <1337527148.6093.14.camel@vlad>
 <20120521090638.GE31407@gmail.com>
In-Reply-To: <20120521090638.GE31407@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The reason for this, as you pointed out, is the 'cache line' size (4096 bytes).  We see significant false sharing is we do not move this next to each other.  

We observed this for x86_cpu_to_apicid only, but per earlier request on this thread we implemented for the other (RO) vars as well.

Regards,
Shai.


--Shai 


> -----Original Message-----
> From: Ingo Molnar [mailto:mingo.kernel.org@gmail.com] On Behalf Of Ingo
> Molnar
> Sent: Monday, May 21, 2012 12:07
> To: Vlad Zolotarov
> Cc: Thomas Gleixner; linux-kernel; Ingo Molnar; H. Peter Anvin; Shai Fultheim
> (Shai@ScaleMP.com); Ido Yariv
> Subject: Re: [PATCH v3 0/2] Move x86_cpu_to_apicid to the __read_mostly
> section
> 
> 
> * Vlad Zolotarov <vlad@scalemp.com> wrote:
> 
> > Pls., consider applying this patch series.
> > It contains the following changes:
> >  - Adds two new macros DEFINE_EARLY_PER_CPU_READ_MOSTLY() and
> >    DECLARE_EARLY_PER_CPU_READ_MOSTLY().
> >  - Adds "read-mostly" qualifier to the following variables in smp.h:
> >   - cpu_sibling_map
> >   - cpu_core_map
> >   - cpu_llc_shared_map
> >   - cpu_llc_id
> >   - cpu_number
> >   - x86_cpu_to_apicid
> >   - x86_bios_cpu_apicid
> >   - x86_cpu_to_logical_apicid
> >
> > As long as all the variables above are only written during the
> > initialization, this change is meant to prevent the false
> > sharing and improve the performance on large multiprocessor
> > systems.
> 
> Mind explaining why it helps performance? Are these percpu
> variables also accessed from other CPUs, increasing the cost of
> false sharing of cache-lines?
> 
> Or is the problem that the 'cache line' size is 4096 bytes on
> vSMP, making even singular cache misses expensive and you'd like
> to move these next to each other?
> 
> So it would be nice to see some before/after PMU stats
> demonstrating the improvement. (perf works on vSMP, right?)
> 
> Thanks,
> 
> 	Ingo
