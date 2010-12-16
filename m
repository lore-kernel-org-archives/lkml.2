Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab0LPUS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:18:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0LPUS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:18:26 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=e0HnDPJeuhYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=ntYbDU86OBXf2Jg9UMUA:9 a=g6xVevMTq-TuRV4kLfsA:7 a=MRazIw4BG5kQWOi_VLuI2WEkCjgA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH/RFC 0/2] jump label: simplify API
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101216192241.GA8239@Krystal>
References: <cover.1292522251.git.jbaron@redhat.com>
	 <20101216192241.GA8239@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Dec 2010 15:18:23 -0500
Message-ID: <1292530703.22905.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 14:22 -0500, Mathieu Desnoyers wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
> > Hi,
> > 
> > The first patch uses the storage space of the jump label key address
> > as a pointer into the update table. In this way, we can find all
> > the addresses that need to be updated without hashing.
> > 
> > The second patch introduces:
> > 
> > static __always_inline bool unlikely_switch(struct jump_label_key *key);
> > 
> > instead of the old JUMP_LABEL(key, label) macro.
> > 
> > In this way, jump labels become really easy to use:
> > 
> > Define:
> > 
> > 	struct jump_label_key jump_key;
> > 
> > Can be used as:
> > 
> > 	if (unlikely_switch(&jump_key))
> > 		do unlikely code
> 
> Ah, yes, that's an improvement!
> 
> I'm just wondering about the terminology here. Isn't that more a
> "branch" than a "switch" ?
> 
> I'm concerned about the fact that if we ever want to use the asm goto
> ability to jump to multiple targets (which is closer to a statically
> computed switch than a branch), we might want to reserve "switch" name
> for that rather than the branch.

Good point.

> 
> I wonder if the "if (unlikely_switch(&jump_key))" you propose above is
> the right thing to do. Why does the unlikely_ have to be included in the
> name ? Maybe there is a good reason for it, but it would be nice to have
> it spelled out. We might consider:
> 
> if (unlikely(static_branch(&jump_key)))
>   ...
> 
> instead.


Hmm, I see your point here too.


> For the switch statement, from the top of my head the idea would be to
> get something close to the following:
> 
> static __always_inline
> int static_switch_{3,4,5,6...}(struct jump_label_key *key);
> 
> e.g.:
> 
> static __always_inline
> int static_switch_3(struct jump_label_key *key)
> {
> 	asm goto("1:"
> 		JUMP_LABEL_INITIAL_NOP
> 		".pushsection __switch_table_3,  \"a\" \n\t"
> 		_ASM_PTR "%c0, 1b, %l[l_1], %l[l_2] \n\t"
> 		".popsection \n\t"
> 		: :  "i" (key) : : l_1, l_2 );
> 	return 0;
> l_1:
> 	return 1;
> l_2:
> 	return 2;
> }
> 
> switch(static_switch_3(&switch_key)) {
> 	case 0: .....
> 		break;
> 	case 1: .....
> 		break;
> 	case 2: .....
> 		break;
> }
> 
> (I have not tried to give that to gcc 4.5.x to see how the resulting
> assembly looks like. It would be interesting to see if it handles this
> case well)

Something to think about later (when we need such a thing). But I do
agree, perhaps calling it static_branch() instead, is a better idea.

-- Steve


