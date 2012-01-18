Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab2AROmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:42:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757749Ab2AROmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:42:53 -0500
Date: Wed, 18 Jan 2012 15:36:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children
	entry v6
Message-ID: <20120118143631.GA11776@redhat.com>
References: <20120116153231.GF2998@moon> <4F15EA53.8030405@gmail.com> <20120118135809.GA10105@redhat.com> <20120118142156.GR1968@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118142156.GR1968@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18, Cyrill Gorcunov wrote:
>
> So Oleg, I think you meant something like below? Comment is moved down an
> list_empty over siblings remans, right?

Yes, except the comment still looks misleading to me.

Otherwise looks correct, but I'll try to re-check once again with
the fresh head. Although I think you should remove me from CC: after
I found the nonexistent bug ;)

> +get_children_pid(struct proc_pid_children_iter *iter, struct pid *pid_prev, loff_t pos)
> +{
> ...
> +	/*
> +	 * Slow search case
> +	 *
> +	 * We might miss some freshly created children
> +	 * here, but it was never promised to be
> +	 * accurate.
> +	 */
> +	list_for_each_entry(task, &start->children, sibling) {
> +		if (pos-- == 0) {
> +			pid = get_pid(task_pid(task));
> +			break;
> +		}
> +	}

This is minor, but "freshly created" looks very confusing to me.
What does it mean? We hold tasklist, we can't race with fork().

Yes we can miss a child, but this has nothing to do with "freshly".
Just suppose that the parent sleeps, but N children exit after we
printed their tids. Now the slow paths skips N extra children, we
miss N tasks.

Oleg.

