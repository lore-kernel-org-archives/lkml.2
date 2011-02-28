Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1B1Ojf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:39:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47834 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab1B1Oje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=eKFoPlvNhoPmbje+G6GYw72lYA6xvjxyOUlBeG2bg7AD/xSB9SbnxayyuBcSH7YaPi
         48Wm7WNX3pKsTRiTIIvXoLdhvR45Ro2qWrb7lpYJPlhrJyElZQb9sHSd8i0qWYJ5j3Wb
         qE/nmTLB0KPkw2U+z5iV0bLzsniMbg+643FJs=
Date: Mon, 28 Feb 2011 15:39:20 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110228143920.GD9326@htj.dyndns.org>
References: <20110214190141.GA19221@redhat.com>
 <20110224202941.GA12258@redhat.com>
 <20110225155142.GQ24828@htj.dyndns.org>
 <201102260348.03312.vda.linux@googlemail.com>
 <20110228125622.GA9326@htj.dyndns.org>
 <AANLkTik1+XVrkwTouERoxF2AWYyv-UCqie_Wq3OLjoXg@mail.gmail.com>
 <20110228132941.GB9326@htj.dyndns.org>
 <AANLkTin9HW5R5Wihw+yceKkW=Pj+eB8-id0E1Gud2y-G@mail.gmail.com>
 <20110228135312.GC9326@htj.dyndns.org>
 <AANLkTimQV0j2MuPdwQBgpdCN6nA9KTbVwrSM1Ut0i_=q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimQV0j2MuPdwQBgpdCN6nA9KTbVwrSM1Ut0i_=q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Feb 28, 2011 at 03:25:53PM +0100, Denys Vlasenko wrote:
> On Mon, Feb 28, 2011 at 2:53 PM, Tejun Heo <tj@kernel.org> wrote:
> > I don't really follow the distinction you're trying to make.  It
> > doesn't matter what you're trying to do.  All that's necessary is for
> > the debugger to find out whether group stop is in effect or not and a
> > way to control the tracee's execution.  Nothing else is necessary.
> > The debugger already knows when the tracee enters group stop.  We just
> > need a way for the debugger to find out when group stop stops.
> 
> If I understand you right, you are proposing to handle strace+^Z
> scenario this way (simplified pseudo-C):
> 
> for(;;) {
>   waitpid(-1, ...);
>   tracee_is_stopped = 0;
>   if (waitpid reported *stopping* signal) {
>     PTRACE_GETSIGINFO();
>     if (PTRACE_GETSIGINFO failed)
>       tracee_is_stopped = 1;
>   }
>   if (!tracee_is_stopped)
>     PTRACE_SYSCALL(signal);
> }
> 
> This requires API change to make waitpid in debugger
> see waking SIGCONTs even if we did not restart the tracee
> (at least in the case when tracee was in group stop).

Yes, something like that.  I'm still not sure how to notify end of
group stop to the debugger tho.  Using wait(2) would be the path of
the least resistance but as you pointed out it does change the
behavior.  I think what we can do is to switch on the behavior when
the new attach call is used.  We'll probably have to pay some
attention to make the notification race-free and reliable but I think
it shouldn't too difficult.

> This sounds like viable plan from userspace POV.

Cool.

> > A tracee should _always_ enter ptrace trap whenever stopping while
> > ptraced.  The stop here or stop there depending on the type of stop
> > behavior is hardly useful and very fragile (I think it's inherently
> > fragile that way).  Again, the only missing thing is a way for the
> > debugger to find out when task stop stops.
> 
> PTRACE_GETSIGINFO tells you that. It's a bit of a hack
> (PTRACE_GETSIGINFO was meant to be used for a different purpose)
> but it seems to be working well.

Yeap, what works works.  We probably want to explain its use in the
man page but I don't think there's any reason to add a new mechanism
for this.

> The problematic case is when we attach to *already stopped* task.
> gdb today goes through insane gyrations to detect that condition
> (I believe it looks into /proc/TID/state).
> 
> If we are going to add PTRACE_ATTACH_NOSTOP or something like it,
> perhaps we need to take care to make tracee state detectable
> at attach time more easily. Maybe by delivering "I have stopped with SIGfoo"
> notification to the debugger if tracee was in group stop?

I believe this is already solved by making the tracee always enter
TASK_TRACED via ptrace_stop() on attach, which always reports the
group stop signal to the ptracer whether the real parent has consumed
it or not.  The patch is at the top of this gigantic thread.  Oleg,
this is solved one, right?

Thanks.

-- 
tejun
