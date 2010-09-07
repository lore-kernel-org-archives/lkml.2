Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab0IGMxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:53:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43361 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab0IGMxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:53:46 -0400
X-Authority-Analysis: v=1.1 cv=kSl6L8luU05z5mpL051isgeeLpAUfowbwuc/WIqEapw= c=1 sm=0 a=X7QPjtwe-8wA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=wy_DN1xdFeO1OxuRwIkA:9 a=U4Jn-0_ewWWRe0PtFkeA2TyFd-8A:4 a=PUjeQqilurYA:10 a=-fl8KtO-vjMe9lsy:21 a=UCPUVuFKJ0m7x1CA:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: disabling group leader perf_event
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Avi Kivity <avi@redhat.com>, linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1283791331.3594.27.camel@elnicho32>
References: <4C84B088.5050003@redhat.com> <1283772256.1930.303.camel@laptop>
	 <4C84D1CE.3070205@redhat.com> <1283774045.1930.341.camel@laptop>
	 <4C84D77B.6040600@redhat.com> <1283776189.1930.380.camel@laptop>
	 <20100906124046.GA20777@elte.hu>
	 <1de72fcf-91c7-4357-a6ac-27704ac1ba0b@email.android.com>
	 <1283791331.3594.27.camel@elnicho32>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Sep 2010 08:53:43 -0400
Message-ID: <1283864023.5133.58.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 11:42 -0500, Tom Zanussi wrote:
> Hi,
> 
> On Mon, 2010-09-06 at 09:16 -0400, Steven Rostedt wrote:
> > Sorry for top post, sending via my android phone. Today's a US holiday.
> >  
> > 
> > We can filter before the work, if we expose the parameters. Currently we filter what goes into the buffer and there are several cases where we don't know the result before the work.
> > 
> > If we also expose the parameters of a TRACE_EVENT, then we can filter on them before the work.
> 
> I'm not sure exactly what you mean by exposing the parameters, but yeah,
> in general it should be possible to filter on any field you can get the
> address of, before you ever allocate space for the event or assign the
> field to it.
> 
> In the cases where you don't know the result until you do the work, such
> as for example this from kvm_age_page tracepoint:
> 
>         TP_fast_assign(
>                 __entry->hva            = hva;
>                 __entry->gfn            =
>                   slot->base_gfn + ((hva - slot->userspace_addr) >>
> PAGE_SHIFT);
>                 __entry->referenced     = ref;
>         ),
> 
> I guess you'd want the macro to assign the result to a temporary in
> order to be able to participate in the filtering, or did you have
> something else in mind?

Here we already did the work. We assigned everything, then might as well
keep what we have. What I had in mind was:

TRACE_EVENT(kvm_age_page,
        TP_PROTO(ulong hva, struct kvm_memory_slot *slot, int ref),
        TP_ARGS(hva, slot, ref),

and be able to make a filter that says: slot->userspace_addr > X

Where we filter the parameters and not what is in the entry.
Unfortunately, this would make TRACE_EVENT() even bigger since we would
need to store what the parameter names are.

-- Steve




