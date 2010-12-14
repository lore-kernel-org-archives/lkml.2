Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab0LNQYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:24:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759383Ab0LNQYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:24:36 -0500
Date: Tue, 14 Dec 2010 17:17:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 13/21] Freeze / Thaw threads
Message-ID: <20101214161702.GF11400@redhat.com>
References: <20101214152259.67896960@suzukikp> <20101214154504.7037c2c0@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214154504.7037c2c0@suzukikp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14, Suzuki K. Poulose wrote:
>
> @@ -148,6 +159,21 @@ static int open_gencore(struct inode *in
>  	list_add(&cp->list, &core_list);
>  	mutex_unlock(&core_mutex);
>
> +	/* freeze the processes */
> +	t = task;
> +	read_lock(&tasklist_lock);
> +	do {
> +		if (frozen(t) || !freezeable(t) || freezing(t))
> +			continue;
> +
> +		if (freeze_task(t, true))
> +			continue;
> +
> +		if (task_is_stopped_or_traced(t))
> +			continue;
> +	} while ((t = next_thread(t)) != task);
> +	read_unlock(&tasklist_lock);

Ooooh. Sorry, I dislike this approach very much.

Firstly, I can't understand why this can't race with the kernel
doing freeze/thaw.

But the main problem is: these series adds the new and nice way
to create the unkillable processes. This can't be good.

Say, until you close this file, even oom-killer can't kill it.
It is easy to DoS the system. Just fork the new processes which
use the memory and freeze them.

And, given that we have to handle task_is_stopped_or_traced()
tasks correctly anyway, I think gencore should rely on STOPPED/
TRACED and doesn't use freezer at all.

> +     } while ((t = next_thread(t)) != task);

while_each_thread()

Oleg.

