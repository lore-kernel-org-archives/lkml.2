Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2CHSgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:36:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50067 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab2CHSf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:35:57 -0500
MIME-Version: 1.0
In-Reply-To: <20120308174023.GA13424@redhat.com>
References: <1331045377.17099.2.camel@deneb.redhat.com>
	<1331064994-6693-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<1331064994-6693-2-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120307153849.GA18879@redhat.com>
	<CAAHN_R3JW=7VUSOEkiZMctz8zq_njAdJgngMoRF_EDZ4krVbTg@mail.gmail.com>
	<20120308174023.GA13424@redhat.com>
Date: Fri, 9 Mar 2012 00:05:56 +0530
Message-ID: <CAAHN_R190Dv1Viyjz7dkdq=Ju3zwn9cDGeFg+L++5Jmr77ZQPA@mail.gmail.com>
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

On Thu, Mar 8, 2012 at 11:10 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Not in this case. see __unhash_process(p)->list_del_rcu(p->thread_group).
>
> You missed the fact that ->thread_group differs from the "usual" rcu
> protected list. The _head_ of the list can be list_del_rcu'd. Not the
> first/last/any entry, even the head.
>
> Or IOW, we do not really have the head. Every task is the list entry,
> but it also can be be used as a head by while_each_thread().

Ahh ok, I did not notice this. That's an interesting quirk. The more I
think I understand rcu the more I realize there are gaps in my
understanding.

>> In that case too, before this
>> happens, the proc entry is removed
>
> I guess you meant proc_flush_task()... Not sure I really understand,
> it can't "remove" the opened entry. This is just optimization which
> tries to shrink the cache.

Yes, and I was obviously wrong, now that I read the whole thing again,
including the unmounting of the namespace. I misread the unmounting of
proc as being an unmount of the thread/thread group namespace (the nr
== 1 check).

> Yes, yes, yes, but this "next element" can exit too before you take
> rcu_read_lock, and in this case the deleted entry won't be updated.
> That is the problem.

I will post the entire, consolidated patch once again next week with
changes for this as well as some other things (*not* marking the
process stack with the TID to maintain backward compatibility and some
code cleanup). Thanks for not giving up trying to explain the same
thing over and over again ;)


-- 
Siddhesh Poyarekar
http://siddhesh.in
