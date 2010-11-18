Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0KRTRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:17:45 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.29]:34695 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab0KRTRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:17:44 -0500
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Nov 2010 14:17:43 EST
From: "Reichert, Hans-Peter" <Hans-Peter.Reichert@xse.de>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: AW: [patch] trace: Add user-space event tracing/injection
Thread-Topic: [patch] trace: Add user-space event tracing/injection
Thread-Index: AQHLh1KuRWiBTVmM8UOufMHKdwvMZZN3lwQg
Date: Thu, 18 Nov 2010 19:13:17 +0000
Message-ID: <7DDD50084903ED4396A4BB627E87B7774DD2EBC2@XSRWWSEX01.xse.local>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <4CE38C53.8090606@kernel.org> <20101117120740.GA24972@elte.hu>
 <4CE47ED0.7080901@linux.intel.com> <20101118085513.GH26398@elte.hu>
 <loom.20101118T170856-336@post.gmane.org> <20101118185644.GA10827@elte.hu>
In-Reply-To: <20101118185644.GA10827@elte.hu>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-olx-disclaimer: Done
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Df-Sender: stern@xs-embedded.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




XS Embedded GmbH
Roggenbachstr. 6
D-78050 Villingen - Schwenningen

Telefon +49 (7721) 4060 - 450
Fax     +49 (7721) 4060 - 499

www.xse.de
Hans-Peter.Reichert@xse.de

:::::::::: based.on.visions ::::::::::


XS Embedded GmbH
Geschäftsführung: Michael Maier, Rainer Oder

Handelsregister: Amtsgericht Freiburg i.Br., HRB 705237
Sitz der Gesellschaft: Roggenbachstrasse 6, 78050 Villingen-Schwenningen
USt-Id Nummer: DE268786819

Confidentiality Notice: This e-mail message, including any attachments, is for the sole use of the intended recipient(s) and may contain confidential and privileged information. Any unauthorized review, use, disclosure or distribution is prohibited. If you are not the intended recipient, please contact the sender by return e-mail and destroy all copies of the original message.

-----Ursprüngliche Nachricht-----
Von: Ingo Molnar [mailto:mingo@elte.hu]
Gesendet: Donnerstag, 18. November 2010 19:57
An: Reichert, Hans-Peter
Cc: linux-kernel@vger.kernel.org; Peter Zijlstra; Thomas Gleixner; Arnaldo Carvalho de Melo; Frédéric Weisbecker
Betreff: Re: [patch] trace: Add user-space event tracing/injection


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
> >     prctl(35, "My Trace Message");
> >     ...
> >
> >     if (asprintf(&msg, "My Trace Message: %d\n", 1234) != -1) {
> >             prctl(35, *msg);
> >             free(*msg);
> >     }
> >
> > Thanks,
> >
> >     Ingo
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
>               __entry->ev_type = dtype;
>               memcpy(__get_dynamic_array(ev_data), bytes, dlen);
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

I agree.
The reason for this was to have a format description that could be used within "trace-cmd report"
without having the need to implement a separate decoder for (each) user land application.
I did a lot of system tracing for the last 10years on a different 'NX system.
>From an analysts sight it is more than just convenience that the tracing format is the same for every application,
just think of a system that is build up of binaries of several suppliers - like it will be in automotive projects.
Having a uniform format description would highly increase usage and acceptance.

Thanks
/hp




