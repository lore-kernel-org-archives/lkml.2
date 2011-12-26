Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab1LZDTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 22:19:16 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:47600 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1LZDTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 22:19:07 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4EF701C7.9080907@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 26 Dec 2011 08:44:58 +0530
Message-ID: <87vcp4t45p.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11122603-5564-0000-0000-000000A967E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Dec 2011 12:58:15 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/23/2011 12:36 PM, Ingo Molnar wrote:
> > * Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> >
[...]
> > > 
> > > I see the main difference between both the reports is:
> > > native_flush_tlb_others.
> >
> > So it would be important to figure out why ebizzy gets into so 
> > many TLB flushes and why gang scheduling makes it go away.
> 
> The second part is easy - a remote tlb flush involves IPIs to many other
> vcpus (possible waking them up and scheduling them), then busy-waiting
> until they acknowledge the flush.  Gang scheduling is really good here
> since it shortens the busy wait, would be even better if we schedule
> halted vcpus (see the yield_on_hlt module parameter, set to 0). 
I will check this.

> Directed yield on PLE should provide intermediate results between doing
> nothing and gang sched.
>
Yes, thats true, I have pasted the results from my first mail to
highlight this:

    +-------------+---------------------------+-------------------------+
    |             |            V1 (%)         |             V2 (%)      |
    + Benchmarks  +-------------+-------------+-------------------------+
    |             | GangVsBase  |   GangVsPin |  GangVsBase | GangVsPin |
    +-------------+-------------+-------------+-------------------------+
    | ebizzy  2vm |        0    |        3    |        2    |        5  |
    | ebizzy  4vm |        1    |        0    |        4    |        3  |
    | ebizzy  8vm |        0    |        1    |       23    |       26  |
    +-------------+-------------+-------------+-------------------------+
 
> 
> btw you can get an additional speedup by enabling x2apic, for
> default_send_IPI_mask_logical().
> 
In the host?

Nikunj

