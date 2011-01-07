Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1AGMbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 07:31:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44828 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab1AGMbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 07:31:41 -0500
Date: Fri, 7 Jan 2011 13:31:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Soeren Sandmann Pedersen <sandmann@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] x86: Fix rbp saving in pt_regs on irq entry
Message-ID: <20110107123130.GB20761@elte.hu>
References: <1294325513-14276-2-git-send-email-fweisbec@gmail.com>
 <4D25EB4B020000780002ABF7@vpn.id2.novell.com>
 <20110106154536.GA2308@nowhere>
 <4D25F79F020000780002AC20@vpn.id2.novell.com>
 <20110106162236.GB2308@nowhere>
 <4D25FE5B020000780002AC50@vpn.id2.novell.com>
 <20110106165452.GC2308@nowhere>
 <4D2602DE020000780002ACA3@vpn.id2.novell.com>
 <20110106171231.GD2308@nowhere>
 <4D26D2C2020000780002AECB@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D26D2C2020000780002AECB@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> > Now I don't understand how this is all useful as this is not a normal proc but 
> > an interruption. We can't get back the return address from the CFA. Or am I 
> > missing something?
> 
> Unwind annotations, when written correctly, allow unwinding through all kinds of 
> execution flows, including interrupts or exceptions as well as including stack 
> switches.

Yeah and that's rather useful, as exception contexts can nest in very weird ways, 
especially with NMIs involved. For example a 7-context combination is possible:

  user-space -> syscall -> pagefault -> softirq -> hardirq -> debug trap -> NMI

And the call frame walking logic needs to be able to get all the way back to 
user-space ...

For that every transition needs to work flawlessly, for debugging (and CFI based 
profiling) to work fine.

Most of those transitions can happen at any instruction boundary that a given 
context executes, so the total number of possible combinations is virtually endless.

Unfortunately we dont seem to have a good way to test any of this automatically. 
Putting a perf probe on every assembly instruction perhaps, and checking whether the 
frame manages to go back all the way to user-space?

Thanks,

	Ingo
