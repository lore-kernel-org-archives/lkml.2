Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab2EUO5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:57:01 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:57570 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab2EUO47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:56:59 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v3 0/2] Move x86_cpu_to_apicid to the __read_mostly section
Date: Mon, 21 May 2012 17:56:34 +0300
Message-ID: <2213388.vLKcp40cFW@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.2 (Linux/3.2.0-24-generic; KDE/4.8.2; i686; ; )
In-Reply-To: <20120521140822.GA12976@gmail.com>
References: <1337527148.6093.14.camel@vlad> <1693911.sUneyHzERA@vlad> <20120521140822.GA12976@gmail.com>
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

On Monday, May 21, 2012 16:08:22 Ingo Molnar wrote:
> * Vlad Zolotarov <vlad@scalemp.com> wrote:
> > On Monday, May 21, 2012 02:32:46 PM Ingo Molnar wrote:
> > > * Shai Fultheim (Shai@ScaleMP.com) <Shai@ScaleMP.com> wrote:
> > > > Ingo,
> > > > 
> > > > The reason for this, as you pointed out, is the 'cache line'
> > > > size (4096 bytes).  We see significant false sharing is we do
> > > > not move this next to each other.
> > > 
> > > Which write-often variable caused the many cache flushes/fills?
> > > cpu_to_apicid is read mostly.
> > > 
> > > I.e. it might make more sense to identify the frequenty
> > > *modified* percpu variables, and move them to a separate
> > > section. I *think* most percpu variables are read mostly, so
> > > it would be more maintainable in the long run to figure out
> > > the frequently modified ones, not the frequently not
> > > modified ones.
> > 
> > I tend to disagree about the general claim that most per-CPU
> > variables are read-mostly: consider the per-CPU data
> > structures used in lock-less algorithms like softnet_data used
> > in a NAPI. I'm not sure what is a more common - read- only or
> > not-read-only per-cpu data, but surely there are both...
> 
> Well, a quick tally of percpu variables on a 'make defconfig'
> kernel would tell us one way or another?
> 
> Here there's almost 200 percpu variables active in the 64-bit
> x86 defconfig, and a quick random sample suggests that most are
> read-mostly.
> 
> I have no fundamental prefer to either approach, but the
> direction taken should be justified explicitly, with numbers,
> arguments, etc. - also a short blurb somewhere in the headers
> that explains when they should be used, so that others can be
> aware of vSMP's special needs here.

There must be some misunderstanding - this patch is not a vSMP Foundation 
specific as it defines read-mostly variables as __read_mostly. The motivation 
for it is just the same as in a non-vSMP Foundation case. It's true that the 
performance gain this patch introduces in the vSMP Foundation is likely to be 
more significant than in a native Linux, however even for a native Linux it 
would still be a better code as __read_mostly is not a vSMP Foundation 
specific paradigm and, again, the variables modified are a clear read-mostly 
case.

So, the explanation u request above would be just the same as if I would 
explain when in general __read_mostly should be used. 

I grep'ed the Documentation and haven't found any readme file with the 
explicit instructions when __read_mostly qualifier should be used and u r 
right we'd better write one. 

I can create an initial version of such a doc but I think it would better come 
as a separate patch.

May we advance this way?

Pls., comment.

> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
