Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2ACOfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 09:35:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab2ACOff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 09:35:35 -0500
Date: Tue, 3 Jan 2012 15:29:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?=C5=81ukasz?= Michalik <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: Possible bug introduced in commit 9b84cca
Message-ID: <20120103142941.GA25488@redhat.com>
References: <201112281955.55200.vda.linux@googlemail.com> <20111229113245.GA18062@redhat.com> <20111229120506.GA23653@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111229120506.GA23653@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29, Oleg Nesterov wrote:
>
> On 12/29, Oleg Nesterov wrote:
> >
> > On 12/28, Denys Vlasenko wrote:
> > >
> > > 931   clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0xf763dbd8) = 1048
> > > 1048  exit_group(42)                    = ?
> > > 931   waitpid(1048,  <unfinished ...>
> > > 1048  +++ exited with 42 +++
> > > 931   <... waitpid resumed> 0xf763d3a0, 0) = -1 ECHILD (No child processes)
> >
> I've made the simple test-case, it triggers the bug.

I am going to send the hack^Wpatch below to Linus as a temporary
workaround for 3.2.

Any chance you can test it?

I did the testing too with my test-case, but it would be nice to
know if it works for you.

Thanks,

Oleg.

--- x/kernel/exit.c~	2011-11-22 18:46:22.000000000 +0100
+++ x/kernel/exit.c	2012-01-03 14:37:17.000000000 +0100
@@ -1540,8 +1540,11 @@ static int wait_consider_task(struct wai
 	}
 
 	/* dead body doesn't have much to contribute */
-	if (p->exit_state == EXIT_DEAD)
+	if (unlikely(p->exit_state == EXIT_DEAD)) {
+		if (likely(!ptrace) && unlikely(ptrace_reparented(p)))
+			wo->notask_error = 0;
 		return 0;
+	}
 
 	/* slay zombie? */
 	if (p->exit_state == EXIT_ZOMBIE) {

