Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab1CVPJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:09:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab1CVPJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:09:13 -0400
Date: Tue, 22 Mar 2011 11:09:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, mrubin@google.com,
        teravest@google.com
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
Message-ID: <20110322150905.GD3757@redhat.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300756245-12380-1-git-send-email-ctalbott@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 06:10:42PM -0700, Chad Talbott wrote:
> This patchset introduces fair cross-group preemption.  Right now, we
> don't have strict isolation between processes in different cgroups.
> For example: currently an RT ioprio thread in one group can preempt a
> BE ioprio thread in another group.  We would like to have an
> application specify the relative priorities of its threads, but still
> allow strict isolation between applications.
> 
> With this patch series, we can configure an entire cgroup as needing
> low-latency service.  Then that group will be able to preempt another
> group.  To prevent a runaway application from starving other
> applications, we allow this preemption only until it has exceeded its
> fair share (as specified by its relative weight).  So a rate-limited,
> but latency sensative application (like streaming audio or video) can
> get front-of-the-line service without fear of it hogging a whole
> disk's IO.

Chad,

Why not just implement simply RT class groups and always allow an RT
group to preempt an BE class. Same thing we do for cfq queues. I will
not worry too much about a run away application consuming all the 
bandwidth. If that's a concern we could use blkio controller to limit
the IO rate of a latency sensitive applicaiton to make sure it does
not starve BE applications.

If RT starving BE is an issue, then it is an issue with plain cfq queue
also. First we shall have to fix it there.

This definition that a latency sensitive task get prioritized only
till it is consuming its fair share and if task starts using more than
fair share then CFQ automatically stops prioritizing it sounds little
odd to me. If you are looking for predictability, then we lost it. We
shall have to very well know that task is not eating more than its
fair share before we can gurantee any kind of latencies to that task. And
if we know that task is not hogging the disk, there is anyway no risk
of it starving other groups/tasks completely.

Or we could implement something where once in a while we do allow BE
class tasks to dispatch some IO so that RT tasks do not completely
starve BE class tasks. I guess this will be similar to what cpu scheduler
was trying where an RT tasks got 95% of cpu and 5% bandwidth was reserved
for admin to kill RT tasks if some RT tasks goes wild and locks up the
cpus.

Thanks
Vivek
