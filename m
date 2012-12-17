Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2LQMeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 07:34:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab2LQMef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 07:34:35 -0500
Date: Mon, 17 Dec 2012 13:34:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re:  +
	core_pattern-set-core-helpers-root-and-namespace-to-crashing-process
	.patch added to -mm tree
Message-ID: <20121217123428.GA1957@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@@ -455,6 +468,14 @@ static int umh_pipe_setup(struct subproc
 	/* and disallow core files too */
 	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
 
+
+	if (cp->switch_ns) {
+		get_fs_root(cp->cprocess->fs, &root);
+		set_fs_root(current->fs, &root);
+		switch_task_namespaces(current, cp->cprocess->nsproxy);

How? You can't simply change ->nsproxy this way.

If nothing else this breaks sys_getpid(), no?

And a lot more problems, afaics. For example, this thread can continue
to run after, say, this cprocess->nsproxy->pid_ns was already destroyed.
zap_pid_ns_processes() obviously won't see this thread.

Even ->nsproxy itself can go away. Just suppose that the coredumping
task is the only process in this namespace (sub-init).

Oleg.

