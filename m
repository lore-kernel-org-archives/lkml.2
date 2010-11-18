Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143Ab0KRSkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:40:08 -0500
Received: from lo.gmane.org ([80.91.229.12]:45229 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760085Ab0KRSkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:40:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: hp <hp.reichert@xse.de>
Subject: Re: [patch] trace: Add user-space event tracing/injection
Date: Thu, 18 Nov 2010 16:25:09 +0000 (UTC)
Message-ID: <loom.20101118T170856-336@post.gmane.org>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <4CE38C53.8090606@kernel.org> <20101117120740.GA24972@elte.hu> <4CE47ED0.7080901@linux.intel.com> <20101118085513.GH26398@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 80.149.172.178 (Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.12) Gecko/20101026 Firefox/3.6.12 ( .NET CLR 3.5.30729; .NET4.0E))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo <at> elte.hu> writes:

> 
> 
> * Darren Hart <dvhart <at> linux.intel.com> wrote:
> 
> > Ideally I would like to see something just like trace_printf()
> > without having to define it myself in each of my testcases. [...]
> 
> We can make the prctl a single-argument thing, at the cost of not allowing \0
in the 
> content. (which is probably sane anyway)
> 
> That way deployment is super-simple:
> 
> 	prctl(35, "My Trace Message");
> 	...
> 
> 	if (asprintf(&msg, "My Trace Message: %d\n", 1234) != -1) {
> 		prctl(35, *msg);
> 		free(*msg);
> 	}
> 
> Thanks,
> 
> 	Ingo
> 
I like this approach - it is doing it nearly the same way I did it with an extra
k-mod (no patch needed) and a debugfs entry handled in that mod.
I only see one thing with the string only data - I am doing stuff where there
are long recording times with also a lot of user events,
in such an environment I need more semantics on the event contents.
In my k-mod solution there's an event ID and the opportunity to log binary data.
As prctl() has 4 additional args after the option, it would be possible to use
it in the following way:
prtctl( 35, int eventID, int data_type, int msglen, void *buf);
or without the data_type
prtctl( 35, int eventID, int msglen, void *buf);
decoding would be of more effort but it would be worth

The event definition would be like this (with data_type):

TRACE_EVENT(user,
        TP_PROTO(int id, int dtype, int dlen, unsigned char *bytes),
        TP_ARGS(id, dtype, dlen, bytes),
        TP_STRUCT__entry(
                __field(int, ev_id)
                __field(int, ev_type)
                __dynamic_array(unsigned char, ev_data, dlen)
        ),
        TP_fast_assign(
                __entry->ev_id = id;
		__entry->ev_type = dtype;
		memcpy(__get_dynamic_array(ev_data), bytes, dlen);
        ),

        TP_printk("ID: %d type: %s data: %s", __entry->ev_id,
__print_symbolic(__entry->ev_type, {0,"V"}, {1,"I"}, {2,"S"}, {4,"B"}),
__entry->ev_type == 0 ? "n/a" : __get_str(ev_data))
);


What do you think about this?
/hp

