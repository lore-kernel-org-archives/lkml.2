Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab1FWJYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:24:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35823 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759049Ab1FWJYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:24:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=POgaau+sXj4BZwmbdzxmHEUvVdALeQ257pDunkVph8wVfdkDNWiZdnvsj/b3bm+RB3
         Yjb3TxqwWu78T0TuayBh7FrQW6FDF8oJJxPIQeMnLNH2h9svpO/GCBnBnfBFkAlp7uXI
         g0SC3RVGngLn3+f85VK3K3jcdwmENwiDuty9Y=
Date: Thu, 23 Jun 2011 11:24:01 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 6/7] ptrace: kill detah tracehooks
Message-ID: <20110623092401.GI30101@htj.dyndns.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
 <1308322240-8247-7-git-send-email-tj@kernel.org>
 <20110620193929.GA15228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620193929.GA15228@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Mon, Jun 20, 2011 at 09:39:29PM +0200, Oleg Nesterov wrote:
> > -	signal = tracehook_notify_death(tsk, &cookie, group_dead);
> > -	if (signal >= 0)
> > -		signal = do_notify_parent(tsk, signal);
> > +	/*
> > +	 * Notify interested parent if the whole group is dead.  Ptracer
> > +	 * should always be notified.  If something other than our normal
> > +	 * parent is ptracing us, then send it a SIGCHLD instead of
> > +	 * honoring exit_signal.  exit_signal only has special meaning to
> > +	 * our real parent.
> > +	 */
> > +	if (!task_detached(tsk) && thread_group_empty(tsk)) {
> > +		if (!ptrace_reparented(tsk))
> > +			do_notify_parent(tsk, tsk->exit_signal);
> > +		else
> > +			do_notify_parent(tsk, SIGCHLD);
> 
> Forget about ptrace, suppose a single threaded child exits and its
> parent ignores SIGCHLD. In this case do_notify_parent() sets
> exit_signal = -1 to mark it dead, we should set exit_state = EXIT_DEAD
> and release it.

Oops, right.  Missed do_notify_parent() may modify exit_signal.
Grumble.  It seems you already have posted patches to address this
one.  Let's continue there.

Thanks.

-- 
tejun
