Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2EFUtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 16:49:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34247 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab2EFUtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 16:49:09 -0400
Date: Mon, 7 May 2012 00:49:04 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, khlebnikov@openvz.org,
        xemul@parallels.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: c/r: broken locking when executing map_files
Message-ID: <20120506204904.GA1912@moon>
References: <1335979380.10666.6.camel@lappy>
 <20120502172756.GD2301@moon>
 <20120503173125.GF19347@moon>
 <20120505182051.GA16029@albatros>
 <20120505185306.GB28746@moon>
 <20120505193201.GA2500@moon>
 <20120506202132.GA6570@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120506202132.GA6570@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 12:21:32AM +0400, Vasiliy Kulikov wrote:
> On Sat, May 05, 2012 at 23:32 +0400, Cyrill Gorcunov wrote:
> > On Sat, May 05, 2012 at 10:53:06PM +0400, Cyrill Gorcunov wrote:
> > > On Sat, May 05, 2012 at 10:20:51PM +0400, Vasiliy Kulikov wrote:
> > > > > -	if (lock_trace(task))
> > > > > +	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> > > > 
> > > > Probably it will be better to change mutex_lock_killable() to
> > > > mutex_lock_killable_nested() inside of lock_trace() instead of this change?
> > > > It would keep the race-free check.
> > > 
> > > Yup, if I'm not missing something SINGLE_DEPTH_NESTING should do the trick
> > > for us. I'll test and report.
> > 
> > Hmm, this doesn't work well, the mutex remanins killable so when one does
> 
> Does it show circular locking?  It shouldn't block if it uses
> mutex_lock+mutex_lock_nested.

Nope of course, once mutex_lock_nested called the kernel doesn't complain
anymore, but it rather sleep forever, until task killed, and that is wrong
i think. moreover, since executing from inside of map_files is special one
I think changing the whole lock_trace for this sake is a wrong approach.

> 
> >  | [root@neptune ~]# /proc/self/map_files/400000-419000
> > 
> > it sleeps forever until killed, which is not good I think. Vasiliy, could
> > you remind me what exactly is problem if we use unlocked ptrace_may_access
> > here?
> 
> There is a race between ptrace_may_access() and dname_to_vma_addr().
> The target task may do exec() between these calls and
> dname_to_vma_addr() will be called against a privileged task.  This may
> lead to a leak of task maps.

Wait, the proc_map_files_lookup requires the caller to be cap-sysadmin
granted, would not this be enough?

	Cyrill
