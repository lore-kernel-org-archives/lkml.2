Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab2K3BAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:00:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38271 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab2K3BAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:00:40 -0500
Date: Fri, 30 Nov 2012 02:00:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ian Kumlien <pomac@vapor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] NULL pointer dereference in 3.7-rc7 (syscall_trace_enter)
Message-ID: <20121130010035.GA5042@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ian Kumlien <pomac@vapor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1354144802.5396.3.camel@pi>
 <20121129092621.GA21100@liondog.tnic>
 <20121129122708.GA6365@pomac.netswarm.net>
 <20121129142220.GC30789@liondog.tnic>
 <20121129162403.GC6365@pomac.netswarm.net>
 <20121129192500.GG30789@liondog.tnic>
 <1354233368.5396.6.camel@pi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354233368.5396.6.camel@pi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 12:56:08AM +0100, Ian Kumlien wrote:
> > From looking at the code, task audit contexts get normally allocated
> > at fork time and dealloc'd at task exit time so your process should
> > actually have a valid task context.
> 
> Weird, and this should be allocated automatically?

Yes, during task creation in copy_process we do audit_alloc and in
do_exit() we do audit_free.

> > The only explanation I have is that it could be some random corruption
> > which f*cked up the ->audit_context pointer but I might be wrong. Btw,
> > do you have CONFIG_AUDITSYSCALL enabled in your kernel?
> 
> grep CONFIG_AUDITSYSCALL .config
> CONFIG_AUDITSYSCALL=y

Ok.

> > I'd say right now we could watch this and if it is reproducible, then
> > we can involve some more brain power and skills into it. If it has been
> > only a single occurrence, then we'll write it on the random corruption's
> > tab.
> 
> Uhmmm oki

Right, so thinking purely hypothetically I can imagine that there might
be some small window where we're in the process of freeing the audit
context during task exit and we issue a syscall which gets traced and we
end up in the audit_syscall_entry but AFAICT when we free the context,
we do get it and do tsk->audit_context = NULL which cannot explain the
funny ECX value. Hmm, strange.

But it doesn't bring a whole lot in us conjecturing what has happened if
this cannot be reliably reproduced so please watch your box and be on
alert for similar oopses and the steps you've made to cause them.

Thanks.

-- 
Regards/Gruss,
    Boris.
