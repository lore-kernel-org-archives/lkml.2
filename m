Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232Ab2JKDet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 23:34:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46434 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932783Ab2JKDer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 23:34:47 -0400
X-Sasl-enc: YyVZIkC+7iBZ9uMXyMKC119otMNG2GggSDyfuOLV1y10 1349926486
Message-ID: <1349926483.2371.35.camel@perseus.themaw.net>
Subject: Re: [PATCH 0/2] struct pid-ify autofs4
From: Ian Kent <raven@themaw.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, autofs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sukadev@linux.vnet.ibm.com, serge.hallyn@canonical.com
Date: Thu, 11 Oct 2012 11:34:43 +0800
In-Reply-To: <87mx0estch.fsf@xmission.com>
References: <1348068576-21363-1-git-send-email-miklos@szeredi.hu>
	 <87haqrwfbj.fsf@tucsk.pomaz.szeredi.hu>
	 <1348447130.2318.1.camel@perseus.themaw.net>
	 <87d31bczo7.fsf@tucsk.pomaz.szeredi.hu>
	 <1348537604.2307.8.camel@perseus.themaw.net> <87mx0estch.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 19:56 -0700, Eric W. Biederman wrote:
> Ian Kent <raven@themaw.net> writes:
> 
> > On Mon, 2012-09-24 at 15:34 +0200, Miklos Szeredi wrote:
> >> Ian Kent <raven@themaw.net> writes:
> >> 
> >> > On Fri, 2012-09-21 at 17:44 +0200, Miklos Szeredi wrote:
> >> >> Miklos Szeredi <miklos@szeredi.hu> writes:
> >> >> 
> >> >> > These two patches change autofs4 to store struct pid pointers instead of pid_t
> >> >> > values.
> >> >> >
> >> >> > Fixed various issues with the previous post.  Not tested, handle with
> >> >> > care!
> >> >> 
> >> >> Customer gave positive test results.
> >> >
> >> > For what exactly, there's no problem description in these patches?
> >> 
> >> From what I understand (and I'm not an expert by any means) is that
> >> autofs doesn't work if containers are used.  The first patch fixes this.
> >
> > Yeah, the problem with that is that "autofs doesn't work if containers
> > are used" is ill defined since there are use cases where it does, I
> > believe. At the very least, ill defined in my view of things.
> 
> An easy complaint is that task->pid and task->tgid are deprecated fields
> in the task structure.  Things that use pids should in use struct pid
> values instead.

Yes, we do need to fix that.

> 
> The trick part of using struct pid values is that there are times when
> you need to interact with userspace.  And the question is which pid
> namespace is your userspace process in so that you can convert
> to and from the proper pid namespace.
> 
> The pgrp option on the mount of autofs is buggy because the pid
> namespace of the process group is not captured at the time of mount
> and so userspace could think it is talking about one process group
> while autofs is talking about another process group.  This is a
> practical problem if the process that mounts autofs is not running
> in the initial pid namespace.

Yep.

> 
> There is a second question.  What happens if the oz_pgrp exists
> and then pids wrap around and another process uses the same process
> group number.  Currently the autofs code will treat the new proces
> group like the old one leading to unexpected behavior.  Which I believe
> will be autofs mounts not happening when desired.

OK, but I think your saying a process in another namespace could then
use that process group number or the daemon would need to be SIGKILLed
in the initial namespace.

> 
> Another problem is what happens when a process triggers an automount.
> Today we will report the pid and the tgid in the initial pid namespace
> of the process that triggered the mount.
> 
> So what I can see is that today if the process that mounts autofs
> (aka the process at the other end of the autofs pipe) is not in
> the initial pid namespace things will go awry, as autofs will report
> pid values that make no sense to anyone.

Yep, I get that too.

> 
> I would like to say the patches fix that problem (and they come close)
> however they still translate everything into the initial pid namespace.

I think it's a little more difficult to do than it appears since
multiple namespace behavior is not defined for autofs.

For example, suppose we had the situation where the correct namespace
was always used and another instance of automount was run within a
namespace using different maps. When the namespace is created we could
get autofs mounts from the initial namespace which the daemon won't know
how to handle so they would need to be umounted before the new daemon is
started. Since that isn't automated as part of namespace creation it
almost certainly would lead to complains and lots of confusion.

At the moment it seems best to restrict interactions to a single daemon
in the initial namespace until specific behavioral requirements are
clear.

> 
> > But I can't even sensibly discuss it because of the lack of specified
> > use cases and requirements for each. So, there's a chance this will
> > break another case that does work.
> 
> That seems to be a reasonable concern.  Education so that the
> differences in the code are comprehensible.
> 
> I am also curious about which case people were seeing problems with as
> these patches were reported to be tested and to have fixed a customer
> problem.  The only case that is particularly clear to me that these
> patches will fix is the case of process group wrap around, but proces
> group wrap around should be exceedingly rare.

This comment arose because of a bug report regarding lxc not working
with automount. It had an accompanying patch that had a couple of hunks
from an unrelated patch and I think most of what is in the patches here.
My initial reaction was caution since I don't want to break what now
functions OK with what was a suspect patch.

If that change is done in RHEL it would have to be a back port of these
patches since it is clearer what they are trying to achieve and I
believe they would not break existing function.

> 
> To handle mounts made outside of the initial pid namespace it appears
> that all that is needed is to caputure the pid namespace of the process
> that mounts autofs and uses pid_nr_ns to format pids into that
> namespace, inside of autofs

Unfortunately, I think that is just the start of what's needed.

I think the example above should be enough to show that there's a need
to define semantic behavior and usage restrictions before trying to code
a solution and that's not entirely straight forward.
 
> 
> It is my feeling that in addition to capture oz_pgrp on mount the
> automount and autofs_dev_ioctl_set_pipefd should capture a pid namespace
> for formating pids delivered into the pipe.  That would allow the
> automount process itself to live outside of the initial pid namespace.

I think this should be safe enough and is a good idea to do by itself.

We would need to be careful not to "sell" it as a multiple namespace use
fix though, as it would probably look like that to others.

Ian

