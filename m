Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab2GEOqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:46:53 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35929 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189Ab2GEOqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:46:50 -0400
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Rik van Riel <riel@redhat.com>
Cc: "Vinod, Chegu" <chegu_vinod@hp.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <4FF1B4E4.2010801@redhat.com>
References: <168f205d-d65f-4864-99c8-363b12818a9b@zmail17.collab.prod.int.phx2.redhat.com>
	 <4FEC84BD.6030304@linux.vnet.ibm.com>
	 <C4FA8004DBDF864387014E5EA4383B0F580BD0F5E7@GVW1336EXC.americas.hpqcorp.net>
	 <4FF1B4E4.2010801@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Jul 2012 09:45:46 -0500
Message-ID: <1341499546.20070.21.camel@atheurer-zpro>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070514-5806-0000-0000-0000170053CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 10:49 -0400, Rik van Riel wrote:
> On 06/28/2012 06:55 PM, Vinod, Chegu wrote:
> > Hello,
> >
> > I am just catching up on this email thread...
> >
> > Perhaps one of you may be able to help answer this query.. preferably along with some data.  [BTW, I do understand the basic intent behind PLE in a typical [sweet spot] use case where there is over subscription etc. and the need to optimize the PLE handler in the host etc. ]
> >
> > In a use case where the host has fewer but much larger guests (say 40VCPUs and higher) and there is no over subscription (i.e. # of vcpus across guests<= physical cpus in the host  and perhaps each guest has their vcpu's pinned to specific physical cpus for other reasons), I would like to understand if/how  the PLE really helps ?  For these use cases would it be ok to turn PLE off (ple_gap=0) since is no real need to take an exit and find some other VCPU to yield to ?
> 
> Yes, that should be ok.
> 
> On a related note, I wonder if we should increase the ple_gap
> significantly.
> 
> After all, 4096 cycles of spinning is not that much, when you
> consider how much time is spent doing the subsequent vmexit,
> scanning the other VCPU's status (200 cycles per cache miss),
> deciding what to do, maybe poking another CPU, and eventually
> a vmenter.
> 
> A factor 4 increase in ple_gap might be what it takes to
> get the amount of time spent spinning equal to the amount of
> time spent on the host side doing KVM stuff...

I was recently thinking the same thing as I have observed over 180,000
exits/sec from a 40-way VM on a 80-way host, where there should be no
cpu overcommit.  Also, the number of directed yields for this was only
1800/sec, so we have a 1% usefulness for our exits.  I am wondering if
the ple_window should be similar to the host scheduler task switching
granularity, and not what we think a typical max cycles should be for
holding a lock.

BTW, I have a patch to add a couple PLE stats to kvmstat which I will
send out shortly.

-Andrew




