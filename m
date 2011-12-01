Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1LAV3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:29:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1LAV3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:29:13 -0500
Date: Thu, 1 Dec 2011 13:29:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in
 /proc/<pid>/status
Message-Id: <20111201132911.e20f1fa3.akpm@linux-foundation.org>
In-Reply-To: <20111201095434.GR14515@moon>
References: <20111129191252.769160532@openvz.org>
	<20111129191638.835932727@openvz.org>
	<20111130140009.1ccd5af0.kamezawa.hiroyu@jp.fujitsu.com>
	<20111130060537.GK1775@moon>
	<20111201095434.GR14515@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011 13:54:34 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> +int proc_pid_children(struct seq_file *m, struct pid_namespace *ns,
> +		      struct pid *pid, struct task_struct *task)
> +{
> +	struct task_struct *c;
> +
> +	read_lock(&tasklist_lock);
> +	list_for_each_entry(c, &task->children, sibling)
> +		seq_printf(m, " %d", pid_nr_ns(task_pid(c), ns));
> +	read_unlock(&tasklist_lock);
> +	seq_putc(m, '\n');
> +
> +	return 0;
> +}

That's a potentially very long hold time for tasklist_lock, and
userspace can invoke this at a high frequency.  Not good.

I think this can all be done under rcu_read_lock() with
list_for_each_entry_rcu().

