Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1HOTNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 15:13:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1HOTNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 15:13:11 -0400
Date: Mon, 15 Aug 2011 21:09:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Paul Menage <menage@google.com>, Ben Blum <bblum@andrew.cmu.edu>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible race between cgroup_attach_proc and de_thread, and
	questionable code in de_thread.
Message-ID: <20110815190935.GA17589@redhat.com>
References: <20110727171101.5e32d8eb@notabene.brown> <20110814174000.GA2381@redhat.com> <20110815101144.39812e9f@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815101144.39812e9f@notabene.brown>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, NeilBrown wrote:
>
> de_thread can change the group_leader of a thread_group, and release_task can
> remove a non-leader while leaving the rest of the thread_group intact.  So
> any while_each_thread() loop needs some extra care to ensure that it doesn't
> loop infinitely, because the "head" that it is looking for might not be there
> any more.
> Maybe there are other rules that ensure this can never happen, but they sure
> aren't obvious to me (i.e. if you know them - please tell ;-)

No, I don't know ;)

And note also that if g != leader, then while_each_thread(g, t) can hang
simply because g exits. I am still trying to invent something simple to
fix while_each_thread-under-rcu.

This looks possible, but I am starting to think that, say, zap_threads()
needs locking anyway. With any fix I can imagine, it can miss a thread
we should care about.

Oleg.

