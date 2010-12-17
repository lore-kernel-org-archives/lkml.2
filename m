Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0LQVdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 16:33:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab0LQVdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 16:33:01 -0500
Date: Fri, 17 Dec 2010 16:32:27 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 1/2] jump label: make enable/disable o(1)
Message-ID: <20101217213226.GA5597@redhat.com>
References: <20101216193635.GC2856@redhat.com>
 <1292528501.2708.80.camel@laptop>
 <20101216194852.GD2856@redhat.com>
 <20101216203603.GA15610@Krystal>
 <1292532221.2708.93.camel@laptop>
 <20101216205043.GB18095@Krystal>
 <1292532985.2708.97.camel@laptop>
 <20101217200738.GA4736@redhat.com>
 <4D0BCD60.3030007@caviumnetworks.com>
 <1292620341.22905.17.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292620341.22905.17.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2010-07-18)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 04:12:21PM -0500, Steven Rostedt wrote:
> > On 12/17/2010 12:07 PM, Jason Baron wrote:
> 
> > Not acceptable I would think.
> > 
> > How about:
> > 
> > union fubar {
> >     int key_as_non_atomic;
> >     atomic_t key_as_atomic;
> > };
> 
> I don't even like this union.
> 
> > 
> > Now explain the exact semantics of this thing including how you 
> > guarantee no conflicting accesses *ever* occur.
> 
> I don't like the mixed semantics at all.
> 
> > 
> > 
> > > So for when jump labels are disabled case we could have
> > > one struct:
> > >
> > > struct jump_label_key {
> 
> 	atomic_t state;
> 
> > > }
> > >
> > > and then we could then have (rough c code):
> > >
> > > jump_label_enable(struct jump_label_key *key)
> > > {
> 
> 	if (atomic_read(&key->state))
> 		return;
> 	atomic_inc(&key->state);
> 
> > > }
> > >
> > > jump_label_disable(struct jump_label_key *key)
> > > {
> 
> 	if (!atomic_read(&key->state))
> 		return;
> 	atomic_dec(&key->state);
> 	WARN_ON(atomic_read(&key->state);
> 
> > > }
> > >
> > > jump_label_inc(struct jump_label_key *key)
> > > {
> 
>  	atomic_inc(&key->state)
> 
> > > }
> > >
> > > jump_label_dec(struct jump_label_key *key)
> > > {
> 
>  	atomic_dec((&key->state)
> 
> > > }
> > >
> > > bool unlikely_switch(struct jump_label_key *key)
> > > {
> 
>  	if (atomic_read(&key->state))
> 
> > > 		return true;
> > > 	return false;
> > > }
> > >
> 

hmmm...we were trying to avoid having the atomic_read() for tracepoints
b/c of potential extra cost that Mathieu was concerned about.

> There, now you are guaranteed that you have proper semantics.
> 
> > >

The other issue here was that jump_label.h gets included by
asm/atomic.h, so there a dependency issue to be addressed here as
well....

thanks,

-Jason

