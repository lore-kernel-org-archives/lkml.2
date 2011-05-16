Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab1EPNgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:36:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53979 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab1EPNgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:36:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LD0LRH29ik65xsfdojBRoAcCoGmgRn+McbOtdsT0fkNxaJ2nkTUZjBCjNzPdVmeJWn
         hasNZ9fpvAXCIZb3i8zg/9HCiqiPC19sx4hCeet9rAXPqFzO8cILbViNcBYcgVXcgiHs
         Z7PO/9NjSDD5aQ4u4MvZ5yKIgEidwEuMbp7sY=
Date: Mon, 16 May 2011 15:36:44 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH UPDATED 8/9] ptrace: move JOBCTL_TRAPPING wait to
 wait(2) and ptrace_check_attach()
Message-ID: <20110516133644.GZ23665@htj.dyndns.org>
References: <1305301580-9924-1-git-send-email-tj@kernel.org>
 <1305301580-9924-9-git-send-email-tj@kernel.org>
 <20110514142230.GD23665@htj.dyndns.org>
 <20110516121142.GC4898@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516121142.GC4898@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 16, 2011 at 02:11:42PM +0200, Oleg Nesterov wrote:
> Hmm. I didn't even know we have restart_syscall()... It is a bit fragile,
> it assumes recalc_sigpending() is not possible during return from syscall.
> In particular this means recalc_sigpending() must not be called in irq.
> OK, this seems to be true.

Yes, it is quite fragile.  I think we can make it more reliable
instead of each path which might clear TIF_SIGPENDING to be careful
about not hitting it, but that's a separate issue and we need the
syscall restart mechanism anyway for other purposes.

> Anyway, restart_syscall() is not right for do_wait(), especially with the
> next patch. If the caller was woken by the real signal which has a handler,
> we should not restart without SA_RESTART.

I don't think it really matters and might even be incorrect if we do
that.  e.g. we would introduce -EINTR failure to WNOHANG waits.  These
waits and restarts are transient and should be transparent.  Maybe if
the ptracer is ptraced, syscall entry trap can give away that the
syscall was retried when SA_RESTART wasn't set but I'd be happy to
ignore that.

The only case that I think of where this could be visible is sleeping
wait(2), checking the state again after being woken up and gets signal
while waiting for TRAPPING.  In this case, yeap, we should fail with
-EINTR.

Hmmm... so, I suppose, we should either return -ERESTARTNOINTR or
-ERESTARTSYS depending on WNOHANG.  How does that sound?

> It is very hard to review this series. Without the further changes, it is
> not clear why do we need these preparations. IIUC, ptrace_wait_trapping()
> is only needed because we are going to re-trap. Otherwise we could always
> wait in ptrace_attach() afaics.

I think the patches in this series should be able to stand on
themselves.  It's relaxing TRAPPING constraints and making it
generally safer.  With these changes, SEIZE/INTERRUPT/notification
implementation becomes quite straight-forward.

> I am still worried we are loosing the tight control over JOBCTL_TRAPPING.
> 6/9 contributes to this too.

Setting of TRAPPING is scary.  Clearing isn't.  The worst that can
happen is unexpected failure of WNOHANG wait or ptrace request - even
that isn't gonna happen if the application is sensible enough to use
sleeping wait(2) after attaching.

Thanks.

-- 
tejun
