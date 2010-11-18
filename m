Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab0KRS5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:57:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160Ab0KRS5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:57:01 -0500
Date: Thu, 18 Nov 2010 19:56:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: hp <hp.reichert@xse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch] trace: Add user-space event tracing/injection
Message-ID: <20101118185644.GA10827@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <4CE38C53.8090606@kernel.org>
 <20101117120740.GA24972@elte.hu>
 <4CE47ED0.7080901@linux.intel.com>
 <20101118085513.GH26398@elte.hu>
 <loom.20101118T170856-336@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20101118T170856-336@post.gmane.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* hp <hp.reichert@xse.de> wrote:

> Ingo Molnar <mingo <at> elte.hu> writes:
> 
> > 
> > 
> > * Darren Hart <dvhart <at> linux.intel.com> wrote:
> > 
> > > Ideally I would like to see something just like trace_printf()
> > > without having to define it myself in each of my testcases. [...]
> > 
> > We can make the prctl a single-argument thing, at the cost of not allowing \0
> in the 
> > content. (which is probably sane anyway)
> > 
> > That way deployment is super-simple:
> > 
> > 	prctl(35, "My Trace Message");
> > 	...
> > 
> > 	if (asprintf(&msg, "My Trace Message: %d\n", 1234) != -1) {
> > 		prctl(35, *msg);
> > 		free(*msg);
> > 	}
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> I like this approach - it is doing it nearly the same way I did it with an extra
> k-mod (no patch needed) and a debugfs entry handled in that mod.
> I only see one thing with the string only data - I am doing stuff where there
> are long recording times with also a lot of user events,
> in such an environment I need more semantics on the event contents.
> In my k-mod solution there's an event ID and the opportunity to log binary data.
> As prctl() has 4 additional args after the option, it would be possible to use
> it in the following way:
> prtctl( 35, int eventID, int data_type, int msglen, void *buf);
> or without the data_type
> prtctl( 35, int eventID, int msglen, void *buf);
> decoding would be of more effort but it would be worth
> 
> The event definition would be like this (with data_type):
> 
> TRACE_EVENT(user,
>         TP_PROTO(int id, int dtype, int dlen, unsigned char *bytes),
>         TP_ARGS(id, dtype, dlen, bytes),
>         TP_STRUCT__entry(
>                 __field(int, ev_id)
>                 __field(int, ev_type)
>                 __dynamic_array(unsigned char, ev_data, dlen)
>         ),
>         TP_fast_assign(
>                 __entry->ev_id = id;
> 		__entry->ev_type = dtype;
> 		memcpy(__get_dynamic_array(ev_data), bytes, dlen);
>         ),
> 
>         TP_printk("ID: %d type: %s data: %s", __entry->ev_id,
> __print_symbolic(__entry->ev_type, {0,"V"}, {1,"I"}, {2,"S"}, {4,"B"}),
> __entry->ev_type == 0 ? "n/a" : __get_str(ev_data))
> );
> 
> 
> What do you think about this?

The transport was not limited to strings - it's a memory buffer of 'len' bytes.

In that sense 'ev_id' and 'ev_type' above is really just hardcoding something that 
the app might not care about.

For example with the patch i sent one could send 1 byte messages - no other 
overhead. (beyond the standard record header)

While if an app does want to use an (ev_id, ev_type), it can still do so. Or if an 
app wants to do some other message type, that can be done too - it's free-form.

Thanks,

	Ingo
