Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2GRNNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:13:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab2GRNNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:13:21 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=11o5cHuf_k4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=D19gQVrFAAAA:8 a=gYBBqiOridv46WGTgLIA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342617199.11900.5.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] pstore/ftrace: Convert to its own enable/disable
 debugfs knob
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
Date: Wed, 18 Jul 2012 09:13:19 -0400
In-Reply-To: <20120718072608.GA17026@lizard>
References: <20120710001004.GA22744@lizard>
	 <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org>
	 <1342553898.10332.9.camel@gandalf.stny.rr.com>
	 <20120717200130.GA31678@lizard>
	 <1342561102.10332.18.camel@gandalf.stny.rr.com>
	 <20120718034722.GA18081@lizard> <20120718072608.GA17026@lizard>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 00:26 -0700, Anton Vorontsov wrote:
> On Tue, Jul 17, 2012 at 08:47:22PM -0700, Anton Vorontsov wrote:
> [...]
> > -void notrace pstore_ftrace_call(unsigned long ip, unsigned long parent_ip)
> > +static void notrace pstore_ftrace_call(unsigned long ip,
> > +				       unsigned long parent_ip)
> >  {
> > +	unsigned long flags;
> >  	struct pstore_ftrace_record rec = {};
> >  
> > +	if (unlikely(!ftrace_enabled))
> > +		return;
> >  	if (unlikely(oops_in_progress))
> >  		return;
> >  
> > +	local_irq_save(flags);
> > +
> >  	rec.ip = ip;
> >  	rec.parent_ip = parent_ip;
> >  	pstore_ftrace_encode_cpu(&rec, raw_smp_processor_id());
> >  	psinfo->write_buf(PSTORE_TYPE_FTRACE, 0, NULL, 0, (void *)&rec,
> >  			  sizeof(rec), psinfo);
> 
> Btw, here we might be running w/o recurse protection, and that helped
> to find a bug in the persistent ram module.
> 
> The bug was quite subtle: it only happened if pstore tracing was
> enabled before any other tracers. And it magically disappeared
> otherwise.
> 
> This is because ftrace_ops_list_func() does its own recurse protection,
> but ftrace_ops_list_func() is only used when there are more than
> one 'struct ops' registered, otherwise ->func is called directly.
> 
> Of course, if I specify FL_GLOBAL/FL_CONTROL flag for the tracer,
> then it will not try to call the func directly. But then there is
> a question: do we really want to set these flags if we yet don't
> want removable modules?
> 
> Or, setting at least FL_CONTROL would be a good idea anyway, since
> it will then react to ftrace_function_local_{enable,disable}()?

I have a patch to fix this already. It's part of my kprobe/ftrace work.

The patch has been published here:

 https://lkml.org/lkml/2012/7/11/476

I'm hoping to get this ready for 3.6. Thus, don't worry about adding
recursion protection. ftrace should do that for you.

Thanks!

-- Steve


