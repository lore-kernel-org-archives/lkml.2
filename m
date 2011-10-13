Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab1JMQcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:32:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:44694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab1JMQci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:32:38 -0400
Subject: Re: [PATCH RFC V4 06/10] jump_label: add
 arch_jump_label_transform_static() to optimise non-live code updates
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, rth@redhat.com
Date: Thu, 13 Oct 2011 18:32:05 +0200
In-Reply-To: <20111013155553.GD2455@redhat.com>
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
	 <16f652166605c973e9817177b6ba6a081e3e5b3f.1318464413.git.jeremy.fitzhardinge@citrix.com>
	 <1318501954.24856.5.camel@twins> <20111013135439.GA2455@redhat.com>
	 <1318519758.27731.15.camel@twins> <20111013155553.GD2455@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318523526.27731.18.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-13 at 11:55 -0400, Jason Baron wrote:
> > I actually need them to be either way.. no preference between on or off
> > just a means of very _very_ infrequent runtime change in behaviour.
> > 
> 
> ok, this is a new use case, all the current users are biased with gcc
> out-of-lining the infrequent case.

Right, 

> > If we can push jump_label init to before sched_init() all I need is a
> > static_branch() without the unlikely() in to avoid GCC out-of-lining the
> > branch.
> > 
> 
> hmmm....the current code (I believe) is biased  b/c gcc sees the
> branch as always false, see: arch_static_branch() - its not b/c we have
> an unlikely there. Without open coding the label, like we had before
> everybody hated, I'll have to play around and see what will create an
> unbiased branch...perhaps, somebody has an idea? 

Fix gcc and stick an unlikely in static_branch() ? :-)

> > > and by patching them early
> > > like this, at least for x86, we can avoid the stop machine calls. So its
> > > the combination of most are expected to be off and no sense to call extra
> > > stop machines that lead the code to its present state.
> > 
> > But we could use arch_jump_label_transform_static because its before we
> > actually execute any module text (sans the arg crap) which is
> > stomp-machine free, removing that obstacle.
> > 
> > Or am I confused more?
> > 
> 
> The MODULE_COMING callback happens *after* the call to flush_module_icache(mod),
> so I'm not sure that is safe... 

We can issue another one of those?
