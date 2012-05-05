Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab2EETcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:32:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53689 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab2EETcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:32:05 -0400
Date: Sat, 5 May 2012 23:32:01 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, khlebnikov@openvz.org,
        xemul@parallels.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: c/r: broken locking when executing map_files
Message-ID: <20120505193201.GA2500@moon>
References: <1335979380.10666.6.camel@lappy>
 <20120502172756.GD2301@moon>
 <20120503173125.GF19347@moon>
 <20120505182051.GA16029@albatros>
 <20120505185306.GB28746@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120505185306.GB28746@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 10:53:06PM +0400, Cyrill Gorcunov wrote:
> On Sat, May 05, 2012 at 10:20:51PM +0400, Vasiliy Kulikov wrote:
> ...
> > > ---
> > >  fs/proc/base.c |    8 +++-----
> > >  1 file changed, 3 insertions(+), 5 deletions(-)
> > > 
> > > Index: linux-2.6.git/fs/proc/base.c
> > > ===================================================================
> > > --- linux-2.6.git.orig/fs/proc/base.c
> > > +++ linux-2.6.git/fs/proc/base.c
> > > @@ -2226,16 +2226,16 @@ static struct dentry *proc_map_files_loo
> > >  		goto out;
> > >  
> > >  	result = ERR_PTR(-EACCES);
> > > -	if (lock_trace(task))
> > > +	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> > 
> > Probably it will be better to change mutex_lock_killable() to
> > mutex_lock_killable_nested() inside of lock_trace() instead of this change?
> > It would keep the race-free check.
> 
> Yup, if I'm not missing something SINGLE_DEPTH_NESTING should do the trick
> for us. I'll test and report.

Hmm, this doesn't work well, the mutex remanins killable so when one does

 | [root@neptune ~]# /proc/self/map_files/400000-419000

it sleeps forever until killed, which is not good I think. Vasiliy, could
you remind me what exactly is problem if we use unlocked ptrace_may_access
here?

	Cyrill
