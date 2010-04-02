Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0DBRvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:51:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755751Ab0DBRve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:51:34 -0400
Date: Fri, 2 Apr 2010 10:46:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       Greg KH <greg@kroah.com>, Catalin Marinas <catalin.marinas@arm.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, stable@kernel.org
Subject: Re: [PATCH 1/1] tty: release_one_tty() forgets to put pids
In-Reply-To: <20100402160512.GB19920@redhat.com>
Message-ID: <alpine.LFD.2.00.1004021040320.3634@i5.linux-foundation.org>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp> <tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com> <20100331151719.8a92b302.akpm@linux-foundation.org> <20100402160447.GA19920@redhat.com> <20100402160512.GB19920@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Apr 2010, Oleg Nesterov wrote:
>
> release_one_tty(tty) can be called when tty still has a reference
> to pgrp/session. In this case we leak the pid.

Hmm. Maybe we should have cleared this in tty_release() already. We 
already do some of the session clearing there (but we clear the session in 
the _tasks_ associated with the tty, not the tty session pointer).

But:

> The patch needs the ack from someone who understand tty magic.

I think the patch is simpler than worrying about the much more complex 
release logic. So I think I actually prefer this patch over something that 
tries to be clever in tty_release.

We might even push it into "free_tty_struct()", although I think that the 
only non-release_one_tty() callers of that are the ones that allocated the 
tty but due to some failure never connected it to anything. So on the 
whole I think you picked the right spot.

So I'll ACK it. But maybe Alan sees some problem/issue I didn't see.

			Linus
