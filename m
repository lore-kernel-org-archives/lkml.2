Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1CBOn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:43:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51628 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab1CBOn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:43:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=xbpZ0idQH6gWWhk/Gp+3db9ZITZx4g+hnZlg0fLW+iJ0/zYNJjaUjoa5/sZ1gMQ7qp
         x8+e6DzVWAqi/j1xa+fyl7067nZg/K2L8Bx8yz8y+xEy2S8D9P9YEVcptd+caktmD3bp
         36GZZhCE5dFLecbCeCfUH6XHFZ3YJMYXRIs30=
Date: Wed, 2 Mar 2011 15:43:22 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110302144322.GJ3319@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <AANLkTi=cUM9S5M7h0unMfbQ88CzqhoDN9CUEVf_9HrdS@mail.gmail.com>
 <20110302073727.GD19669@htj.dyndns.org>
 <AANLkTimA8wtM4sJu1SMVuOaNXyxEtLcfaj7kJf2NovAd@mail.gmail.com>
 <20110302112756.GI3319@htj.dyndns.org>
 <AANLkTi=tQ0kLB_MiTArpNAWHUT0id_dbXXLu9UpPhRfN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=tQ0kLB_MiTArpNAWHUT0id_dbXXLu9UpPhRfN@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 02, 2011 at 12:48:56PM +0100, Denys Vlasenko wrote:
> > Of course, all ptrace traps are SIGTRAPs.
> 
> Except for those SIGSTOPs in children on auto-attach
> via PTRACE_O_TRACE[V]FORK / PTRACE_O_TRACECLONE options...

Aren't they just using SIGSTOP's to trigger signal delivery path?  The
signal can be delivered, right?  Checking the source code.... Yeah, it
genuinely generates SIGSTOP.

> >> Why not SIGCONT? This event is, after all, caused by SIGCONT.
> >> It would be so much nicer to be able to detect it with single if()
> >> in the debugger...
> >
> > I disagree.  It's a ptrace trap.  It should use SIGTRAP.  We just need
> > well defined siginfo output to distinguish between them.  It's not
> > like we can avoid siginfo anyway.
> 
> Performance problem here. Strace is already suffering from being
> rather slow, especially for multi-threaded processes.
> 
> So far strace was able to avoid querying siginfo on every stop.
> 
> In order to make job control stop work properly, it will now need
> to query siginfo, but only if signo==SIGSTOP. SIGSTOPs don't
> occur too often, definitely not twice per syscall as SIGTRAPs do,
> so it's not a problem.
> 
> With your proposal to show resume-from-job-control-stop-via-SIGCONT
> as SIGTRAP, *every* SIGTRAP stop needs to be followed
> by PTRACE_GETSIGINFO.

I don't think it's a good idea to make these basic design choices
based on optimization concerns like the above.  We're not talking
about read/write(2) here.  If PTRACE_GETSIGINFO really becomes that
much of a performance bottleneck, we can put it in vdso, but I really
doubt it would come to that.

> int main()
> {
>        signal(SIGSTOP, sig);
>        signal(SIGCONT, sig);
>        signal(SIGWINCH, sig);
>        signal(SIGABRT, sig);
>  again:
>        printf("PID: %d\n", getpid());
>        fflush(NULL);
>        errno = 0;
>        sleep(30);
>        int e = errno;
>        printf("after sleep: errno=%d %s\n", e, strerror(e));
>        if (e) goto again;
>        return 0;
> }
> 
> # ./a.out
> PID: 16382
>  <------ kill -STOP 16382
>  <------ kill -ABRT 16382
>  <------ kill -WINCH 16382
>  <------ kill -CONT 16382
> sig: 28 Window changed
> sig: 18 Continued
> sig: 6 Aborted
> after sleep: errno=4 Interrupted system call
> PID: 16382
> 
> 
> Therefore we also need to think about this aspect of SIGCONT behavior
> under debuggers.
> 
> Do we provide for the mechanism for debuggers to
> prevent execution of *SIGCONT userspace handler*?

Yeah, it's not different from any other signal.  Just squash the
signal when ptrace signal delivery trap is taken, which is completely
separate from termination of job control stop triggered by _emission_
of SIGCONT.  The two are separate.  The proposed changes don't affect
the delivery path at all.  I really can't understand what your point
is.

> And, looking at the example above, I see that on resume from stop,
> *SIGCONT userspace handler* actually doesn't run as *the first handler*
> after SIGCONT. Other pending signal's handlers may be executed before it.

Signal delivery is not FIFO.  There are some rules that the code
describes.  If you're interested, take a look at the code but in
general it would be better to avoid assuming fixed order between
signal generations and deliveries.

> How would the above example look under ptraced process? Particularly,
> this sequence:
>  <------ kill -STOP 16382
>  <------ kill -ABRT 16382
>  <------ kill -WINCH 16382
>  <------ kill -CONT 16382
> sig: 28 Window changed
> sig: 18 Continued
> sig: 6 Aborted

There's NO difference regarding signal delivery.  It stays the SAME.

Thanks.

-- 
tejun
