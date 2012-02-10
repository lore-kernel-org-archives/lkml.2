Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104Ab2BJUG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:06:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760056Ab2BJUGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:06:55 -0500
Date: Fri, 10 Feb 2012 21:00:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] signal: give SEND_SIG_FORCED more power to beat
	SIGNAL_UNKILLABLE
Message-ID: <20120210200021.GA20898@redhat.com>
References: <20120210200004.GA20890@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210200004.GA20890@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

force_sig_info() and friends have the special semantics for
synchronous signals, this interface should not be used if the
target is not current. And it needs the fixes, in particular
the clearing of SIGNAL_UNKILLABLE is not exactly right.

However there are callers which have to use force_ exactly because
it clears SIGNAL_UNKILLABLE and thus it can kill the CLONE_NEWPID
tasks, although this is almost always is wrong by various reasons.

With this patch SEND_SIG_FORCED ignores SIGNAL_UNKILLABLE, like
we do if the signal comes from the ancestor namespace.

This makes the naming in prepare_signal() paths insane, fixed by
the next cleanup.

Note: this only affects SIGKILL/SIGSTOP, but this is enough for
force_sig() abusers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index c73c428..bfb2b97 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1059,7 +1059,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 
 	assert_spin_locked(&t->sighand->siglock);
 
-	if (!prepare_signal(sig, t, from_ancestor_ns))
+	if (!prepare_signal(sig, t,
+			from_ancestor_ns || (info == SEND_SIG_FORCED)))
 		return 0;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
-- 
1.5.5.1


