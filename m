Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0C3S51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:57:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0C3S5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:57:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ublpUn/na/ghdxrRl7d7qacn50MxzsakFpxZ5rAcQP7ZjZlxOWow+J+6aZgQD4ghb
	Wpd6EaZpEmw7kmOdLeXwg==
MIME-Version: 1.0
In-Reply-To: <20100329230530.GS2569@linux.vnet.ibm.com>
References: <20100329211525.GA17703@linux.vnet.ibm.com>
	 <6599ad831003291543r71300bcfv2957004bf2e927bb@mail.gmail.com>
	 <20100329230530.GS2569@linux.vnet.ibm.com>
Date: Tue, 30 Mar 2010 11:57:14 -0700
Message-ID: <6599ad831003301157p155ca446lce8d6a0e7a70c10e@mail.gmail.com>
Subject: Re: [PATCH tip/core/urgent] rcu: protect fork-time cgroup access
From: Paul Menage <menage@google.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, abogani@texware.it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 4:05 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> So I have to ask...  What happens if the underlying cgroup is removed
> between the time sched_fork() calls set_task_cpu() and the time that
> copy_process() puts the new task on the tasklist?  Or is the initial
> cgroup guaranteed to be immortal?
>

As long as your code is running after cgroup_fork() - which
sched_fork() is - then it should be OK. cgroup_fork() takes a
reference count on the parent's cgroups set, which implicitly keeps
all of those cgroups alive until the task either exits or is moved.
But it can't be moved until it's visible on the task list.

Possibly dup_task_struct should do tsk->cgroups = NULL so that
(currently) unsafe references to the un-refcounted tsk->cgroups before
cgroup_fork() get caught.

Paul
