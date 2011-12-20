Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab1LTQd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 11:33:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33273 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab1LTQdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 11:33:22 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=IWQx1ipMXh4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=u05ZfjYB_MsMVEKyik8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324398799.5916.57.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv2 02/10] ftrace: Change mcount call replacement logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Tue, 20 Dec 2011 11:33:19 -0500
In-Reply-To: <20111220131019.GA4393@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-3-git-send-email-jolsa@redhat.com>
	 <1324321380.5916.26.camel@gandalf.stny.rr.com>
	 <20111220131019.GA4393@m.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 14:10 +0100, Jiri Olsa wrote:

> let me try with an example..
> 
> say we have only 2 traceable functions - A and B ;)
> 
> 1) set global filter for function A with 'echo A > ./set_ftrace_filter'
> 	a - A is put to the global_ops filter
> 
> 2) enable function trace with 'echo function > current_tracer'
> 	a - register_ftrace_function is called with function trace ftrace_ops (GLOBAL flag)
> 	b - update_ftrace_function is called, setting ftrace_ops callback function
> 	    to be called directly from the assembly entry_* code
> 	c - ftrace_hash_rec_enable is called, and dyn_ftrace record
> 	    for function A is updated:
> 		A::flags|FL_MASK = 1
> 	d - ftrace_replace_code(1) is called, and function A is
> 	    brought in to life
> 
> 3) enable function trace via perf ftrace_ops
> 	a - register_ftrace_function is called with perf event ftrace_ops (!GLOBAL flag)
> 	b - update_ftrace_function is called, setting ftrace_ops_list_func
> 	    function to be called from the assembly entry_* code and
> 	    handle the ftrace_ops' dispatch
> 	c - ftrace_hash_rec_enable is called, and A and B dyn_ftrace records
> 	    are updated:
> 		A::flags|FL_MASK = 2
> 		B::flags|FL_MASK = 1
> 	d - ftrace_replace_code(1) is called, and function B is
> 	    brought in to life
> 
> 4) disable function trace via perf ftrace_ops
> 	a - unregister_ftrace_function is called with perf event ftrace_ops (same as in step 3)
> 	b - update_ftrace_function is called, setting global ftrace_ops (from step 2)
> 	    callback function to be called directly from the assembly entry_* code
> 	c - ftrace_hash_rec_disable is called, and A and B dyn_ftrace
> 	    records are updated:
> 		A::flags|FL_MASK = 1
> 		B::flags|FL_MASK = 0
> 	d - ??? see below..
> 
> Now, only the global function trace ftrace_ops is enabled (from step 2),
> but both A and B are alive and feeding the tracer despite its filter (function A),
> because its ftrace_ops is directly linked to the assembly entry_* code (step 4b).
> 
> The reason is that even though we updated the B's dyn_ftrace record (step 4c)
> to be 'B::flags|FL_MASK == 0', we did not update the B call itself and disable it.
> 
> If we'd call ftrace_replace_code(1) at 4d), the B function would be
> disabled, and we would get expected behaviour.
> 
> So thats the reason I think we should update the calls (mcount call code)
> each time we unregister the ftrace_ops, because some records could be
> enabled only for the specific ftrace_ops and we need to put them down
> when we disable this ftrace_ops.
> 
> 
> hopefully it make any sense.. :)

Ah, OK, I am able to trigger this. I see what you mean. Yeah, now that
we have a counter, it should enable/disable based on the counter. And
the DISABLE is still needed for just the "disable regardless"
 (/proc/sys/kernel/ftrace_enabled = 0).

I'll apply your patch and see how it works. Thanks!

-- Steve


