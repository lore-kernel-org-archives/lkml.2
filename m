Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab0FVBXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 21:23:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758686Ab0FVBXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 21:23:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Edward Allcutt <edward@allcutt.me.uk>
X-Fcc: ~/Mail/linus
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: limit maximum concurrent coredumps
In-Reply-To: Edward Allcutt's message of  Monday, 21 June 2010 19:58:55 -0400 <1277164737-30055-1-git-send-email-edward@allcutt.me.uk>
References: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk>
X-Shopping-List: (1) Diagnostic wine pistons
   (2) Exotic shoe collisions
   (3) Treasonous division gloves
   (4) Mrs. Leland's Watchers
   (5) Maternity garrulous ponds
Message-Id: <20100622012303.BD72E402AD@magilla.sf.frob.com>
Date: Mon, 21 Jun 2010 18:23:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A core dump is just an instance of a process suddenly reading lots of its
address space and doing lots of filesystem writes, producing the kinds of
thrashing that any such instance might entail.  It really seems like the
real solution to this kind of problem will be in some more general kind of
throttling of processes (or whatever manner of collections thereof) when
they got hog-wild on page-ins or filesystem writes, or whatever else.  I'm
not trying to get into the details of what that would be.  But I have to
cite this hack as the off-topic kludge that it really is.  That said, I do
certainly sympathize with the desire for a quick hack that addresses the
scenario you experience.

For the case you described, it seems to me that constraining concurrency
per se would be better than punting core dumps when too concurrent.  That
is, you should not skip the dump when you hit the limit.  Rather, you
should block in do_coredump() until the next dump already in progress
finishes.  (It should be possible to use TASK_KILLABLE so that those dumps
in waiting can be aborted with a follow-on SIGKILL.  But Oleg will have to
check on the signals details being right for that.)

That won't make your crashers each complete quickly, but it will prevent
the thrashing.  Instead of some crashers suddenly not producing dumps at
all, they'll just all queue up waiting to finish crashing but not using any
CPU or IO resources.  That way you don't lose any core dumps unless you
want to start SIGKILL'ing things (which oom_kill might do if need be),
you just don't die in flames trying to do nothing but dump cores.


Thanks,
Roland
