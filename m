Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2AWSnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:43:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55580 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2AWSnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:43:41 -0500
Date: Mon, 23 Jan 2012 10:43:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123184336.GI12652@google.com>
References: <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
 <20120123162553.GI25986@redhat.com>
 <20120123171049.GH12652@google.com>
 <20120123182745.GK25986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123182745.GK25986@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 01:27:45PM -0500, Vivek Goyal wrote:
> > Why can't systemd order elevator switch before other actions?
> 
> Because systemd does not know. For systemd it is just launching services
> and what services are doing is not known to systemd.
> 
> I think systemd does have some facilities so that services can express
> dependency on other services and dependent service blocks on completion
> of service it is depenent on. So may be in this case any service dealing
> with cgroups shall have to be dependent on this service which tunes
> the system and changes elevator.

I'm sure systemd has enough facility for expressing this dependency.
Where this configuration belongs to is a different question tho.  I
don't know how the tuned thing works but configurations like this are
bound to devices and should be part of device discovery / hotplug
sequence.  IOW, it should be something which ultimately runs off udev
events as part of device found event.

> > 1. Regardless of persistency granularity, which policies are enabled
> >    for a device must be determined before configuring the policies.
> >    The policy_node stuff worked around this by keeping per-policy
> >    configurations in the core separately violating proper layering and
> >    any usual conventions.  It's like keeping ata_N_conf or eth_N_conf
> >    in kernel for devices which may appear in the future.  It's silly
> >    at best.
> 
> Agreed. I understand now that keeping configuration around in kernel for
> non-existent devices is not a good idea. So ripping the rules upon 
> device tear down makes sense.

Yeah, the kernel doesn't even have a way to reliably match
configurations to devices consistently.  Good that we agree on this.

> > 2. The granularity of configuration reset is a separate issue and it
> >    might make sense to do it fine-grained if that is important enough,
> >    but given how elv/pol changes are used, I am very skeptical this is
> >    necessary.
> > 
> > No matter what we do for #2, #1 requires ordering between policy
> > selection and configuration.  You're saying that #2, combined with the
> > fact that blk-throtl can't be built as module or disabled on runtime,
> > allows side-stepping the issue for at least blk-throtl.  That doesn't
> > sound like a good idea to me.  People are working on different
> > elevators implementing different cgroup strategies.  There is no sane
> > way around requiring "choosing of policies" to happen before
> > "configuration of chosen policies".
> 
> I agree on #1 and that is choosing policy before configuring it.
> 
> I am concerned about silently removing the configuration of policy A
> while some unrelated policy B is going away and user space is asked
> to handle it.
> 
> It is equivalent of saying that changing IO scheduler also resets all
> the request queue tunables to default and now user space script is
> supposed to set them back to user configured value. Or write a user space
> script which first saves all the request queue tunables, changes the elevator
> and then restores it back.

Yeah, this is much more arguable.  I don't think it would be too
complex to keep per-policy granularity even w/ unified blkg managed by
blkcg core (we'll just need to point to separately allocated
per-policy data from the unified blkg and clear them selectively).
I'm just not convinced of its necessity.  With initial config out of
the way, elvs and blkcg policies don't get molested all that often.

I'll see how complex it actually gets.  If it isn't too much
complexity, yeah, why not...

-- 
tejun
