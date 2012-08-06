Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2HFTXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:23:36 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:54790 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab2HFTXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:23:35 -0400
Date: Mon, 6 Aug 2012 19:24:46 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Forbid invocation of kexec_load() outside initial PID
 namespace
Message-ID: <20120806192446.GA29269@mail.hallyn.com>
References: <1343991184-3619-1-git-send-email-berrange@redhat.com>
 <20120806190014.GA15267@mail.hallyn.com>
 <87r4rjn84y.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4rjn84y.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Quoting Daniel P. Berrange (berrange@redhat.com):
> >> From: "Daniel P. Berrange" <berrange@redhat.com>
> >> 
> >> The following commit
> >> 
> >>     commit cf3f89214ef6a33fad60856bc5ffd7bb2fc4709b
> >>     Author: Daniel Lezcano <daniel.lezcano@free.fr>
> >>     Date:   Wed Mar 28 14:42:51 2012 -0700
> >> 
> >>     pidns: add reboot_pid_ns() to handle the reboot syscall
> >> 
> >> introduced custom handling of the reboot() syscall when invoked
> >> from a non-initial PID namespace. The intent was that a process
> >> in a container can be allowed to keep CAP_SYS_BOOT and execute
> >> reboot() to shutdown/reboot just their private container, rather
> >> than the host.
> >> 
> >> Unfortunately the kexec_load() syscall also relies on the
> >> CAP_SYS_BOOT capability. So by allowing a container to keep
> >> this capability to safely invoke reboot(), they mistakenly
> >> also gain the ability to use kexec_load(). The solution is
> >> to make kexec_load() return -EPERM if invoked from a PID
> >> namespace that is not the initial namespace
> >> 
> >> Signed-off-by: Daniel P. Berrange <berrange@redhat.com>
> >> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> >
> > Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> >
> > (Please see my previous email explaining why I believe the pidns
> > is an appropriate check)
> 
> Serge as to your objects.
> 
> If we define kexec_load in terms of the pid namespace then something
> makes sense, but the error should be EINVAL, or something of that sort.

Makes sense.

> That is what we did with reboot.  We defined reboot in terms of the pid
> namespace.
> 
> Not defining kexec_load in terms of the pid namespace and then returning
> EPERM because having we happen to have CAP_SYS_BOOT for other reasons is
> semantically horrible.
> 
> At the end of the day the effect is the same, but I think it matters a
> great deal in how we think about things.
> 
> We have CAP_SYS_BOOT in the initial user namespace.  We do have
> permission to make the system call.
> 
> So I continue to see this patch the way it is current constructed as
> broken.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

I do also prefer splitting the capability.  Michael Kerrisk, do you
have any good suggestions for better names than CAP_RESTART (for
killing or restarting /sbin/init) and CAP_BOOT (for kexec and/or
hardware resets)?  Maybe CAP_RESTART_USER and CAP_RESTART_HW?
(CAP_SYS_BOOT being an alias for both for backward compatibility)
