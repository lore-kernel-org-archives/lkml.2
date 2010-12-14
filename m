Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab0LNQLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:11:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502Ab0LNQLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:11:54 -0500
Date: Tue, 14 Dec 2010 17:04:21 +0100
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
Subject: Re: [Patch 11/21] Track the core generation requests
Message-ID: <20101214160421.GD11400@redhat.com>
References: <20101214152259.67896960@suzukikp> <20101214154204.21048247@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214154204.21048247@suzukikp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14, Suzuki K. Poulose wrote:
>
> Concurrent core generation requests
> for the same target process are not allowed.

OK, but

> +static struct core_proc* get_core_proc(struct task_struct *t)
> +{
> +	struct core_proc *cp;
> +
> +	list_for_each_entry(cp, &core_list, list) {
> +		if (cp->task == t->group_leader)
> +			return cp;
> +	}
> +	return NULL;
> +}
> ...
>  static int open_gencore(struct inode *inode, struct file *filp)
>  {
> -	return 0;
> +	struct task_struct *task = get_proc_task(inode);
> +	struct core_proc *cp;
> +	int ret = 0;
> +
> +	if (!task)
> +		return -ENOENT;
> +
> +	mutex_lock(&core_mutex);
> +	cp = get_core_proc(task);
> +	if (cp) {
> +		ret = -EALREADY;

I don't think this can work.

The task can change ->group_leader. This means 2 or more
open_gencore() can succeed if this task execs in between.

Oleg.

