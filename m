Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030724Ab2CGWLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:11:32 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39944 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030693Ab2CGWL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:11:27 -0500
MIME-Version: 1.0
In-Reply-To: <20120307153849.GA18879@redhat.com>
References: <1331045377.17099.2.camel@deneb.redhat.com>
	<1331064994-6693-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<1331064994-6693-2-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120307153849.GA18879@redhat.com>
Date: Thu, 8 Mar 2012 03:41:26 +0530
Message-ID: <CAAHN_R3JW=7VUSOEkiZMctz8zq_njAdJgngMoRF_EDZ4krVbTg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/linux-next: Fix rcu locking in vm_is_stack
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mark Salter <msalter@redhat.com>, linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 9:08 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> rcu_read_lock() can not help without the additional checks. By the
> time you take it, task->thread_group->next can point to nowhere.

I thought I understood this the second time, but I think I haven't.

> Once again. You have the task_struct *task. It exits,
> but task->thread_group->next still points to another thread T. Now suppose
> that T exits too. But task->thread_group->next was not changed, it still
> points to T. RCU grace period passes, T is freed.

This is the point I haven't understood. From what I understand about
rcu, the rcu update will first update task->thread_group->next and
then reclaim the struct it pointed to and not the other way around. So
with:

>>               rcu_read_lock();
>> -             while_each_thread(task, t) {
>> +             t = list_first_entry_rcu(&task->thread_group,
>> +                                      struct task_struct, thread_group);

since I have the rcu_read_lock when I'm touching the rcu protected
list, if I get the old T from task->thread_group->next then I should
have a valid struct backing it too. If not, the T should have changed
_before_ the struct it points to is removed and hence should again
result in a valid reference.

I guess there is a corner case where the current task is released and
thread_group is rcu_list_del()'d. In that case too, before this
happens, the proc entry is removed and the task namespace is unmounted
from /proc. Also, the thread_group being deleted from list is merely
an update of references and we should get the next element of the list
when we get access to the lock and poke it (under an rcu_lock of
course). Is there something I am missing?

-- 
Siddhesh Poyarekar
http://siddhesh.in
