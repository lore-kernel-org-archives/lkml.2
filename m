Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab2JSNDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:03:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44445 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2JSNDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:03:39 -0400
Message-ID: <50814FA1.2050202@redhat.com>
Date: Fri, 19 Oct 2012 15:03:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Andrew Morton <akpm@linux-foundation.org>, mtk.manpages@gmail.com,
        "Paton J. Lewis" <palewis@adobe.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jason Baron <jbaron@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>, libc-alpha@sourceware.org,
        Linux API <linux-api@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
References: <1345756535-8372-1-git-send-email-palewis@adobe.com> <CAKgNAkg0R2LwfpF8beCkawTfPu7oj_DDaDxf2VJ+xB6UTgRSaw@mail.gmail.com> <20121017163004.fb9de1b3.akpm@linux-foundation.org> <508044D7.7070005@mit.edu>
In-Reply-To: <508044D7.7070005@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/10/2012 20:05, Andy Lutomirski ha scritto:
> 
> Unless something is rather buggy in kernel land (and I don't think it
> is), once EPOLL_CTL_DEL has returned, no call to epoll_wait that starts
> *after* EPOLL_CTL_DEL finishes will return that object.  This suggests
> an RCU-like approach: once EPOLL_CTL_DEL has returned and every thread
> has returned from an epoll_wait call that started after the
> EPOLL_CTL_DEL returns, then the data structure can be safely freed.
> 
> In pseudocode:
> 
> delete(fd, pdata) {
>   pdata->dead = true;
>   EPOLL_CTL_DEL(fd);
>   rcu_call(delete pdata);
> }
> 
> wait() {
>   epoll_wait;
>   for each event pdata {
>     if (pdata->gone) continue;
>     process the event;
>   }
> 
>   rcu_this_is_a_grace_period();
> }
> 
> Of course, these are not normal grace periods and would need to be
> tracked separately.  (The optimal data structure to do this without
> killing scalability is not obvious.  urcu presumably implements such a
> thing.)
> 
> Am I right?

Equip each thread with a) an id or something else that lets each thread
refer to "the next" thread; b) a lists of "items waiting to be deleted".
 Then the deleting thread adds the item being deleted to the first
thread's list.  Before executing epoll_wait, thread K empties its list
and passes the buck, appending the old contents of its list to that of
thread K+1.  This is an O(1) operation no matter how many items are
being deleted; only Thread N, being the last thread, actually has to go
through the list and delete the items.

The lists need to be protected by a mutex, but contention should really
be rare since there are just two writers.  Note that each thread only
needs to hold one mutex at a time, and the deletion loop does not need
to happen with the mutex held at all, so there's no worries of
"cascading" waits on the mutexes.

Compared to http://thread.gmane.org/gmane.linux.kernel/1311457, you get
rid of the per-item mutex and the operations that have to be done with
the (now per-thread) mutex held remain pretty trivial.

Paolo
