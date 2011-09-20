Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1ITSyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:54:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38735 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab1ITSyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:54:03 -0400
Date: Tue, 20 Sep 2011 13:53:54 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110920185354.GA19629@sergelap>
References: <20110919214531.GA18085@sergelap>
 <20110920174849.GB22317@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920174849.GB22317@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 09/19, Serge E. Hallyn wrote:
> >
> > __send_signal: convert the uid being sent in SI_USER to the target task's
> > user namespace.
> >
> > do_notify_parent and do_notify_parent_cldstop: map task's uid to parent's
> >  user namespace
> >
> > ptrace_signal: map parent's uid into current's user namespace before
> > including in signal to current.
> 
> Btw, what about the other users of ->si_uid? Say, kill() or tkill().

Well, they end up calling __send_signal().

> Looks like, we need a lot of complications to make this correct...
> 
> As for send_signal(), may be we can simply do
> 
> 
> 	--- x/kernel/signal.c
> 	+++ x/kernel/signal.c
> 	@@ -1084,10 +1084,13 @@ static int __send_signal(int sig, struct
> 				break;
> 			default:
> 				copy_siginfo(&q->info, info);
> 	-			if (from_ancestor_ns)
> 	-				q->info.si_pid = 0;
> 				break;
> 			}
> 	+
> 	+		if (unlikely(from_ancestor_ns)) {
> 	+				q->info.si_pid = 0;
> 	+				q->info.si_uid = 0;
> 	+		}
> 		} else if (!is_si_special(info)) {
> 			if (sig >= SIGRTMIN && info->si_code != SI_USER) {
> 				/*
> 
> ?
> 
> Yes, this "breaks" sys_rt_sigqueueinfo() evem more if it is used
> to send the signal to the sub-namespace.

Eh, yeah, so we do have to use the user_ns_map_uid(), or rather your
new helper.

But you sound more alarmed than that.  So I might be missing something.
You think that user_ns_map_uid() at the locations I identified in
kernel/signal.c does not suffice?

-serge
