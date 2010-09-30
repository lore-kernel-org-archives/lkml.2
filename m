Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab0I3XVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:21:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46594 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab0I3XVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:21:09 -0400
Message-ID: <4CA51B61.8040404@kernel.org>
Date: Thu, 30 Sep 2010 16:21:05 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.7
MIME-Version: 1.0
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] cannot ssh to master.kernel.org
References: <871v8bgpgb.fsf@deeprootsystems.com>
In-Reply-To: <871v8bgpgb.fsf@deeprootsystems.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Thu, 30 Sep 2010 16:21:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey everyone,

So this morning we found 'master' basically spinning off the hook, with
a consistently high load [READ: around 160ish].  Needless to say, mail
was getting differed due to the load and I'm sure ssh was having similar
issues.

Several things were noticed on the system:

- Several cron jobs had spun up multiple copies of themselves, despite
locking being present in the jobs.  I'm not sure if they were attempting
to check the existing locks or if they were actually running through but
they were present.

- The loads were relatively high, but not seemingly because of disk i/o.
 There were a great number of processes in the run state.

- Attempting to explicitly kill may of the processes left the processes
in a zombie state, but were still consuming CPU resources.  Attempting
to kill them again did not result in the death of the processes, or the
relinquishing of the cpu resources.  Attempting to strace the process
yielded nothing of interest / use.  lsof on the zombie process did
return it's currently open file handles, including tcp connections.

- Disks all seemed to be readable and writeable.

- a sysrq+l dump of the system in this messed up state can be found at
http://pastebin.osuosl.org/35126 (this was originally requested by
Johannes Weiner)

- Perf was available in the kernel and userspace, however attempting to
run 'perf top' resulted in a stalled process sitting, seemingly, forever
in D+ state. (originally requested by Thomas Gleixner)

Considering that at one point running zombies that were eating cpu were
outnumbering the still running processes, the inability to get the loads
below 120 and the general mess of the machine, we finally bounced the
machine and let everything come back up.

One additional note, not necessarily related to the mess today, but
stuff we've been noticing.

- kswapd0 has been using a lot of cpu time.  I wouldn't be concerned
about this if it was say, 10% of a cpu, or maybe even 20% of a cpu for a
short time.  It has however been running in some cases at 100% cpu on a
single core for hours on end.  This seems to happen, in particular,
under slightly higher loads particularly relating to when there are a
number of rsyncs going on simultaneously.

Replicating the rsyncs on a nearly identical box, running an older
2.6.30 kernel, did not see this much cpu usage of kswapd0.  Johannes
Weiner was helping me look into it yesterday, but I don't think anything
was explicitly conclusive.

Anyway, thought I'd let everyone know what happened with the unexpected
outage this morning.  Things seem to have settled somewhat and the
machine is up.

- John 'Warthog9' Hawley

On 09/30/2010 09:34 AM, Kevin Hilman wrote:
> As of this morning, I can no longer ssh to master.kernel.org to push git
> trees.
> 
> Anyone else having ssh problems?
> 
> Kevin
> 
> _______________________________________________
> Users mailing list
> Users@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/users
