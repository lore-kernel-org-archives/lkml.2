Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956Ab2JXTym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:54:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2JXTyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:54:40 -0400
Date: Wed, 24 Oct 2012 12:54:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
Message-Id: <20121024125439.c17a510e.akpm@linux-foundation.org>
In-Reply-To: <20121024062938.GA6119@dhcp22.suse.cz>
References: <20121012125708.GJ10110@dhcp22.suse.cz>
	<20121023164546.747e90f6.akpm@linux-foundation.org>
	<20121024062938.GA6119@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 08:29:45 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> > >
> > > +		printk(KERN_NOTICE "%s (%d): dropped kernel caches: %d\n",
> > > +			current->comm, task_pid_nr(current), sysctl_drop_caches);
> > 
> > urgh.  Are we really sure we want to do this?  The system operators who
> > are actually using this thing will hate us :(
> 
> I have no problems with lowering the priority (how do you see
> KERN_INFO?) but shouldn't this message kick them that they are doing
> something wrong? Or if somebody uses that for "benchmarking" to have a
> clean table before start is this really that invasive?

hmpf.  This patch worries me.  If there are people out there who are
regularly using drop_caches because the VM sucks, it seems pretty
obnoxious of us to go dumping stuff into their syslog.  What are they
supposed to do?  Stop using drop_caches?  But that would unfix the
problem which they fixed with drop_caches in the first case.

And they might not even have control over the code - they need to go
back to their supplier and say "please send me a new version", along
with all the additional costs and risks involed in an update.

> > More friendly alternatives might be:
> > 
> > - Taint the kernel.  But that will only become apparent with an oops
> >   trace or similar.
> > 
> > - Add a drop_caches counter and make that available in /proc/vmstat,
> >   show_mem() output and perhaps other places.
> 
> We would loose timing and originating process name in both cases which
> can be really helpful while debugging. It is fair to say that we could
> deduce the timing if we are collecting /proc/meminfo or /proc/vmstat
> already and we do collect them often but this is not the case all of the
> time and sometimes it is important to know _who_ is doing all this.

But how important is all that?  The main piece of information the
kernel developer wants is "this guy is using drop_caches a lot".  All
the other info is peripheral and can be gathered by other means if so
desired.
