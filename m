Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab2EDHvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 03:51:42 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56540 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2EDHvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 03:51:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<1336014721.7370.32.camel@marge.simpson.net>
	<1336057018.8119.46.camel@marge.simpson.net>
	<1336105676.7356.42.camel@marge.simpson.net>
Date: Fri, 04 May 2012 00:55:44 -0700
In-Reply-To: <1336105676.7356.42.camel@marge.simpson.net> (Mike Galbraith's
	message of "Fri, 04 May 2012 06:27:56 +0200")
Message-ID: <m1aa1oidmn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19KwRSHqNOgb9AomPdCFFNo95wEFoaXT8M=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Galbraith <efault@gmx.de>
X-Spam-Relay-Country: **
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith <efault@gmx.de> writes:

> Namespaces have something in common with cgroups.  synchronize_rcu()
> makes them somewhat less than wonderful for dynamic use.

Well unlike cgroups namespaces were not designed for heavy dynamic use.
Although it appears that vsftp puts them to that kind of use so some
of the design decisions are with revisiting.

> default flags = SIGCHLD
>
> -namespace:  flag |= CLONE_NEWPID 
> -all:  flags |= CLONE_NEWIPC | CLONE_NEWNET | CLONE_NEWUSER
>
> marge:/usr/local/tmp/starvation # ./hackbench
> Running with 10*40 (== 400) tasks.
> Time: 2.636
> marge:/usr/local/tmp/starvation # ./hackbench -namespace
> Running with 10*40 (== 400) tasks.
> Time: 11.624
> marge:/usr/local/tmp/starvation # ./hackbench -namespace -all
> Running with 10*40 (== 400) tasks.
> Time: 51.474

CLONE_NEWUSER?  I presume you have applied my latest user namespace
patches?  Otherwise you are running completely half baked code.

hackbench?  Which kernel are you running.  Hackbench in some kernels is
really good at triggering cache ping-pong effects with pids, and creds.
So I'm not certain what to say there.  In the latest kernels things
should be better with unix domain sockets as long as you don't actually
ask to pass your creds but hackbench is still a pretty ridiculous
benchmark.  Oversharing is always going to be bad for performance.

> You can create trash quickly, but you have to haul it away.

Well synchronize_rcu is much better in that respect than call_rcu, which
let's the trash build up but is never carried away.

The core design assumption with namespaces is that they will be used
much more than they will be created/destroyed, and as long as there are
progress guarantees in place I don't have a problem with that.   At the
same time if there are easy things we can do to make things go faster
I am in favor of that notion.

Still especially in the case of hackbench I think it is worth asking the
question how much of the slow down is due to cache ping-pong due to
oversharing.

Eric
