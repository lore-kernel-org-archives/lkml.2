Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2DXPIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:08:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59497 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2DXPIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:08:34 -0400
Message-ID: <1335280075.28150.202.camel@twins>
Subject: Re: [PATCH 10/16] sched: add resource limits for -deadline tasks.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Tue, 24 Apr 2012 17:07:55 +0200
In-Reply-To: <1333696481-3433-11-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-11-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> From: Dario Faggioli <raistlin@linux.it>
> 
> Add resource limits for non-root tasks in using the SCHED_DEADLINE
> policy, very similarly to what already exists for RT policies.
> 
> In fact, this patch:
>  - adds the resource limit RLIMIT_DLDLINE, which is the minimum value
>    a user task can use as its own deadline;
>  - adds the resource limit RLIMIT_DLRTIME, which is the maximum value
>    a user task can use as it own runtime.
> 
> Notice that to exploit these, a modified version of the ulimit
> utility and a modified resource.h header file are needed. They
> both will be available on the website of the project.
> 
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>

I'm not sure this is the right way to go.. those existing things aren't
entirely as useful/sane as one might hope either.

The DLDLINE minimum is ok I guess, the DLRTIME one doesn't really do
anything, by spawning multiple tasks one can still saturate the cpu and
thus we have no effective control for unpriv users.

Ideally DLRTIME would be a utilization cap per user and tracked in
user_struct such that we can enforce a max utilization per user.

This also needs a global (and possibly per-cgroup) user limit too to cap
the total utilization of all users (excluding root) so that multiple
users cannot combine their efforts in order to bring down the machine.

In light of these latter controls the per-user control might be
considered optional, furthermore I don't particularly like the rlimit
infrastructure but I guess its the best we have for per-user like things
if indeed we want to go there.


