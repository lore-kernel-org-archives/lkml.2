Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0IHGpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:45:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56804 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab0IHGo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:44:58 -0400
Date: Wed, 8 Sep 2010 08:44:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>, Avi Kivity <avi@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100908064427.GD3439@elte.hu>
References: <4C84D77B.6040600@redhat.com>
 <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
 <20100906154737.GA4332@elte.hu>
 <4C852B2A.2030103@redhat.com>
 <20100907034417.GA14046@elte.hu>
 <20100908014409.GA17010@brick.ozlabs.ibm.com>
 <AANLkTi=YdAxdGv1nEEZ4w0jM0K3ss0g5x7_5cU8xNEhj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=YdAxdGv1nEEZ4w0jM0K3ss0g5x7_5cU8xNEhj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0059]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> 2010/9/8 Paul Mackerras <paulus@samba.org>:
> >> We start with trivial (and useless) special case of something like:
> >>
> >> #define MAX_BYTECODE_SIZE 256
> >>
> >> int x86_bytecode_verify(char *opcodes, unsigned int len)
> >> {
> >>
> >>       if (len-1 > MAX_BYTECODE_SIZE-1)
> >>               return -EINVAL;
> >>
> >>       if (opcodes[0] != 0xc3) /* RET instruction */
> >>               return -EINVAL;
> >>
> >>       return 0;
> >> }
> >>
> >> ... and then we add checks for accepted/safe x86 patterns of
> >> instructions step by step - always keeping it 100% correct.
> >
> > So... I would be interested to see you add the case for the MOV
> > instruction. :)
> 
> Heh, which one of them - there are tons of variants under 'mov' on 
> x86? On a more serious note: the biggest problem is that you need to 
> do verification during execution because you don't know the exact 
> address until then for most addressing modes that use registers.

Well, the main model and usecase would be to provide some sort of 
function (in the mathematical sense), which is dependent on fixed-size 
input and stores a fixed-size output somewhere.

For that category to restrict both the input and output space initially, 
wouldnt be a big restriction. I.e. dont allow register addresses, only 
stack addresses or fixed addresses to the user-space parameter space.

These functions are supposed to be short and generally they dont change 
state (they dont have access to locking in any case - we want to be able 
to call them from atomic contexts, etc.).

Thus instructions like 'mov (%rax), ...' would be handled by not 
allowing them, only addresses which do not change from execution state.

That still gives plenty of flexibility to implement filters or other 
kinds of input/output calculation/netfilter-rule kind of logic.

Do you know some interesting usecase that would be excluded via such 
address restrictions? Things like flexible arrays or more complex data 
structures such as trees couldnt be used initially. More complex data 
structures would need locking in any case.

I.e. it would initially be restricted roughly to code where halting can 
be proven. Still looks interesting to me: most netfilter policy rules, 
trace filters or selinux rules could be implemented that way - an order 
of magnitude or two faster than the ad-hoc tracing, avc or iptables rule 
engines ...

Thanks,

	Ingo
