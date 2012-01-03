Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2ACQaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:30:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62986 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab2ACQa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:30:28 -0500
Date: Tue, 3 Jan 2012 08:30:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        =?utf-8?Q?=C5=81ukasz?= Michalik <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: ptrace fixes for 3.2
Message-ID: <20120103163023.GA31746@google.com>
References: <201112281955.55200.vda.linux@googlemail.com>
 <20111229113245.GA18062@redhat.com>
 <20111229120506.GA23653@redhat.com>
 <20120103142941.GA25488@redhat.com>
 <20120103154404.GA28930@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103154404.GA28930@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Tue, Jan 03, 2012 at 04:44:04PM +0100, Oleg Nesterov wrote:
> It fails because ->real_parent sees its child in EXIT_DEAD state
> while the tracer is going to change the state back to EXIT_ZOMBIE
> in wait_task_zombie().

Argh.... EXIT_ZOMBIE -> DEAD -> ZOMBIE dancing in wait_task_zombie()
is just nasty.  Didn't realize it was doing that.  :(

> The offending commit is 823b018e which moved the EXIT_DEAD check,
> but in fact we should not blame it. The original code was not
> correct as well because it didn't take ptrace_reparented() into
> account and because we can't really trust ->ptrace.
> 
> This patch adds the additional check to close this particular
> race but it doesn't solve the whole problem. We simply can't
> rely on ->ptrace in this case, it can be cleared if the tracer
> is multithreaded by the exiting ->parent.

I'm not following this part.  Can you please explain it in a bit more
detail?

> I think we should kill EXIT_DEAD altogether, we should always
> remove the soon-to-be-reaped child from ->children or at least
> we should never do the DEAD->ZOMBIE transition. But this is too
> complex for 3.2.

Agreed.  Removing the reverse transition shouldn't be too difficult
and can be done without affecting fast non-ptrace path.  ie. if the
child is ptraced, drop readlock, grab writelock, recheck, buffer
states to copy out to userland, detach and transit to DEAD if
necessary.

> Also, I think wait_consider_task() needs more fixes. I do not
> think we should clear ->notask_error without WEXITED in this
> case, but this is what we do in the EXIT_ZOMBIE case.

Hmmm... I'm not sure about that.  Why do you think so?

> Reported-by: Denys Vlasenko <vda.linux@googlemail.com>
> Cc: v3.0.. <stable@kernel.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Anyways, the fix looks good to me.

 Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
