Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2AWQ0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:26:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab2AWQZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:25:59 -0500
Date: Mon, 23 Jan 2012 11:25:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123162553.GI25986@redhat.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123161619.GE12652@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 08:16:19AM -0800, Tejun Heo wrote:
> On Mon, Jan 23, 2012 at 11:10:42AM -0500, Vivek Goyal wrote:
> > This does not work well in hierachical management/scenario. Think that
> > a user gets an upper limit of 10MB/s on a device and now user can manage
> > its own children groups and divide allocated 10MB/s in children the way
> > he wants.
> > 
> > Now if root does the elevator switch, and saves all the rules (including
> > user's rules) and then restores back, these can very well race with
> > user's scripts of changing rules. If user changed a cgroup device rule
> > during elevator switch and after elevator switch root restored back
> > old rules, user's new rule will be lost leading to confusion.
> 
> It simply doesn't matter.  Just declare elvswitch and policy change
> reset blkcg configurations.  If some people are crazy enough to switch
> elevators regularly with full system running and parallel
> configuration going on, let them deal with synchronizing their
> scripts.

It does not have to be a regular switch. Even one switch during boot
can create issues. 

In RHEL we have the set of scripts which can do system tuning like based
on user chosen profile (tuned). These scripts do various things including
changing elevator. Once you have chosen the profile, it gets applied
automatically over every boot (through init scripts).

Now assume that after a reboot libvirtd is running and resuming various
suspended virtual machines or starting new one and in parallel this
profile is being applied. There is no way to avoid races as systemd allows
parallel execution of services. The only way left will be strong
serialization and that is no cgroup operation is taking place in the
system while some init script is chaning the elevator (no new cgroup
creatoin, no cgroup deletions and no rule settings by any daemon),
otherwise changes might be lost. In practice how would I program 
various init scripts for this?

Thanks
Vivek
