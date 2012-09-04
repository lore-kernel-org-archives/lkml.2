Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab2IDWl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:41:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22147 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab2IDWlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:41:53 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zgiTqp1681AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Md3Eq_kwYTQA:10 a=imTROTZUkysA:10 a=OQEzN_gqAOIA:10 a=pN9PhARNchwA:10 a=nFlYCK1qHmYA:10 a=EGDuWttHsakA:10 a=d88tSJZ3tUhf-Zmav60A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346798509.27919.25.camel@gandalf.local.home>
Subject: Re: [PATCH v3 01/17] hashtable: introduce a small and naive
 hashtable
From: Steven Rostedt <rostedt@goodmis.org>
To: Pedro Alves <palves@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sasha Levin <levinsasha928@gmail.com>, Tejun Heo <tj@kernel.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, mingo@elte.hu,
        ebiederm@xmission.com, aarcange@redhat.com, ericvh@gmail.com,
        netdev@vger.kernel.org, josh@joshtriplett.org, eric.dumazet@gmail.com,
        axboe@kernel.dk, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        ccaulfie@redhat.com, teigland@redhat.com, Trond.Myklebust@netapp.com,
        bfields@fieldses.org, fweisbec@gmail.com, jesse@nicira.com,
        venkat.x.venkatsubra@oracle.com, ejt@redhat.com, snitzer@redhat.com,
        edumazet@google.com, linux-nfs@vger.kernel.org, dev@openvswitch.org,
        rds-devel@oss.oracle.com, lw@cn.fujitsu.com
Date: Tue, 04 Sep 2012 18:41:49 -0400
In-Reply-To: <504677C8.3050801@redhat.com>
References: <20120824203332.GF21325@google.com> <5037E9D9.9000605@gmail.com>
	    <20120824212348.GK21325@google.com> <5038074D.300@gmail.com>
	    <20120824230740.GN21325@google.com> <20120825042419.GA27240@Krystal>
	    <503C95E4.3010000@gmail.com> <20120828101148.GA21683@Krystal>
	    <503CAB1E.5010408@gmail.com> <20120828115638.GC23818@Krystal>
	    <20120828230050.GA3337@Krystal>
	   <1346772948.27919.9.camel@gandalf.local.home>
	  <50462C99.5000007@redhat.com>  <50462EE8.1090903@redhat.com>
	  <1346779027.27919.15.camel@gandalf.local.home>
	  <50463883.8080706@redhat.com>
	 <1346792345.27919.18.camel@gandalf.local.home>
	 <504677C8.3050801@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 22:51 +0100, Pedro Alves wrote:
> On 09/04/2012 09:59 PM, Steven Rostedt wrote:
> > On Tue, 2012-09-04 at 18:21 +0100, Pedro Alves wrote:
> >> On 09/04/2012 06:17 PM, Steven Rostedt wrote:
> >>> On Tue, 2012-09-04 at 17:40 +0100, Pedro Alves wrote:
> >>>
> >>>> BTW, you can also go a step further and remove the need to close with double }},
> >>>> with something like:
> >>>>
> >>>> #define do_for_each_ftrace_rec(pg, rec)                                          \
> >>>>         for (pg = ftrace_pages_start, rec = &pg->records[pg->index];             \
> >>>>              pg && rec == &pg->records[pg->index];                               \
> >>>>              pg = pg->next)                                                      \
> >>>>           for (rec = pg->records; rec < &pg->records[pg->index]; rec++)
> >>>>
> >>>
> >>> Yeah, but why bother? It's hidden in a macro, and the extra '{ }' shows
> >>> that this is something "special".
> >>
> >> The point of both changes is that there's nothing special in the end
> >> at all.  It all just works...
> >>
> > 
> > It would still fail on a 'break'. The 'while' macro tells us that it is
> > special, because in the end, it wont work.
> 
> Please explain why it would fail on a 'break'.
> 

Ah, I missed the condition with the rec == &pg->records[pg->index]. But
if ftrace_pages_start is NULL, the rec = &pg->records[pg->index] will
fault.

You could do something like rec = pg ? &pg->records[pg->index] : NULL,
but IIRC, the comma operator does not guarantee order evaluation. That
is, the compiler is allowed to process "a , b" as "b; a;" and not "a;
b;".

-- Steve


