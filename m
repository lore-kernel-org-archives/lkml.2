Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab1CDIXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:23:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48549 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab1CDIXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:23:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WGELHSrTGjKeGPe4QFMgm4VioSO0Ox0Y/+uoeD93Rjji8TRCKnhcB6ANMD1/mSwMqf
         hpbOmNqV9bifh0tNFYax3OE6R2m/rFH3MXqJE5r2/rgU/AZ3d6dloKLPO7zi9Aneew9n
         RPk+j86A4+Q/FnztnEMD661YCPf7CxS56gxMY=
Date: Fri, 4 Mar 2011 09:23:29 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304082329.GA20499@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110303173422.GA27960@redhat.com>
 <20110303202246.GB32152@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303202246.GB32152@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Thu, Mar 03, 2011 at 09:22:46PM +0100, Oleg Nesterov wrote:
> On 03/03, Oleg Nesterov wrote:
> >
> > I'll ask the questions later.
> 
> Right now I do not see any holes (but I'll try more ;)

Heh, I'm sure you'll find some. :-)

> One question, to ensure I really understand you. To simplify,
> consider this particular example.
> 
> Tracee:
> 
> 	int main(void)
> 	{
> 		kill(SIGSTOP, getpid());
> 
> 		printf("I am running\n");
> 
> 		for (;;)
> 			;
> 	}
> 
> To simplify again, suppose that the debugger attaches when it is
> already stopped, then it does PTRACE_CONT(0).
> 
> In this case the tracee remains SIGNAL_STOP_STOPPED but prints
> "I am running" and enters the endless loop.
> 
> (the new debugger can do PTRACE_SEIZE after that and "return"
>  it to the stopped state without affecting jctl state).
> 
> Now, if SIGCONT comes (from anywhere) it clears SIGNAL_STOP_STOPPED,
> the tracee traps and reports this event to debugger.
> 
> Correct?

The notification of the end of job control stop (ie. emission of
SIGCONT) is probably the most hazy part and probably would change a
bit while implemented, but here are the baselines I have on mind.

* The notification of the job control stop itself is the only time
  that wait(2) reports the job control signal and the siginfo which
  was sent together.

* When job control stop ends, exit_code is changed to indicate ptrace
  trap and siginfo indicates the trap site and that job control stop
  is no long in effect.  This of course should wake up the tracer if
  it's wait(2)ing.

* The above requires another ptrace trap site which can probably
  shared with PTRACE_SEIZE.  The question is whether to make group
  stop state available for other trap sites too or just enable it in
  the new trap site.  ATM, I'm leaning toward the latter.

> And, once again. In the mt case, I assume that SIGCONT makes
> every traced thread to report this event individually, right?
>
> (I am talking about the case when the group-stop was finished,
>  iow "every" probably means the threads which participated and
>  reported CLD_STOPPED to the debugger).

Yeap, it's per-task ptrace trap which is broadcasted to every ptraced
task which participated in the group stop.

> In both cases, later then this SIGCONT will be reported again
> as any "normal" signal when some thread dequeues it.

Yeap, that's something which happens in the delivery path for SIGCONT.
It should behave the same (other than fixing notification to real
parent, that is).

> Is my understanding correct?

Yeap, seems pretty accurate.

Thank you.

-- 
tejun
