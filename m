Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0IFQm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 12:42:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35297 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0IFQmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 12:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=flvY9rYR+80GwiJTISpUj5Qeeuyd/avORWvP/RzlpcdP6gso428IUY+RFA3w/o4T6O
         p/Gfp1X1bjpX6Ug84m+XbuRQxQpkV4iE0dLPlUs8EQKQENVOkAWHq7BmbGfkj1rpjRat
         tF7xBSff4CJxbVC/ThHquSQhkYqlg6owBXcPY=
Subject: Re: disabling group leader perf_event
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Avi Kivity <avi@redhat.com>, linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1de72fcf-91c7-4357-a6ac-27704ac1ba0b@email.android.com>
References: <4C84B088.5050003@redhat.com> <1283772256.1930.303.camel@laptop>
	 <4C84D1CE.3070205@redhat.com> <1283774045.1930.341.camel@laptop>
	 <4C84D77B.6040600@redhat.com> <1283776189.1930.380.camel@laptop>
	 <20100906124046.GA20777@elte.hu>
	 <1de72fcf-91c7-4357-a6ac-27704ac1ba0b@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Sep 2010 11:42:11 -0500
Message-ID: <1283791331.3594.27.camel@elnicho32>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2010-09-06 at 09:16 -0400, Steven Rostedt wrote:
> Sorry for top post, sending via my android phone. Today's a US holiday.
>  
> 
> We can filter before the work, if we expose the parameters. Currently we filter what goes into the buffer and there are several cases where we don't know the result before the work.
> 
> If we also expose the parameters of a TRACE_EVENT, then we can filter on them before the work.

I'm not sure exactly what you mean by exposing the parameters, but yeah,
in general it should be possible to filter on any field you can get the
address of, before you ever allocate space for the event or assign the
field to it.

In the cases where you don't know the result until you do the work, such
as for example this from kvm_age_page tracepoint:

        TP_fast_assign(
                __entry->hva            = hva;
                __entry->gfn            =
                  slot->base_gfn + ((hva - slot->userspace_addr) >>
PAGE_SHIFT);
                __entry->referenced     = ref;
        ),

I guess you'd want the macro to assign the result to a temporary in
order to be able to participate in the filtering, or did you have
something else in mind?

Tom

> -- Steve
> 
> "Ingo Molnar" <mingo@elte.hu> wrote:
> 
> >
> >* Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >> On Mon, 2010-09-06 at 14:58 +0300, Avi Kivity wrote:
> >> > On 09/06/2010 02:54 PM, Peter Zijlstra wrote:
> >> > >
> >> > >> Basically, to read() all events in one go.  I have many of them.
> >> > >>
> >> > >> My current problem is that I have an event (kvm_exit) which I want to
> >> > >> drill down by looking at a field (exit_reason).  So I create lots of
> >> > >> separate perf_events with a filter for each reason:
> >> > >> kvm_exit(exit_reason==0), kvm_exit(exit_reason==1), etc.  But filters
> >> > >> are fairly slow (can have ~60 such events on AMD), so I want to make
> >> > >> this drill-down optional.
> >> > > Yeah, filters suck.
> >> > 
> >> > Any idea why?  I saw nothing obvious in the code, except that there 
> >> > is lots of it.
> >> 
> >> It filters after it does all the hard work of creating the trace 
> >> event, instead of before.
> >
> >Btw., that's an implementational property of filters that would be nice 
> >to fix.
> >
> >If it's not doable within CPP then outside of it.
> >
> >	Ingo
> 


