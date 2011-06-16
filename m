Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab1FPRzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:55:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56140 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1FPRzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Kc8STXE4ZUDpeU4C7d0uFuNdV37bF3o/LlauO5/HcGgPw+24qhHByPHcMyxB+kNp7a
         bbgjDG5mop4ir5Xt4kpac8/MGVnrQKq3U99D9S6q6J2R4OAL2B1U99S7xFeIMygm+IIt
         HjMTm4RZT8FJ8x2fL0KIerL/k8OykFpBvl65Y=
MIME-Version: 1.0
In-Reply-To: <20110615145527.4016.70157.stgit@bahia.local>
References: <20110615145527.4016.70157.stgit@bahia.local>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 16 Jun 2011 13:54:57 -0400
Message-ID: <BANLkTimSC_OSrbekhM=wd2Gie4np3Q4F5A@mail.gmail.com>
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was Vpid:)
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, serge@hallyn.com, daniel.lezcano@free.fr,
        ebiederm@xmission.com, oleg@redhat.com, xemul@openvz.org,
        Cedric Le Goater <clg@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:55, Greg Kurz <gkurz@fr.ibm.com> wrote:
> Since pid namespaces were introduced, there's a recurring demand: how one
> can correlate a pid from a child pid ns with a pid from a parent pid ns ?
> The need arises in the LXC community when one wants to send a signal from
> the host (aka. init_pid_ns context) to a container process for which one
> only knows the pid inside the container.
>
> In the future, this should be achievable thanks to Eric Biederman's setns()
> syscall but there's still some work to be done to support pid namespaces:
>
> https://lkml.org/lkml/2011/5/21/162
>
> As stated by Serge Hallyn in:
>
> http://sourceforge.net/mailarchive/message.php?msg_id=27424447
>
> "There is nothing that gives you a 100% guaranteed correct race-free
> correspondence right now.  You can look under /proc/<pid>/root/proc/ to
> see the pids valid in the container, and you can relate output of
> lxc-ps --forest to ps --forest output.  But nothing under /proc that I
> know of tells you "this task is the same as that task".  You can't
> even look at /proc/<pid> inode numbers since they are different
> filesystems for each proc mount."
>
> This patch adds a single line to /proc/self/status. Provided one has kept
> track of its container tasks (with a cgroup like liblxc does for example),
> he may correlate global pids and container pids. This is still racy but
> definitely easier than what we have today.

Although getting the in-namespace PID is a useful thing, wouldn't a
truly race-free API be preferable? Any access by PID has the race
condition in which the target process could die, and its PID get
recycled between retrieving the PID and doing something with it.
Perhaps a file-descriptor API would be better, such as something like
this:

int openpid(int id, int flags);
int rt_sigqueueinfo_fd(int process_fd, int sig, siginfo_t *info);
int sigqueue_fd(int process_fd, int sig, const union sigval value); //
glibc wrapper

The opened process FD could be passed across a unix domain socket to a
process outside the namespace, which could then send signals without
knowing the in-namespace PID. This same API can be easily extended to
cover other syscalls which may require PIDs as well.
