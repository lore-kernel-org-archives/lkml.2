Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0LQUIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:08:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab0LQUIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:08:19 -0500
Date: Fri, 17 Dec 2010 15:07:38 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 1/2] jump label: make enable/disable o(1)
Message-ID: <20101217200738.GA4736@redhat.com>
References: <1292526602.2708.57.camel@laptop>
 <20101216192303.GB2856@redhat.com>
 <1292528031.2708.77.camel@laptop>
 <20101216193635.GC2856@redhat.com>
 <1292528501.2708.80.camel@laptop>
 <20101216194852.GD2856@redhat.com>
 <20101216203603.GA15610@Krystal>
 <1292532221.2708.93.camel@laptop>
 <20101216205043.GB18095@Krystal>
 <1292532985.2708.97.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292532985.2708.97.camel@laptop>
User-Agent: Mutt/1.5.20 (2010-07-18)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 09:56:25PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-12-16 at 15:50 -0500, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Thu, 2010-12-16 at 15:36 -0500, Mathieu Desnoyers wrote:
> > > > Tracepoints keep their own reference counts for enable/disable, so a
> > > > simple "enable/disable" is fine as far as tracepoints are concerned. Why
> > > > does perf need that refcounting done by the static jumps ?
> > > 
> > > Because the refcount is all we have... Why not replace that tracepoint
> > > refcount with the jumplabel thing?
> > 
> > The reason why tracepoints need to keep their own refcount is because
> > they support dynamically loadable modules, and hence the refcount must
> > be kept outside of the modules, in a table internal to tracepoints,
> > so we can attach a probe to a yet unloaded module. Therefore, relying on
> > this lower level jump label to keep the refcount is not appropriate for
> > tracepoints, because the refcount only exists when the module is live.
> 
> That's not a logical conclusion, you can keep these jump_label keys
> outside of the module just fine.
> 
> > I know that your point of view is "let users of modules suffer", but
> > this represents a very large portion of Linux users I am not willing to
> > let suffer knowingly.
> 
> Feh, I'd argue to remove this special tracepoint crap, the only
> in-kernel user (ftrace) doesn't even make use of it. This weird ass
> tracepoint semantic being different from the ftrace trace_event
> semantics has caused trouble before.
> 
> 

Hi,

since atomic_t is just an 'int' from include/linux/types.h, so for all
arches. We can cast any refernces to an atomic_t in
include/linux/jump_label_ref.h

So for when jump labels are disabled case we could have
one struct:

struct jump_label_key {
	int state;
}

and then we could then have (rough c code):

jump_label_enable(struct jump_label_key *key)
{
	key->state = 1;
}

jump_label_disable(struct jump_label_key *key)
{
	key->state = 0;
}

jump_label_inc(struct jump_label_key *key)
{
	atomic_inc((atomic_t *)key)
}

jump_label_dec(struct jump_label_key *key)
{
	atomic_dec((atomic_t *)key)
}

bool unlikely_switch(struct jump_label_key *key)
{
	if (key->state)
		return true;
	return false;
}

bool unlikely_switch_atomic(struct jump_label_key *key)
{
	if (atomic_read((atomic_t *)key)
		return true;
	return false;
}

can we agree on something like this?

thanks,

-Jason	
