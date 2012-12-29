Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2L2FWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 00:22:40 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:63816 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2L2FWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 00:22:38 -0500
Date: Sat, 29 Dec 2012 09:22:34 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH/RFC] user_ns: fix missing limiting of user_ns counts
Message-ID: <20121229052234.GA4153@cachalot>
References: <20121228175627.GA7683@cachalot>
 <87wqw15wqb.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqw15wqb.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 20:05 -0800, Eric W. Biederman wrote:
> Vasily Kulikov <segoon@openwall.com> writes:
> 
> > Currently there is completely no limiting in number of user namespaces
> > created by unprivileged users.  One can freely create thousands of
> > user_ns'es and exhaust kernel memory without even bumping in
> > RLIMIT_NPROC or similar.
> 
> First for a proper sense of scale it will take roughly 14,000 to consume
> a megabyte.  So it will take hundreds of millions of user namespaces to
> eat up all of kernel memory.

Yes, but you can freely create *any* number of nested userns by a loop:

    for() {
        unshare()
        write to /proc/self/{u,g}id_map
    }

> > The code needs several checks.  First, noone should be able to create
> > user_ns of arbitrary depth.  Besides kernel stack overflow one could
> > create too big depth to DoS processes belonging to other users by
> > forcing them to loop a long time in cap_capable called from some
> > ns_capable() (e.g. in case one does smth like "ls -R /proc").
> 
> Where do you get a ns_capable call from "ls -R /proc" ?

E.g. if procfs is mounted with hidepid=2 then ls does
ptrace_may_access() check. 

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
