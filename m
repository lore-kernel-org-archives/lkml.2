Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab1CDOHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:07:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33387 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab1CDOHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:07:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=A3Cwf130mUq8UYMJG+ueQ5OGmgjLBcELQo8RynTPgSzoXBrA/Adw5nx+poEn9GbZ+e
         x1+8cZsHVtVhcHFtK64Y3AZDUeDTHQDfd9jNWRc7ToMsSU3Z5scr3iPKSPof3Y1zGCfP
         LipS+k3vzAeLctwDuYPDghQvjXEGRaDY5EDiA=
Date: Fri, 4 Mar 2011 15:07:45 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304140745.GP20499@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110303173422.GA27960@redhat.com>
 <20110303202246.GB32152@redhat.com>
 <AANLkTikeCzr-OGkmaaortS7_rR+JCM9B6aJV0c52EMbE@mail.gmail.com>
 <20110304134126.GL20499@htj.dyndns.org>
 <AANLkTikLd2Kg9Pz+5eLd_irdxoKdrR9qPj8yixeTfvaM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikLd2Kg9Pz+5eLd_irdxoKdrR9qPj8yixeTfvaM@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 04, 2011 at 02:59:32PM +0100, Denys Vlasenko wrote:
> I would rather speed strace up than slow it down further, even if
> slightly.

The question to ask is at what cost?  If mostly unnoticeable slow down
makes the API cleaner, I'll go that way.  Everything is a tradeoff.

> > it might really not fit there.  I'd like to avoid twisting debugging
> > API
> 
> It is *already* twisted that way. Other ptrace stops *already*
> return extra information in waitpid status: run "man ptrace"
> and read PTRACE_SETOPTIONS section. For example:
> 
>       "PTRACE_O_TRACEEXEC (since Linux 2.5.46)
>              Stop  the  child  at  the next execve(2) call with
>              SIGTRAP | PTRACE_EVENT_EXEC << 8."
> 
> I don't see why adding another PTRACE_EVENT_foo
> is a big deal.

No, I wasn't talking about that.  My concern was that.  Let's say, we
need a flag somewhere to indicate group stop state (because the state
is necessary regardless of which trap is taken) and then we can't or
that to SIGTRAP transparently because that would change it for the
existing events and at the same time I don't want to make the
information available in two separate forms.

That said, I think, for strace, it should be okay.  Unless the tracer
resumes the tracee while job control stop is in effect, the trap which
is taken after SIGCONT emission will be a new distinguishible trap
which will be assigned a separate PTRACE_EVENT_*, so it wouldn't have
to depend on siginfo.

Anyways, I'll keep the distinction performance on mind but if it comes
down to API convolution, I don't think bending that way is a good
idea.  If we're gonna bend, there should be numbers justifying the
bending.

Thanks.

-- 
tejun
