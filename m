Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2AYHG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 02:06:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2AYHG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 02:06:56 -0500
Date: Tue, 24 Jan 2012 23:12:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [patch 3/4] c/r: procfs: add arg_start/end, env_start/end and
 exit_code members to /proc/$pid/stat
Message-Id: <20120124231245.e4c68f90.akpm@linux-foundation.org>
In-Reply-To: <20120125065450.GC2005@moon>
References: <20120123142036.025893883@openvz.org>
	<20120123142436.336126707@openvz.org>
	<20120124155941.4f7453d4.akpm@linux-foundation.org>
	<20120125065450.GC2005@moon>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012 10:54:50 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> > > +		(mm && permitted) ? mm->start_brk : 0,
> > > +		(mm && permitted) ? mm->arg_start : 0,
> > > +		(mm && permitted) ? mm->arg_end : 0,
> > > +		(mm && permitted) ? mm->env_start : 0,
> > > +		(mm && permitted) ? mm->env_end : 0,
> > > +		task->exit_code);
> > >  	if (mm)
> > >  		mmput(mm);
> > >  	return 0;
> > 
> > /proc/pid/stat is getting out of control.  People are now sending patches
> > because reading from this thing already takes too long.

err, actually, that was /proc/stat/

> > The problem is that if you only want one field, you have to incur the
> > cost of preparing all the fields.  The magnitude of this problem
> > increases exponentially over time!
> > 
> > I'm unsure what to do about it really.  Perhaps add a new
> > /proc/pid/mmstat for MM-specific things.  We could put the above six
> > fields in there, as long as we move quickly.
> > 
> 
> I can add prctl PR_GET_MM with subcodes, since PR_SET_MM is already here
> and wrapped with CHECKPOINT_RESTORE. Would this be better?

mm, not really - /proc is the logical/expected place for it.

I'm thinking that perhaps we should start again with all of this and
export all this information in brand new, well-designed procfs files. 
We'd still maintain /proc/stat and /proc/pid/stat but people should
migrate off them.  Eventually (10 years?) everyone will be setting their
CONFIG_PROC_[PID_]STAT to 'n' and perhaps we can retire the things.

Meanwhile, I suppose you may as well continue to make /proc/pid/stat
even crazier :(  It isn't as bad as /proc/stat!


btw, do we really need to do "(mm && permitted)" so many times?  ie,
can we split that seq_printf up and do

	if (mm && permitted) {
		seq_printf(m + offset, "%lu", mm->start_data);
		...
	} else {
		seq_printf(m + offset, "0 0 0 0 0 0 0 0 0");
	}

?  Although this probably won't help much.
