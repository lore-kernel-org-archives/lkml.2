Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab1JCPrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:47:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56835 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab1JCPr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:47:29 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=msyzJTVhAHgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=yaZdvZR3UvQ5Ywe43s0A:9 a=glSFNH00a4lcUjO01FwA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Date: Mon, 03 Oct 2011 11:47:26 -0400
In-Reply-To: <20111003150205.GB2462@redhat.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
	 <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
	 <20111003150205.GB2462@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317656848.17991.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 11:02 -0400, Jason Baron wrote:

> if (!enabled)
> 	arch_jump_label_transform(iter, JUMP_LABEL_DISABLE);
> 
> 
> > +		if (iterk == key)
> >  			continue;
> >  
> > -		key = (struct jump_label_key *)(unsigned long)iter->key;
> > -		atomic_set(&key->enabled, 0);
> > +		key = iterk;
> >  		key->entries = iter;
> >  #ifdef CONFIG_MODULES
> >  		key->next = NULL;
> > @@ -212,7 +208,7 @@ void jump_label_apply_nops(struct module *mod)
> >  		return;
> >  
> >  	for (iter = iter_start; iter < iter_stop; iter++)
> > -		arch_jump_label_text_poke_early(iter->code);
> > +		arch_jump_label_transform(iter, JUMP_LABEL_DISABLE);
> >  }
> >  
> >  static int jump_label_add_module(struct module *mod)
> > -- 
> > 1.7.6.2
> > 
> 
> hmmm...this is used on module load in smp - so this would introduce a number of
> calls to stop_machine() where we didn't have them before. Yes, module
> load is a very slow path to begin with, but I think its at least worth
> pointing out...

And it is a good point to point out. As stop_machine becomes noticeable
by users on large scale CPU boxes. Ideally, we want to avoid stopmachine
when we do not need it.

-- Steve


