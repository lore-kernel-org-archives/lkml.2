Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2GQVi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:38:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab2GQVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:38:26 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=JxQDdpYhMz0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=D19gQVrFAAAA:8 a=kxFl2u3rs5Lt9Cahi0AA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342561102.10332.18.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/8] pstore: Add persistent function tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
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
Date: Tue, 17 Jul 2012 17:38:22 -0400
In-Reply-To: <20120717200130.GA31678@lizard>
References: <20120710001004.GA22744@lizard>
	 <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org>
	 <1342553898.10332.9.camel@gandalf.stny.rr.com>
	 <20120717200130.GA31678@lizard>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 13:01 -0700, Anton Vorontsov wrote:
> On Tue, Jul 17, 2012 at 03:38:18PM -0400, Steven Rostedt wrote:
> [...]
> > > +void notrace pstore_ftrace_call(unsigned long ip, unsigned long parent_ip)
> > 
> > BTW, you can make the entire file 'notrace' without adding annotations
> > by including in the Makefile:
> > 
> > CFLAGS_REMOVE_ftrace.o = -pg
> 
> Actually it was in the first version in the patch, but then I changed
> it 'notrace' for just this func. This is for the case if the file would
> contain some more code which we actually may trace. Doing things fine-
> grained seemed to be better than making the whole file as notrace. Plus
> it is one line less. :-)
> 
> But I have no preference, so I can change it.

I have no preference, it was just an FYI. For just a single function in
a file, it really makes no difference which you use. The Makefile trick
is better for needing to make sure an entire file is not traced.


> 
> > > +{
> > > +	struct pstore_ftrace_record rec = {};
> > > +
> > > +	if (unlikely(oops_in_progress))
> > > +		return;
> > > +
> > > +	rec.ip = ip;
> > > +	rec.parent_ip = parent_ip;
> > > +	pstore_ftrace_encode_cpu(&rec, raw_smp_processor_id());
> > > +	psinfo->write_buf(PSTORE_TYPE_FTRACE, 0, NULL, 0, (void *)&rec,
> > > +			  sizeof(rec), psinfo);
> > > +}
> > 
> > BTW, can any of the called functions go into module code that can be
> > removed? If so, then this is not safe at all. Normal function tracing
> > can not be synced in a preemptible kernel.
> 
> Um. Yes, psinfo->write_buf() might be in the module. Nice catch.
> 
> > Also, I'm starting to wonder if this should be in its own utility
> > (separate debugfs?) than hooking directly into ftrace. Then you don't
> > need to modify ftrace at all and you can do the following:
> > 
> > static struct ftrace_ops trace_ops {
> > 	.func = pstore_ftrace_call;
> > };
> > 
> > then in your write to debugfs file:
> > 
> > 	register_ftrace_function(&trace_ops);
> > 
> > To turn off tracing:
> > 
> > 	unregister_ftrace_function(&trace_ops);
> > 
> > Note, it's safe to use if the trace_ops (or anything the callback calls)
> > is a module. That's because it detects the trace_ops is not kernel core
> > code and will place a wrapper around it that allows the function tracing
> > to by synced with module unload. You still need to unregister the
> > trace_ops before unloading the module, or you can have a crash that way.
> 
> Hehe. Like this? http://lkml.org/lkml/2012/5/26/80 :-D
> 
> So, do you want something like this, but combinded: we don't register
> another tracer, but register our own ftrace_ops? This sounds doable.

Yeah, the combined. That is, don't make a tracer out of it. Use another
mechanism to enable the tracing and not as a tracer
in /debug/tracing/available_tracers. We can probably set up events for
you too, but at a later time.

-- Steve

