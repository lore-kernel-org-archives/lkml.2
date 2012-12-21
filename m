Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2LUPCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:02:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab2LUPCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:02:36 -0500
Date: Fri, 21 Dec 2012 16:02:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 07/11] pidns: Wait in zap_pid_ns_processes until
	pid_ns->nr_hashed == 1
Message-ID: <20121221150238.GA16003@redhat.com>
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-7-git-send-email-ebiederm@xmission.com> <20121219184757.GB22991@redhat.com> <87bodourqt.fsf@xmission.com> <20121221141133.GA13805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121221141133.GA13805@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Oleg Nesterov wrote:
>
> And in fact I think this is not strange, but simply wrong.
>
> Please consider the XXX case above. Suppose that free_pid(P) happens
> after ns->child_reaper exits and thus this pointer points to nowhere.
> Suppose also that there is another injected pid so nr_hashed == 2.
> In this case wake_up_process(ns->child_reaper) means use-after-free,
> no?

Hmm. And another minor problem, unless I missed something.

Once again, the parent namespace injects the task T after ns->reaper
sees nr_hashed == 1 and returns. Suppose that reaper's parent does
do_wait() and free_pidmap() clears the bit == 1.

Now, what if T doesn't exit but forks? We must not re-create the
task with pid_nr == 1 in the dead namespace. Normally this can't
happen, RESERVED_PIDS logic in alloc_pidmap() saves us. But it
seems that we need

	- .extra1 = &zero,
	+ .extra1 = &one,

in pid_ns_ctl_table.

Oleg.

