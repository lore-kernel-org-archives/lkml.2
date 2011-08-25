Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1HYQ7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:59:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab1HYQ7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:59:52 -0400
Date: Thu, 25 Aug 2011 18:56:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110825165650.GA8006@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-7-git-send-email-tj@kernel.org> <20110823155221.GB25808@redhat.com> <20110823194451.GH2803@mtj.dyndns.org> <20110824141431.GA8562@redhat.com> <20110825155957.GJ2803@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825155957.GJ2803@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Tejun Heo wrote:
>
> Yeah, what 'freeze' should do is a bit vague on the edges, I think.
> The freezer can't really halt the whole system operation including
> IOs.  Tasks aren't the only source which can kick those off.  There
> are other asynchronous sources,

Of course.

But still I can't understand why it is better to consider the exiting
task as "frozen" from the very beginning, right after PTRACE_EVENT_EXIT.
do_exit() does a lot of misc things, and this patch simply makes it
"invisible" to the freezer. This looks "unsafe" even if this is fine
for suspend/etc.

To me, try_to_freeze_tasks() should succed when all threads either
sleep in refrigerator(), or ->state = TASK_DEAD (the final schedule()
was called). Until then try_to_freeze_tasks() should retry.

But since we can't see the threads after exit_notify (in general),
the current ->exit_state check looks reasonable.

But again, again, I won't argue.

> Rafael, can you please enlighten
> us on the subject?

Please ;)

> Another freezer user is the cgroup,

Yes. And I don't understand this case too. I mean, the fact we ignore
the exiting tasks.

Oleg.

