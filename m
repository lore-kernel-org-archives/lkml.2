Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1KRTHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:07:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab1KRTHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:07:17 -0500
Date: Fri, 18 Nov 2011 11:07:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
Message-Id: <20111118110716.c854b4bd.akpm@linux-foundation.org>
In-Reply-To: <4EC6246A.6020807@parallels.com>
References: <4EC4DA15.7090106@parallels.com>
	<20111117124831.688adbeb.akpm@linux-foundation.org>
	<4EC6246A.6020807@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011 13:24:58 +0400
Pavel Emelyanov <xemul@parallels.com> wrote:

> >> One of the ways for checking whether two tasks share e.g. an mm_struct is to
> >> provide some mm_struct ID of a task to its proc file. The best from the
> >> performance point of view ID is the object address in the kernel, but showing
> >> them to the userspace is not good for security reasons.
> >>
> >> Thus the object address is XOR-ed with a "random" value of the same size and 
> >> then shown in proc. Providing this poison is not leaked into the userspace then
> >> ID seem to be safe. The objects for which the IDs are shown are:
> >>
> >> * all namespaces living in /proc/pid/ns/
> >> * open files (shown in /proc/pid/fdinfo/)
> >> * objects, that can be shared with CLONE_XXX flags (except for namespaces)
> >> 
> >> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> > 
> > It doesn't *sound* terribly secure.  There might be clever ways in
> > which userspace can determine the secret mask, dunno.  We should ask
> > evil-minded security people to review this proposal.
> 
> Can you please propose some particular persons we should put in Cc for this thread?

Perhaps Vasily could review this proposal for us?

> > Why not simply use a sequence number, increment it each time we create
> > an mm_struct?  On could use an idr tree to prevent duplicates but it
> > would be simpler and sufficient to make it 64-bit and we never have to
> > worry about wraparound causing duplicates.
> 
> IDR is not OK for me, since we'll have to call it on every fork() thus penalizing
> its performance.

fork() is a pretty heavyweight operation so that won't hurt noticeably.
However it sounds like you're presented with the same issue for more
frequently-created objects.

> 64bit increasing numbers are perfectly fine with me (I did this
> in the 1st proposal, but put the ID on slub to save space - 64bits per page, not per
> object).
> 
> But I have one question regarding storing these long IDs per-object. Are we OK with
> adding 64-bit field on *all* the structures we need for this? I'm mostly worried 
> about these small ones like sem_undo_list and fs_struct.

OK.  Using the object's kernel virtual address is certainly very
attractive.

It is the case that we're causing difficulty with this longer-term plan
to make c/r available to unprivileged processes?  Because it's OK to
expose kernel addresses to CAP_SYS_ADMIN (or similar) tasks (isn't it?).

