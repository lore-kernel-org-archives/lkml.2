Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1AGQFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:05:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48177 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab1AGQFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:05:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cJTZ2AUe3STjoWZxeNq7r/G7Ak82Ev+C6MPdXM2Z70QrU2p9KZIz3afk4ApuaGK41n
         75mdtoJ4nP17karb6N2V8omCEJlPEn7B/wM5mLHzB6p+xBU5H51NpVoO15colGFBewVg
         sUWBiZ26ZIvphpLTWcEu/yIVL6h1MtWsHD+5M=
Date: Fri, 7 Jan 2011 17:05:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>,
        "H. Peter Anvin" <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Soeren Sandmann Pedersen <sandmann@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] x86: Fix rbp saving in pt_regs on irq entry
Message-ID: <20110107160459.GA2751@nowhere>
References: <4D25EB4B020000780002ABF7@vpn.id2.novell.com>
 <20110106154536.GA2308@nowhere>
 <4D25F79F020000780002AC20@vpn.id2.novell.com>
 <20110106162236.GB2308@nowhere>
 <4D25FE5B020000780002AC50@vpn.id2.novell.com>
 <20110106165452.GC2308@nowhere>
 <4D2602DE020000780002ACA3@vpn.id2.novell.com>
 <20110106171231.GD2308@nowhere>
 <4D26D2C2020000780002AECB@vpn.id2.novell.com>
 <20110107123130.GB20761@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107123130.GB20761@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 01:31:30PM +0100, Ingo Molnar wrote:
> 
> * Jan Beulich <JBeulich@novell.com> wrote:
> 
> > > Now I don't understand how this is all useful as this is not a normal proc but 
> > > an interruption. We can't get back the return address from the CFA. Or am I 
> > > missing something?
> > 
> > Unwind annotations, when written correctly, allow unwinding through all kinds of 
> > execution flows, including interrupts or exceptions as well as including stack 
> > switches.
> 
> Yeah and that's rather useful, as exception contexts can nest in very weird ways, 
> especially with NMIs involved. For example a 7-context combination is possible:
> 
>   user-space -> syscall -> pagefault -> softirq -> hardirq -> debug trap -> NMI
> 
> And the call frame walking logic needs to be able to get all the way back to 
> user-space ...
> 
> For that every transition needs to work flawlessly, for debugging (and CFI based 
> profiling) to work fine.
> 
> Most of those transitions can happen at any instruction boundary that a given 
> context executes, so the total number of possible combinations is virtually endless.
> 
> Unfortunately we dont seem to have a good way to test any of this automatically. 
> Putting a perf probe on every assembly instruction perhaps, and checking whether the 
> frame manages to go back all the way to user-space?

May be.

Once I'll have perf callchain based on CFI ready, we'll perhaps find some issues
there. Although I guess there are already tools that can make use of that.

> 
> Thanks,
> 
> 	Ingo
