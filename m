Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2AWS1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:27:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab2AWS1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:27:53 -0500
Date: Mon, 23 Jan 2012 13:27:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123182745.GK25986@redhat.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
 <20120123162553.GI25986@redhat.com>
 <20120123171049.GH12652@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123171049.GH12652@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 09:10:49AM -0800, Tejun Heo wrote:
> On Mon, Jan 23, 2012 at 11:25:53AM -0500, Vivek Goyal wrote:
> > It does not have to be a regular switch. Even one switch during boot
> > can create issues. 
> > 
> > In RHEL we have the set of scripts which can do system tuning like based
> > on user chosen profile (tuned). These scripts do various things including
> > changing elevator. Once you have chosen the profile, it gets applied
> > automatically over every boot (through init scripts).
> >
> > Now assume that after a reboot libvirtd is running and resuming various
> > suspended virtual machines or starting new one and in parallel this
> > profile is being applied. There is no way to avoid races as systemd allows
> > parallel execution of services. The only way left will be strong
> > serialization and that is no cgroup operation is taking place in the
> > system while some init script is chaning the elevator (no new cgroup
> > creatoin, no cgroup deletions and no rule settings by any daemon),
> > otherwise changes might be lost. In practice how would I program 
> > various init scripts for this?
> 
> Why can't systemd order elevator switch before other actions?

Because systemd does not know. For systemd it is just launching services
and what services are doing is not known to systemd.

I think systemd does have some facilities so that services can express
dependency on other services and dependent service blocks on completion
of service it is depenent on. So may be in this case any service dealing
with cgroups shall have to be dependent on this service which tunes
the system and changes elevator.

CCing lennart for more info on systemd.

>  It's
> not really about switching elevators but about having set of applied
> policies set before configuring them.
> 
> It is natural to require the target of configuration to be set up
> before configuring it, right?  You can't set attributes on eth0 or sda
> when those don't exist.  This isn't very different.  You need to have
> set of policies and their parameters defined before going ahead with
> their configurations and there naturally is ordering between the two
> steps - e.g. it doesn't make any sense and is actually misleading to
> allow configuration of propio when the elevator in choice doesn't
> provide it.
> 
> Of course, details of such ordering requirement including granularity
> have to be decided and we can decide that keeping things at per-policy
> granularity is important enough to justify extra complexity, which I
> don't think is the case here.
> 
> There are two separate points here.
> 
> 1. Regardless of persistency granularity, which policies are enabled
>    for a device must be determined before configuring the policies.
>    The policy_node stuff worked around this by keeping per-policy
>    configurations in the core separately violating proper layering and
>    any usual conventions.  It's like keeping ata_N_conf or eth_N_conf
>    in kernel for devices which may appear in the future.  It's silly
>    at best.

Agreed. I understand now that keeping configuration around in kernel for
non-existent devices is not a good idea. So ripping the rules upon 
device tear down makes sense.

> 
> 2. The granularity of configuration reset is a separate issue and it
>    might make sense to do it fine-grained if that is important enough,
>    but given how elv/pol changes are used, I am very skeptical this is
>    necessary.
> 
> No matter what we do for #2, #1 requires ordering between policy
> selection and configuration.  You're saying that #2, combined with the
> fact that blk-throtl can't be built as module or disabled on runtime,
> allows side-stepping the issue for at least blk-throtl.  That doesn't
> sound like a good idea to me.  People are working on different
> elevators implementing different cgroup strategies.  There is no sane
> way around requiring "choosing of policies" to happen before
> "configuration of chosen policies".

I agree on #1 and that is choosing policy before configuring it.

I am concerned about silently removing the configuration of policy A
while some unrelated policy B is going away and user space is asked
to handle it.

It is equivalent of saying that changing IO scheduler also resets all
the request queue tunables to default and now user space script is
supposed to set them back to user configured value. Or write a user space
script which first saves all the request queue tunables, changes the elevator
and then restores it back.

Thanks
Vivek
