Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab2EOOwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:52:13 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39500 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2EOOwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:52:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120515144658.GC2461@linux.vnet.ibm.com>
References: <20120515044145.GA21910@redhat.com>
	<20120515051607.GH2412@linux.vnet.ibm.com>
	<CACLa4psGwEC96GfonAJ+-v0ocdvb_ZBxB6v=zAXbnbqFmuCNuA@mail.gmail.com>
	<20120515144658.GC2461@linux.vnet.ibm.com>
Date: Tue, 15 May 2012 10:52:07 -0400
Message-ID: <CACLa4pt=Hh1=E9Jno_BAU-6stRL=hY3wehpWycKCYYJbJzYEGw@mail.gmail.com>
Subject: Re: suspicious RCU usage in security/selinux/netnode.c
From: Eric Paris <eparis@parisplace.org>
To: paulmck@linux.vnet.ibm.com
Cc: Dave Jones <davej@redhat.com>, sds@tycho.nsa.gov,
        Linux Kernel <linux-kernel@vger.kernel.org>, paul@paul-moore.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 10:46 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, May 15, 2012 at 10:24:23AM -0400, Eric Paris wrote:
>> On Tue, May 15, 2012 at 1:16 AM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Tue, May 15, 2012 at 12:41:45AM -0400, Dave Jones wrote:
>> >> I just triggered this on Linus' current tree.
>> >
>> > This is a bare:
>> >
>> >        rcu_dereference(sel_netnode_hash[idx].list.prev)
>> >
>> > which needs to be in an RCU read-side critical section.  Alternatively,
>> > the above should instead be something like:
>> >
>> >        rcu_dereference_check(sel_netnode_hash[idx].list.prev,
>> >                              lockdep_is_held(&sel_netnode_lock));
>>
>> Right, but that 'bare' dereference comes from
>> list_for_each_entry_rcu(), [from sel_netnode_sid_slow()] which I don't
>> see how to easily annotate with the lock.  Nor do I think it's within
>> my brain power (or my willingness to maintain such in the future) to
>> want to open code that logic.
>
> You lost me on this one.  The lockdep splat called out the
> rcu_dereference() above, not a list_for_each_entry_rcu().  Besides which,
> the list_for_each_entry_rcu() does not do the checking -- at the time,
> I was not willing to explode the API that much.

Ohhhh, ok.  I assumed we needed to annotate list_for_each_entry_rcu()
under the spinlock as well as the bare dereference in the insert code.
 Ok, should be very easy to fix, although the list running code is
still going to be un-annotated in any way.  Thanks

-Eric
