Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2BORx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:53:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42167 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab2BORxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:53:25 -0500
Date: Wed, 15 Feb 2012 21:53:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120215175319.GG4533@moon>
References: <20120215143606.GA14037@redhat.com>
 <20120215151008.GL1894@moon>
 <20120215153816.GA15988@redhat.com>
 <20120215161329.GM1894@moon>
 <20120215162222.GA18266@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215162222.GA18266@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 05:22:22PM +0100, Oleg Nesterov wrote:
> 
> > So I don't understand how it's different from what
> > is provided in this patch. What I'm missing?
> 
> environ_read() does
> 
> 	mm = mm_access(task);
> 	if (mm)
> 		do_something(mm);
> 
> even if it races with, say, execve(setuid_app) we can't read the
> new ->mm.

Wait, I'm confused

	process 1 (reader)	process 2 ("task" itself)
	mm = mm_access(task);
				task changes own credentials
				so reader can't access on next
				read if it would try, but since
				access already granted... it
				continues do_something(mm)
	if (mm)
		do_something(mm);

So in the patch I tried the same, once access is granted it
belongs to a caller.

> 
> while your code (very roughly) does something like
> 
> 	mm = mm_access(task);
> 	if (mm)
> 		do_something(task->mm);
> 
> while it is quite possible that mm != task->mm.

Oleg, could you please explain me where it happens
that task->mm (I've got access to) will be changed
to some new -mm while I'm inspecting it.

If permission changed while the caller inside syscall,
it's the same situation as with mm_access above. No?

> 
> My only point is: this check is obviously racy, and thus it looks
> confusing. Whether this is fine or not, I do not know. Personally
> I see no reason for ptrace_may_access(), but I am not security
> expert.

The idea was -- non-privilege caller should not have access
to privileged tasks.

	Cyrill
