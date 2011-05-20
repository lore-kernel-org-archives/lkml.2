Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935433Ab1ETI72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:59:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35339 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934991Ab1ETI70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qRuxU75GOfUXsRI5ZTD4tWwvCK8hCqHtX1ugdiR7XUuoJvgpgKwndX7eUp7AFijQ8l
         LOpeo38GYPbcSr6GzgzqoR+PsrAna4rf+x+uPMu0LeVE3STebs9lK7el+2PH0GMOPYu6
         O4do/kocTunRK5ZCkqLlocD5ynWj/zwxndqkY=
Date: Fri, 20 May 2011 10:59:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 10/10] ptrace: implement group stop notification for
 ptracer
Message-ID: <20110520085921.GB31426@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <20110519165722.GP627@htj.dyndns.org>
 <20110519171327.GA19698@redhat.com>
 <201105200048.07942.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105200048.07942.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Fri, May 20, 2011 at 12:48:07AM +0200, Denys Vlasenko wrote:
> > Hmm. At least now I understand the meaining what "sticky" means in
> > this discussion ;) I was confused.
> 
> I still don't see why is it needed. Userspace API doesn't require it.
> 
> Are you trying to solve/simplify something on the kernel side with it?

No, no.  Please consider the following scenario.

1. A process has two threads t1 and t2.  t1 is ptraced by p1.  Both t1
   and t2 are running.

2. p1 INTERRUPTs t1.  t1 enters TRAP_STOP and p1 notices it.

3. Something else sends SIGSTOP to t2 which initiates group stop.

4. As t1 re-traps to notify p1 of group stop, p1 issues PTRACE_CONT.

5. PTRACE_CONT succeeds right after t1 re-traps for notification and
   t1 resumes execution.

6. p1 has no way to find out the group stop which is now in effect.

And vice-versa for SIGCONT.  When an event needs to be delivered, the
event should remain pending until the target the event is destined to
has fetched the event; otherwise, the event can be lost.  Here, the
event to be delivered is change of group stop state and fetching
mechanism is GETSIGINFO.  The event should remain pending until
GETSIGINFO is called.

The only requirement is for the ptracer to call PTRACE_GETSIGINFO on
PTRACE_EVENT_STOP's which can be determined from the wait(2) exit
code.  If ptracer does that, there won't be any unnecessary trap.

Thanks.

-- 
tejun
