Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2GQUDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:03:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40066 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab2GQUDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:03:36 -0400
Date: Tue, 17 Jul 2012 13:01:30 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 3/8] pstore: Add persistent function tracing
Message-ID: <20120717200130.GA31678@lizard>
References: <20120710001004.GA22744@lizard>
 <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org>
 <1342553898.10332.9.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1342553898.10332.9.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 03:38:18PM -0400, Steven Rostedt wrote:
[...]
> > +void notrace pstore_ftrace_call(unsigned long ip, unsigned long parent_ip)
> 
> BTW, you can make the entire file 'notrace' without adding annotations
> by including in the Makefile:
> 
> CFLAGS_REMOVE_ftrace.o = -pg

Actually it was in the first version in the patch, but then I changed
it 'notrace' for just this func. This is for the case if the file would
contain some more code which we actually may trace. Doing things fine-
grained seemed to be better than making the whole file as notrace. Plus
it is one line less. :-)

But I have no preference, so I can change it.

> > +{
> > +	struct pstore_ftrace_record rec = {};
> > +
> > +	if (unlikely(oops_in_progress))
> > +		return;
> > +
> > +	rec.ip = ip;
> > +	rec.parent_ip = parent_ip;
> > +	pstore_ftrace_encode_cpu(&rec, raw_smp_processor_id());
> > +	psinfo->write_buf(PSTORE_TYPE_FTRACE, 0, NULL, 0, (void *)&rec,
> > +			  sizeof(rec), psinfo);
> > +}
> 
> BTW, can any of the called functions go into module code that can be
> removed? If so, then this is not safe at all. Normal function tracing
> can not be synced in a preemptible kernel.

Um. Yes, psinfo->write_buf() might be in the module. Nice catch.

> Also, I'm starting to wonder if this should be in its own utility
> (separate debugfs?) than hooking directly into ftrace. Then you don't
> need to modify ftrace at all and you can do the following:
> 
> static struct ftrace_ops trace_ops {
> 	.func = pstore_ftrace_call;
> };
> 
> then in your write to debugfs file:
> 
> 	register_ftrace_function(&trace_ops);
> 
> To turn off tracing:
> 
> 	unregister_ftrace_function(&trace_ops);
> 
> Note, it's safe to use if the trace_ops (or anything the callback calls)
> is a module. That's because it detects the trace_ops is not kernel core
> code and will place a wrapper around it that allows the function tracing
> to by synced with module unload. You still need to unregister the
> trace_ops before unloading the module, or you can have a crash that way.

Hehe. Like this? http://lkml.org/lkml/2012/5/26/80 :-D

So, do you want something like this, but combinded: we don't register
another tracer, but register our own ftrace_ops? This sounds doable.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
