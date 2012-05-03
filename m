Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2ECDMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 23:12:09 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:54491 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752472Ab2ECDMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 23:12:07 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18+avFz6NQ+QkXFj8q2V55EWVnXfCNNUCWGy7RZJE
	dPOp+t7E7iKl04
Message-ID: <1336014721.7370.32.camel@marge.simpson.net>
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Thu, 03 May 2012 05:12:01 +0200
In-Reply-To: <20120501134214.f6b44f4a.akpm@linux-foundation.org>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	 <20120429165846.GA19054@redhat.com>
	 <1335754867.17899.4.camel@marge.simpson.net>
	 <m1zk9rmyh4.fsf@fess.ebiederm.org>
	 <20120501134214.f6b44f4a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 13:42 -0700, Andrew Morton wrote:
> On Tue, 01 May 2012 13:35:03 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
> 
> > 
> > Andrew can you please pick up this patch?
> 
> Sure.  I assume it's fixing a post-3.4 regression?  No -stable backport
> needed?

Dunno what all should go to stable, but anyone using vsftpd will
appreciate something going.  Large leakage was initially reported
against 3.1.  That was bisected to..
423e0ab0 VFS : mount lock scalability for internal mounts 

Subsequent fixes which did not go to stable were applied..
	905ad269 procfs: fix a vfsmount longterm reference leak
	6f686574 ... and the same kind of leak for mqueue
..but leakage persists even with fork failure hole plugged.

The one (at least) that remains, grabbing pid references while we wait
for RCU destruction of pid/namespace and our subsequently never
destroying namespace is being annoying.  Yesterday I ran up >4600 leaks
with 10 background instances of the testcase (time that, egad), much
MUCH later ~4000 were released.  Between huge delay and ftrace simply
refusing to trace out of lined get_pid(), I'm having a jolly time trying
to get an 8x10 color glossy of the leaky event to stare at. 

Whatever goes to stable, what fixes this little bugger should go too.
> hm, Mike had some test code.  If that was put in
> tools/testing/selftests/nsproxy, this leak wouldn't happen again!

I didn't write it, that and a perl script to monitor leakage came along
with bug report.

-Mike

