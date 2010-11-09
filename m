Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab0KITE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:04:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab0KITE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:04:26 -0500
Date: Tue, 9 Nov 2010 19:57:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && event->owner
Message-ID: <20101109185748.GA12138@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108145754.GB3434@redhat.com> <20101108201108.GA6777@nowhere> <20101109155714.GA1903@redhat.com> <1289321804.2191.57.camel@laptop> <20101109165805.GA6971@redhat.com> <1289322469.2191.59.camel@laptop> <20101109174219.GA8279@redhat.com> <1289325703.2191.60.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289325703.2191.60.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Peter Zijlstra wrote:
>
> I think you're right, how about something like this?

I need to read it with a fresh head ;)

At first glance,

> @@ -2254,6 +2249,12 @@ static int perf_release(struct inode *in
>
>  	file->private_data = NULL;
>
> +	if (event->owner) {
> +		mutex_lock(&event->owner->perf_event_mutex);
> +		list_del_init(&event->owner_entry);
> +		mutex_unlock(&event->owner->perf_event_mutex);
> +	}

Agreed, it is better to do this in perf_release().

But, this can use the already freed task_struct, event->owner.

Either sys_perf_open() should do get_task_struct() like we currently
do, or perf_event_exit_task() should clear event->owner and then
perf_release() should do something like

	rcu_read_lock();
	owner = event->owner;
	if (owner)
		get_task_struct(owner);
	rcu_read_unlock();

	if (owner) {
		mutex_lock(&event->owner->perf_event_mutex);
		list_del_init(&event->owner_entry);
		mutex_unlock(&event->owner->perf_event_mutex);
		put_task_struct(owner);
	}

Probably this can be simplified...

Oleg.

