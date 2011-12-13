Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1LMUou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:44:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab1LMUor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:44:47 -0500
Message-ID: <4EE7B926.9030702@redhat.com>
Date: Tue, 13 Dec 2011 15:44:22 -0500
From: Daniel J Walsh <dwalsh@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Tim Hockin <thockin@hockin.org>, LKML <linux-kernel@vger.kernel.org>,
        Ben Blum <bblum@andrew.cmu.edu>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>, Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -mm] cgroup: Fix task counter common ancestor logic
References: <1320765670-14181-1-git-send-email-fweisbec@gmail.com> <20111108135111.6a74f1d2.akpm@linux-foundation.org> <20111124132442.GA18579@somewhere.redhat.com>
In-Reply-To: <20111124132442.GA18579@somewhere.redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/24/2011 08:24 AM, Frederic Weisbecker wrote:
> On Tue, Nov 08, 2011 at 01:51:11PM -0800, Andrew Morton wrote:
>> On Tue,  8 Nov 2011 16:21:10 +0100 Frederic Weisbecker
>> <fweisbec@gmail.com> wrote:
>> 
>>> To solve this, keep the original cgroup of each thread in the
>>> thread group cached in the flex array and pass it to
>>> can_attach_task()/attach_task() and cancel_attach_task() so
>>> that the correct common ancestor between the old and new cgroup
>>> can be safely retrieved for each task.
>> 
>> OK, thanks.
>> 
>> We need to work out what to do with this patchset.  ie: should we
>> merge it.  I'm not sure that the case has been made?
>> 
>> Let's please drag this thing onto the table and poke at it for a
>> while. Probably everyone has forgotten everything so we'll need
>> to start again, sorry.  Perhaps you can (re)start proceedings by
>> telling us why it's useful to our users and why we should merge
>> it?
> 
> Right, so the main purpose is to have a suitable forkbomb
> protection in the lxc containers. It seems that these days, using
> NR_PROC rlimit is the prime choice to protect against forkbombs.
> But we can't use this for containers because if they run under the
> same user, they can starve each others by generating high number of
> processes. So we need the limit on number of processes to be per
> container.
> 
> The basic requirement is to be able to run untrustee process inside
> a container while protecting against attacks from there without
> impacting the rest of the system.
> 
> I'm adding in Cc some Lxc people who could perhaps provide more
> details and testify we really need this.
> 
>> Some mental notes:
>> 
>> Tim says it would be useful for the things he's doing but
>> doesn't appear to have confirmed/tested that.
> 
> Yeah, I'm waiting for more details from him. Tim?
> 
>> Kay has said that it would not be useful for his plumber's
>> wishlist item, which is a shame.
> 
> Indeed. I mean it would work but this cgroup subsystem is too much
> overhead to be used by an init process (and then all other
> processes).
> 
>> I seem to recall complaining that it doesn't address the forkbomb
>> issue for non-cgroups setups, so the forkbomb issue remains
>> unaddressed.
> 
> Right. Now if we can find a generic solution to protect against all
> forkbombs, something deterministic that can react soon enough so
> that it doesn't impact the rest of system, in order to avoid
> running into some DDOS, then we will consider it.
> 
> Thanks.


I have heard that this is being held up because of a lack of
justification.  Here is my attempt.  I would like to use the ability
to prevent a fork bomb and guaranteed killall for three different
tools that I work on.

1.  Kiosk/xguest user.  Currently we tell people to log out of a
system on the kiosk and the pam stack attempts to kill all processes
running in the kiosk user session.  The kiosk user is not allowed to
login to the system if a process is still running as the user.  The
reason for this is we want to guarantee no previous user left a trojan
process waiting to track your activity.  If the login program can not
kill all user processes at logout, then the next user will not be able
to login.

2.  Sandbox Desktop tools are used to write one or more processes
within a lockeddown environment.  The idea here is to run untrusted
code and potentially this code could trigger a fork bomb, you want to
be able to kill the session.

3.  Secure containers, similarly to sandboxes allow users to run
multiple Linux Containers in a locked down manner.  We would like to
be guaranteed that we can kill all processes within a secure
containers at exit.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7nuSYACgkQrlYvE4MpobMY1ACgmZ/P8LbVTHBrOQUsh6xL5Qy2
scsAoK641lrpZkX8DB1JETpKT6jfWe5i
=E93Z
-----END PGP SIGNATURE-----
