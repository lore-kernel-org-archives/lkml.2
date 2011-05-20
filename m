Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935048Ab1ETBot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:44:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63725 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934684Ab1ETBor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AQJqPTpVHM5pPUMdQr0DdsIBrOYP3KM5TAQOQlvpDGSiiLcSNtWlb2hQMVdiO9OaLW
         4uDa7G071SmH/WqkGjlF1yy8A3lW8InoGUcEkSKUg708Y/WwF3tv783o60N4eKvoa7js
         dLOiALjnOwEDVu2m7FERzWi7BDRfET0HxdB+I=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Pedro Alves <pedro@codesourcery.com>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Fri, 20 May 2011 03:44:44 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <201105200042.12230.vda.linux@googlemail.com> <201105200000.18310.pedro@codesourcery.com>
In-Reply-To: <201105200000.18310.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <201105200344.44520.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 May 2011 01:00, Pedro Alves wrote:
> On Thursday 19 May 2011 23:42:12, Denys Vlasenko wrote:
> > On Thursday 19 May 2011 21:31, Pedro Alves wrote:
> > > On Thursday 19 May 2011 15:17:28, Tejun Heo wrote:
> > > > But making SEIZE not trigger INTERRUPT and SETOPTIONS without
> > > > requiring TRACED don't seem too difficult.  Jan, would that be enough?
> > > > Oleg, what do you think?
> > > 
> > > UUIC, that opens a race where between SEIZEing and
> > > SETOPTIONS(O_TRACE FORK|VFORK|EXEC...), the tracee can
> > > fork/vfork/clone/exec, without the tracer getting the
> > > nice corresponding PTRACE_EVENT_ events.
> > 
> > SEIZE,fork-in-tracee,INTERRUPT sequence is indistinguishable
> > from SEIZE happening two microseconds later:
> > 
> > fork-in-tracee,SEIZE,INTERRUPT
> 
>  SEIZE,execvd,INTERRUPT (SETOPTS on interrupt)
> 
> will make the tracer see a SIGTRAP that 
> 
>  execvd,SEIZE,INTERRUPT
> 
> nor
> 
>  SEIZE,SETOPTS,execvd (SETOPTS on interrupt)
> 
> would cause, isn't it?

Yes, you are right about this particular case.

Execve's extra SIGTRAP is a particularly painful misfeature.


> Now, if it were possible for the tracer to set the
> default OPTS _before_ PTRACE_ATTACH/PTRACE_SEIZE...

I propose to do it *during* SEIZE then. Say, by passing SETOPTION style
option flags in data argument. To fight above example, we'd want
to pass PTRACE_O_TRACEEXEC. 

Tejun, what do you think?


> > > In GDBs case, GDB will want to poke at memory
> > > right after attaching
> > 
> > ...where "right after attaching" is defined as "when the first ptrace-stop
> > is reported". Which will happen very soon.
> 
> Hmm?  Why would it happen very soon?
> Isn't the point of SEIZE not 
> interrupting that you'd not get any INTERRUPT or stop at all?
> Where is the ptrace-stop coming from?

>From PTRACE_INTERRUPT. Without it, tracee is running. Ptrace API never
allowed poking of running tracees. You need to stop it first.

-- 
vda
