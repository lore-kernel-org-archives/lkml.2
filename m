Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0EREtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 00:49:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55713 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab0EREtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 00:49:42 -0400
Message-ID: <4BF21CEE.9080801@cn.fujitsu.com>
Date: Tue, 18 May 2010 12:51:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Tom Zanussi <tzanussi@gmail.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 05/13 v3] tracing: Move fields from event to class structure
References: <20100514192246.079025623@goodmis.org> <20100514192914.920593596@goodmis.org>
In-Reply-To: <20100514192914.920593596@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Move the defined fields from the event to the class structure.
> Since the fields of the event are defined by the class they belong
> to, it makes sense to have the class hold the information instead
> of the individual events. The events of the same class would just
> hold duplicate information.
> 
> After this change the size of the kernel dropped another 3K:
> 
>    text	   data	    bss	    dec	    hex	filename
> 4913961	1088356	 861512	6863829	 68bbd5	vmlinux.orig
> 4900252	1057412	 861512	6819176	 680d68	vmlinux.regs
> 4900375	1053380	 861512	6815267	 67fe23	vmlinux.fields
> 

It also saves memory allocated by trace_define_field(). :)

> Although the text increased, this was mainly due to the C files
> having to adapt to the change. This is a constant increase, where
> new tracepoints will not increase the Text. But the big drop is
> in the data size (as well as needed allocations to hold the fields).
> This will give even more savings as more tracepoints are created.
> 
> Note, if just TRACE_EVENT()s are used and not DECLARE_EVENT_CLASS()
> with several DEFINE_EVENT()s, then the savings will be lost. But
> we are pushing developers to consolidate events with DEFINE_EVENT()
> so this should not be an issue.
> 
> The kprobes define a unique class to every new event, but are dynamic
> so it should not be a issue.
> 
> The syscalls however have a single class but the fields for the individual
> events are different. The syscalls use a metadata to define the
> fields. I moved the fields list from the event to the metadata and
> added a "get_fields()" function to the class. This function is used
> to find the fields. For normal events and kprobes, get_fields() just
> returns a pointer to the fields list_head in the class. For syscall
> events, it returns the fields list_head in the metadata for the event.
> 

All syscall exit events have the same fields. I'll make a patch for this.

