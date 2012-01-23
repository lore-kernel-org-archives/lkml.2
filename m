Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2AWRK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:10:56 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:36204 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091Ab2AWRKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:10:55 -0500
Date: Mon, 23 Jan 2012 09:10:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123171049.GH12652@google.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
 <20120123162553.GI25986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123162553.GI25986@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 11:25:53AM -0500, Vivek Goyal wrote:
> It does not have to be a regular switch. Even one switch during boot
> can create issues. 
> 
> In RHEL we have the set of scripts which can do system tuning like based
> on user chosen profile (tuned). These scripts do various things including
> changing elevator. Once you have chosen the profile, it gets applied
> automatically over every boot (through init scripts).
>
> Now assume that after a reboot libvirtd is running and resuming various
> suspended virtual machines or starting new one and in parallel this
> profile is being applied. There is no way to avoid races as systemd allows
> parallel execution of services. The only way left will be strong
> serialization and that is no cgroup operation is taking place in the
> system while some init script is chaning the elevator (no new cgroup
> creatoin, no cgroup deletions and no rule settings by any daemon),
> otherwise changes might be lost. In practice how would I program 
> various init scripts for this?

Why can't systemd order elevator switch before other actions?  It's
not really about switching elevators but about having set of applied
policies set before configuring them.

It is natural to require the target of configuration to be set up
before configuring it, right?  You can't set attributes on eth0 or sda
when those don't exist.  This isn't very different.  You need to have
set of policies and their parameters defined before going ahead with
their configurations and there naturally is ordering between the two
steps - e.g. it doesn't make any sense and is actually misleading to
allow configuration of propio when the elevator in choice doesn't
provide it.

Of course, details of such ordering requirement including granularity
have to be decided and we can decide that keeping things at per-policy
granularity is important enough to justify extra complexity, which I
don't think is the case here.

There are two separate points here.

1. Regardless of persistency granularity, which policies are enabled
   for a device must be determined before configuring the policies.
   The policy_node stuff worked around this by keeping per-policy
   configurations in the core separately violating proper layering and
   any usual conventions.  It's like keeping ata_N_conf or eth_N_conf
   in kernel for devices which may appear in the future.  It's silly
   at best.

2. The granularity of configuration reset is a separate issue and it
   might make sense to do it fine-grained if that is important enough,
   but given how elv/pol changes are used, I am very skeptical this is
   necessary.

No matter what we do for #2, #1 requires ordering between policy
selection and configuration.  You're saying that #2, combined with the
fact that blk-throtl can't be built as module or disabled on runtime,
allows side-stepping the issue for at least blk-throtl.  That doesn't
sound like a good idea to me.  People are working on different
elevators implementing different cgroup strategies.  There is no sane
way around requiring "choosing of policies" to happen before
"configuration of chosen policies".

-- 
tejun
