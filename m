Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0CZBa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:30:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab0CZBa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:30:28 -0400
Date: Fri, 26 Mar 2010 02:30:40 +0100
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 01/18] trace: Allow <linux/tracepoint.h> to create
 empty tracepoints
Message-ID: <20100326013039.GM3145@quack.suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
 <1269304340-25372-2-git-send-email-jack@suse.cz>
 <1269306409.2957.330.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269306409.2957.330.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-03-10 21:06:49, Steven Rostedt wrote:
> And I thought I was nasty with the CPP macros ;-)
  Yeah, this is the darkest magic I've ever conceived with CPP ;)

...
> > -#define DEFINE_TRACE_FN(name, reg, unreg)
> > -#define DEFINE_TRACE(name)
> > -#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
> > -#define EXPORT_TRACEPOINT_SYMBOL(name)
> > +#define DEFINE_TRACE_FN_0(name, reg, unreg)
> > +#define DEFINE_TRACE_0(name)
> > +#define EXPORT_TRACEPOINT_SYMBOL_GPL_0(name)
> > +#define EXPORT_TRACEPOINT_SYMBOL_0(name)
> > +
> > +/*
> > + * Below two-level macro magic is really needed to propely expand TRACE_CONFIG
> > + * macro to 0 or 1 in the end
> 
> This is a really lame comment. There should be almost as much comments
> as code when doing CPP trickery like this.
  OK, I'll expand it with a bit of CPP theory about argument expansion.

> > + */
> > +#define __DECLARE_TRACE(config, name, proto, args) \
> > +		DECLARE_TRACE_##config(name, PARAMS(proto), PARAMS(args))
> > +#define __DEFINE_TRACE_FN(config, name, reg, unreg) \
> > +			DEFINE_TRACE_FN_##config(name, reg, unreg)
> > +#define __DEFINE_TRACE(config, name) DEFINE_TRACE_##config(name)
> > +#define __EXPORT_TRACEPOINT_SYMBOL_GPL(config, name) \
> > +			EXPORT_TRACEPOINT_SYMBOL_GPL_##config(name)
> > +#define __EXPORT_TRACEPOINT_SYMBOL(config, name) \
> > +			EXPORT_TRACEPOINT_SYMBOL_##config(name)
> > +
> > +#define _DECLARE_TRACE(config, name, proto, args) \
> > +		__DECLARE_TRACE(config, name, PARAMS(proto), PARAMS(args))
> > +#define _DEFINE_TRACE_FN(config, name, reg, unreg) \
> > +			__DEFINE_TRACE_FN(config, name, reg, unreg)
> > +#define _DEFINE_TRACE(config, name) __DEFINE_TRACE(config, name)
> > +#define _EXPORT_TRACEPOINT_SYMBOL_GPL(config, name) \
> > +			__EXPORT_TRACEPOINT_SYMBOL_GPL(config, name)
> > +#define _EXPORT_TRACEPOINT_SYMBOL(config, name) \
> > +			__EXPORT_TRACEPOINT_SYMBOL(config, name)
> > +
> > +#define DECLARE_TRACE(name, proto, args) \
> > +		_DECLARE_TRACE(TRACE_CONFIG, name, PARAMS(proto), PARAMS(args))
> > +#define DEFINE_TRACE_FN(name, reg, unreg) \
> > +			_DEFINE_TRACE_FN(TRACE_CONFIG, name, reg, unreg)
> > +#define DEFINE_TRACE(name) _DEFINE_TRACE(TRACE_CONFIG, name)
> > +#define EXPORT_TRACEPOINT_SYMBOL_GPL(name) \
> > +			_EXPORT_TRACEPOINT_SYMBOL_GPL(TRACE_CONFIG, name)
> > +#define EXPORT_TRACEPOINT_SYMBOL(name) \
> > +			_EXPORT_TRACEPOINT_SYMBOL(TRACE_CONFIG, name)
...
> >  /*
> > + * The two chunks below are out of include file ifdef protection because
> > + * we want to be able to define TRACE_CONFIG even before second or even
> > + * later include of linux/tracepoint.h.
> > + */
> > +/*
> > + * Make tracepoints which are not converted to a new method of enabling
> > + * always compiled in
> > + */
> > +#ifndef TRACE_CONFIG
> > +#define TRACE_CONFIG 1
> > +#endif
> 
> Hmm, We can have tracepoints in a header. Would this still work if a
> header with a tracepoint was not converted but it was included in a file
> that was. Of course I haven't seen the other patches yet so I don't yet
> know what a conversion looks like.
  Well, if TRACE_CONFIG is not defined while the header is included,
everything is fine. If TRACE_CONFIG would be defined, then it means that
TRACE_SYSTEM is defined as well (I tried to define them at the same place)
and thus either tracepoints belong to the same system - again fine - or
they belong to a different system. But then the header would redefine
TRACE_SYSTEM which would subsequently break the file which included the
header. So what I do should work, unless TRACE_SYSTEM is already broken...
  Maybe I can expand the reasoning in the comment.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
