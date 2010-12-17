Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab0LQVMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 16:12:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab0LQVM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 16:12:28 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=sESGoGjSBwoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Un_KozB5vK8dKsD_cB4A:9 a=ys3WHognUGhlIgeq040A:7 a=1G6QN08U1giYlpNmx8QLa9N_bN8A:4 a=PUjeQqilurYA:10 a=FVnk07HAnIrHtmMg:21 a=FhAFJzQat1pibfGy:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH/RFC 1/2] jump label: make enable/disable o(1)
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <4D0BCD60.3030007@caviumnetworks.com>
References: <1292526602.2708.57.camel@laptop>
	 <20101216192303.GB2856@redhat.com> <1292528031.2708.77.camel@laptop>
	 <20101216193635.GC2856@redhat.com> <1292528501.2708.80.camel@laptop>
	 <20101216194852.GD2856@redhat.com> <20101216203603.GA15610@Krystal>
	 <1292532221.2708.93.camel@laptop> <20101216205043.GB18095@Krystal>
	 <1292532985.2708.97.camel@laptop> <20101217200738.GA4736@redhat.com>
	 <4D0BCD60.3030007@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 17 Dec 2010 16:12:21 -0500
Message-ID: <1292620341.22905.17.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 12:51 -0800, David Daney wrote:
> On 12/17/2010 12:07 PM, Jason Baron wrote:

> Not acceptable I would think.
> 
> How about:
> 
> union fubar {
>     int key_as_non_atomic;
>     atomic_t key_as_atomic;
> };

I don't even like this union.

> 
> Now explain the exact semantics of this thing including how you 
> guarantee no conflicting accesses *ever* occur.

I don't like the mixed semantics at all.

> 
> 
> > So for when jump labels are disabled case we could have
> > one struct:
> >
> > struct jump_label_key {

	atomic_t state;

> > }
> >
> > and then we could then have (rough c code):
> >
> > jump_label_enable(struct jump_label_key *key)
> > {

	if (atomic_read(&key->state))
		return;
	atomic_inc(&key->state);

> > }
> >
> > jump_label_disable(struct jump_label_key *key)
> > {

	if (!atomic_read(&key->state))
		return;
	atomic_dec(&key->state);
	WARN_ON(atomic_read(&key->state);

> > }
> >
> > jump_label_inc(struct jump_label_key *key)
> > {

 	atomic_inc(&key->state)

> > }
> >
> > jump_label_dec(struct jump_label_key *key)
> > {

 	atomic_dec((&key->state)

> > }
> >
> > bool unlikely_switch(struct jump_label_key *key)
> > {

 	if (atomic_read(&key->state))

> > 		return true;
> > 	return false;
> > }
> >

There, now you are guaranteed that you have proper semantics.

> >
> > can we agree on something like this?
> 
> I get a sick feeling whenever casting is used to give types with well 
> defined semantics (atomic_t) poorly defined semantics (your usage).

Exactly, I like to avoid (void*) anything or even worse, casting one
type to another for some strange semantics. This is guaranteed nightmare
of maintenance.

-- Steve


