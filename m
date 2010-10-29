Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab0J2OUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:20:36 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:43138 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932766Ab0J2OUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:20:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADp0ykxGGOIS/2dsb2JhbAChU3K+WYVIBA
Date: Fri, 29 Oct 2010 09:35:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        David Daney <ddaney@caviumnetworks.com>, rth@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, dsd@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
Message-ID: <20101029133524.GA23916@Krystal>
References: <cover.1288212485.git.jbaron@redhat.com> <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com> <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com> <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com> <20101028201112.GA4792@redhat.com> <20101029063450.GE29463@elte.hu> <1288354687.18238.433.camel@gandalf.stny.rr.com> <20101029122230.GA25663@elte.hu> <1288356418.18238.454.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1288356418.18238.454.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:33:16 up 204 days, 23:23,  3 users,  load average: 0.07, 0.13,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2010-10-29 at 14:22 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Fri, 2010-10-29 at 08:34 +0200, Ingo Molnar wrote:
> 
> > > Do you mean to have it dependent on !EMBEDDED, or perhaps !CC_OPTIMIZE_FOR_SIZE ?
> > 
> > CC_OPTIMIZE_FOR_SIZE dependency probably not. Might even leave out !EMBEDDED, to 
> > make it generally configurable.
> > 
> > Also, we should make it default off - we need to see whether there are any compiler 
> > bugs lurking.
> 
> Ah, so we should then add a:
> 
> config JUMP_LABEL
> 	prompt "Optimize trace point call sites"
> 	depends on HAVE_ARCH_JUMP_LABEL
> 	help
> 	  If it is detected that the compiler has support for
> 	  "asm goto", the kernel will compile trace points locations 
> 	  with just a nop instruction. When trace points are enabled
> 	  the nop will be converted to a jump to the trace function.
> 	  This technique lowers overhead and stress on the branch
> 	  prediction of the processor.
> 
> 	  On i386, the options added to make this work may increase
> 	  the size of the kernel slightly.
> 
> 
> Then in the code have:
> 
> -#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
> +#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL) \

Technically, you could remove the dependency on
"defined(CONFIG_HAVE_ARCH_JUMP_LABEL)", because it is now dealt with at
the Kconfig level (CONFIG_JUMP_LABEL depends on it).

> +	&& defined(JUMP_LABEL)

this would be defined(CONFIG_JUMP_LABEL)

The rest looks fine,

Thanks,

Mathieu

>  # include <asm/jump_label.h>
>  # define HAVE_JUMP_LABEL
>  #endif
> 
> 
> If you agree, I can write up a patch.
> 
> -- Steve
> 	  
> > 
> > > I can see people making a big stink about adding back a gcc option that makes the 
> > > kernel bigger.
> > 
> > Depends on exactly how much .text we are talking about here. Plus it would be 
> > default-off.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
