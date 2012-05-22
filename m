Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864Ab2EVP7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:59:38 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:36820 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724Ab2EVP7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:59:36 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, Shai@scalemp.com,
        ido@wizery.com
Subject: Re: [PATCH v4 0/2] Move x86_cpu_to_apicid to the __read_mostly section
Date: Tue, 22 May 2012 18:59:33 +0300
Message-ID: <5976464.UYq28JzI6u@vlad>
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
> Ok, let's start with *numbers*:
> - In the defconfig compilation i've got  219 per_cpu variables: 218 declared
> as NOT read_mostly and only one (tlb_vector_offset) - as read_mostly. -
> From those that are not declared as read_mostly the grep on
> "time|lock|state|stats|last|left|work|owned|reason|list|idle|count|warn|head
> | rcu|nr_|pvecs|irq", which are a likely candidates to be NOT read_mostly (I
> verified a few from each pattern) returned 88. I created the above patterns
> list after walking through about the 1/3 of the per_cpu variables list.
> 
> Unfortunately I have no time to analyze all 219 variables in depth - I leave
> it to the maintainers of the code containing them but it's obvious that
> there are quite a lot read-write per_cpu variables in the kernel code and u
> know, I'm not surprised - if u consider the reasoning to declare a per-cpu
> variable u might notice that in most cases u need it when u actually  mean
> to actively write to it. This is because a main motivation for using
> per_cpu variables is to hide/prevent from other CPUs seeing the *changes*
> of the local per_cpu variable: e.g. lists used for lockless stuff, local
> (per-CPU) locks, counters, etc.
> 
> On the other hand declaration of a read_mostly per-cpu variable performance-
> wise is similar to using a regular read_mostly (*not* per_cpu) array and
> the main difference is a semantics which I feel like a weaker motivation.
> > I.e. it might make more sense to identify the frequenty
> > modified percpu variables, and move them to a separate
> > section. I think most percpu variables are read mostly, so it
> > would be more maintainable in the long run to figure out the
> > frequently modified ones, not the frequently not modified ones.
> 
> I guess the numbers above tell us the opposite. So, I think we'd better
> stick with the read_mostly semantics.  ;)
> 
> I also would like to draw your attention to the fact that this patch series
> doesn't introduce the read_mostly semantics either in a per-cpu context or
> in a non-per-cpu context:
> Originally we have discovered that x86_cpu_to_apicid variable has a
> read_mostly nature and is quite contented and wanted to define it as
> __read_mostly as it should be in order to prevent false sharing.
> 
> More specifically, lapic_events and x86_cpu_to_apicid shared the same cache
> line and the first one was frequently written.
> 
> Since it's defined as an EARLY_PER_CPU variable we had to define the missing
> XXX_EARLY_PER_CPU_READ_MOSTLY() macros.
> 
> Then u asked me to see if other variables from smp.h are also read_mostly,
> which I did however it wasn't our intention to change any infrastructure, on
> the contrary we used the existing one. I have a feeling that thought the
> opposite... ;)

I have a feeling that U thought the opposite... ;)

> 
> So, pls., tell me what's next? Frankly, I don't think the *numbers* part
> above is of any interest to the wide public except for u and me... ;)
> However the "lapic_event" fact above might clarify the motivation a bit
> more.
> 
> Pls., comment.
> 
> thanks,
> vlad
> 
> > Thanks,
> > 
> > 	Ingo
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
