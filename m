Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2EGAcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 20:32:31 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:50781 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2EGAca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 20:32:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
Date: Sun, 06 May 2012 17:32:20 -0700
In-Reply-To: <20120501134214.f6b44f4a.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 1 May 2012 13:42:14 -0700")
Message-ID: <87havs7rvv.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+RuNIKakk/E9Ij8bgwynKOy5H4jcMUCjQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0388]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: XX
Subject: [PATCH 0/3] pidns: Closing the pid namespace exit race.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I had some patches that broke the circular reference between the
pid_namespace and the proc_mnt by combining the reference counts but the
world has changes and now the proc_mnt reference count is not suitable
to be used that way so that plan is scrapped.

I did play with it and I have found a relatively elegant way of at least
handling the problem of self reaping children escaping from
zap_pid_ns_processess.

The following patches guarantee that the task with pid == 1 will be the
last task reaped in a pid namespace. Making proc_flush_task safe.

The previous patch to call pid_ns_release_proc on fork failure is still
needed.  These patches simply address the other failure mode.

How did it escape my memory that setting SIGCHLD to SIG_IGN caused
children to autoreap?


Eric W. Biederman (3):
      pidns:  Use task_active_pid_ns in do_notify_parent.
      pidns: Guarantee that the pidns init will be the last pidns process reaped.
      pidns: Make killed children autoreap

 kernel/exit.c          |   46 +++++++++++++++++++++++++++++++++++-----------
 kernel/pid_namespace.c |    7 ++++++-
 kernel/signal.c        |   11 +++++------
 3 files changed, 46 insertions(+), 18 deletions(-)
