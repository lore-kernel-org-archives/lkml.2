Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1K1QZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:25:46 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:57568 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1K1QZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:25:45 -0500
Date: Mon, 28 Nov 2011 08:25:38 -0800
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Pedro Alves <pedro@codesourcery.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
 given pids
Message-ID: <20111128162538.GD18864@google.com>
References: <201111221204.39235.pedro@codesourcery.com>
 <20111122153326.GD322@google.com>
 <201111231620.45440.pedro@codesourcery.com>
 <20111123162417.GE25780@google.com>
 <4ECD3946.1030503@parallels.com>
 <4ECD542C.7010705@parallels.com>
 <20111124173121.GA23260@redhat.com>
 <4ECF6AA0.80006@parallels.com>
 <20111127184725.GA4266@google.com>
 <4ED364B6.8090108@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED364B6.8090108@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pavel.

On Mon, Nov 28, 2011 at 02:38:46PM +0400, Pavel Emelyanov wrote:
> > Hmmm... Any attempt to reserve PIDs without full control over the
> > namespace is futile.  It can never be complete / reliable. 
> 
> Why? What's the _real_ problem with the 
> 
> pid = prctl(PR_RESERVE_PID, 0); /* let the kernel _generate_ a pid for us */
> while (1) {
> 	real_pid = fork();
> 	BUG_ON(pid != real_pid);
> 	if (real_pid == 0)
> 		return do_child();
> 
> 	wait();
> }
> 
> model? Let's temporarily forget about the single reserved pid implementation
> limitation and concentrate on the approach itself.

PID is ns-shared resource.  If you don't have full control over it and
there are other tasks allocating from it, there is no way to reserve
specific pid reliably no matter what you do.  The only things you can
do are - either reserve the pids you want before anyone else takes it
or somehow revoke pids held by other tasks.

Full ns control + set_last_pid essentially gives the ns owner full
reservation + a way to control allocation.

I suppose you're suggesting that with reserve approach, we can also
support recycling pids of existing tasks which is suggested to be
useful for systemd and gdb.

Using this kind of black magic for general system management seems
like a really bad idea to me.  It is extremely obscure and unexpected
and we actually should be looking to dissuade such usage even if the
natural implementation of the mechanism allows for it.

For gdb, it *might* be useful but the usage isn't out there yet and
the suggested mechanism isn't enough to support the suggested usage
(ie. multithread).  We have neither concrete problem or solution.

So, let's do the simple 30 line non-invasive thing now and worry about
the complex problem when it's actually necessary.  It's not like the
ability to set last_pid is gonna interfere with future changes or
anything.

Thanks.

-- 
tejun
