Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab0D2ACZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:02:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab0D2ACY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:02:24 -0400
X-Authority-Analysis: v=1.1 cv=2/WNtoURsBD4grC4Rqfj62/w1mAETqRJkFX1sgq41IM= c=1 sm=0 a=khrRrPIfVHAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=mgbnEd0IpD6ylQE4d5EA:9 a=gI8YRLMvH6J6JAFFuCEA:7 a=LvVJhPn1zesgmkuGBzTlTXr5kboA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 05/10][RFC] tracing: Move fields from event to class
 structure
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20100428205803.GF8591@Krystal>
References: <20100426195024.256424113@goodmis.org>
	 <20100426200242.470116062@goodmis.org>  <20100428205803.GF8591@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 28 Apr 2010 20:02:22 -0400
Message-ID: <1272499342.9739.88.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 16:58 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Move the defined fields from the event to the class structure.
> > Since the fields of the event are defined by the class they belong
> > to, it makes sense to have the class hold the information instead
> > of the individual events. The events of the same class would just
> > hold duplicate information.
> > 
> > After this change the size of the kernel dropped another 8K:
> > 
> >    text	   data	    bss	    dec	    hex	filename
> > 5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
> > 5774316	1306580	9351592	16432488	 fabd68	vmlinux.reg
> > 5774503	1297492	9351592	16423587	 fa9aa3	vmlinux.fields
> > 
> > Although the text increased, this was mainly due to the C files
> > having to adapt to the change. This is a constant increase, where
> > new tracepoints will not increase the Text. But the big drop is
> > in the data size (as well as needed allocations to hold the fields).
> > This will give even more savings as more tracepoints are created.
> > 
> > Note, if just TRACE_EVENT()s are used and not DECLARE_EVENT_CLASS()
> > with several DEFINE_EVENT()s, then the savings will be lost. But
> > we are pushing developers to consolidate events with DEFINE_EVENT()
> > so this should not be an issue.
> > 
> > The kprobes define a unique class to every new event, but are dynamic
> > so it should not be a issue.
> > 
> > The syscalls however have a single class but the fields for the individual
> > events are different. The syscalls use a metadata to define the
> > fields. I moved the fields list from the event to the metadata and
> > added a "get_fields()" function to the class. This function is used
> > to find the fields. For normal events and kprobes, get_fields() just
> > returns a pointer to the fields list_head in the class. For syscall
> > events, it returns the fields list_head in the metadata for the event.
> 
> So, playing catch-up here, why don't we simply put each syscall event in
> their own class ? We could possibly share the class where it makes
> sense (e.g. exact same fields).

Well, they have their own class. But I guess you are talking about a
"meta-data class".

> 
> With the per-class sub-metadata, what's the limitations we have to
> expect with these system call events ? Can we map to a field size
> directly from the event ID, or do we have to somehow have the event size
> encoded in the header to make sense of the payload ?

That will be a lot of work. This is all generated automatically from the
SYSCALL() macros. To group them, we need a way to know what syscalls
have the same parameters, and manually add that. It may end up being a
maintenance nightmare.

-- Steve


