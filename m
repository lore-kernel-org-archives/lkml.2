Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1EBDGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 23:06:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58973 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab1EBDGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 23:06:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/69] faster tree-based sysctl implementation
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
	<m1zkn68mpk.fsf@fess.ebiederm.org>
	<BANLkTi=NcpPQUGkR=pbOMPfMkyL7LiBeoA@mail.gmail.com>
	<m1r58i2g02.fsf@fess.ebiederm.org>
	<BANLkTinTMckhNYx1OiyH_YR+hr31naPQHw@mail.gmail.com>
Date: Sun, 01 May 2011 20:06:27 -0700
In-Reply-To: <BANLkTinTMckhNYx1OiyH_YR+hr31naPQHw@mail.gmail.com> (Lucian
	Adrian Grijincu's message of "Mon, 2 May 2011 01:12:41 +0200")
Message-ID: <m1aaf5yf64.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18IBatH+E4360gXm27o2Zo9kNv8lP7pJ6c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> On Mon, May 2, 2011 at 12:49 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>>> Since we are touching most if not all of the sysctl registrations this
>>>> would also be a good time to pass a path string instead of the weird
>>>> ctl_path data structure.  We needed ctl_path when we had both binary
>>>> and proc paths to worry about but we no longer have that concern.
>>>
>>>
>>> I still find good use for it in the next patches (some optimisations).
>>> Getting rid of it makes some things more difficult:
>>> - I wouldn't like to parse strings into path components at registeration
>>
>> I don't expect '/' being more difficult to deal with than an array.  In
>> general I expect a single string to be more space efficient and easier
>> for human comprehension.
>
>
> We also use the string from ctl_path as a name for the sysctl
> directory. We would need to either:
> * strdup part of the string for each directory, remember to kfree
> * replace '/' with '\0' in the given string (meaning it can't be put
> in a read-only zone)

If we are only registering leaves, we can just deal with the tail of the
path and point just past the final /. There should be no need to
duplicate anything.

> Also I make use of the ctl_path to add some optimisations that deal
> with the case when there are very many known-to-be-uniquely-named
> sub-directories like for /proc/sys/net/ipv4/conf/DEVICE. IXIACOM which
> sponsored this work has usecases where they need to create 10^3..10^5
> virtual network devices and these optimisations really add up for that
> many interfaces.

I am convinced the places where we have network devices in the path are
indeed the pain points for scaling.

My gut feel is that we should use a balanced binary tree instead of a
doubly linked list for the directories.  The space cost of a tree
is just an extra color member instead of two pointers.

For 100000 entries your target of a binary tree should only be 17
entries tall.  Maybe twice that for if the tree is an rbtree.  17 or
even 33 should be a small enough value log(N) to keep the cost from
being painful.  And using a binary tree means fewer special cases
overall.


A binary tree is faster than your special case for lookup.  Which means
it solves the case of actually using the sysctl entries as well as the
case for creating them.

Furthermore to we also need to change sysfs because it also has
directories that will contain all 100000 of the network devices,
and I don't expect simply skipping the duplicate check is going to
fly in sysfs.

We could do something besides a data structure without a logN
insert/remove/lookup cost complexity.  But I think we need numbers
to show that won't scale.  So far all we have are numbers that show
a linked list doesn't scale.

> For details about the optimisation see patches:
>  61/69 http://thread.gmane.org/gmane.linux.kernel/1133667/focus=1133694 and
>  62/69 http://thread.gmane.org/gmane.linux.kernel/1133667/focus=1133711
>
>
> I will make another function that would take a string, parse it up,
> create a ctl_path array and register it, but I'd really like to keep
> ctl_path both in the implementation and as a means to register a
> table.

Using a string path certainly isn't critical at this point.  But so
far I don't see practical down sides.

>>> - users of the register_sysctl_paths would need to create strings with
>>> dynamic components (for example "net/conf/%s/" - where %s is a
>>> netdevice-name or "kernel/sched_domain/%s/%s" with cpu-name and
>>> domain-name).
>>
>> This is a good point.
>>
>> In the normal proc implementation this is solved by being able to
>> pass the equivalent of a ctl_table_header into the registration
>> function, which allows the use of relative paths in the registration
>> function.
>>
>> In the examples you have given relative paths should also work for
>> sysctl.
>
>
> Hmm, I don't think we're on the same channel here. I don't understand
> what you're trying to say
> - normal proc implementation?
> - the equivalent of a ctl_table_header?
> - relative paths?

I was looking at effectively other virtual filesystems that have
had similar problems and talking about other solutions used.

In particular I was referring to create_proc_entry.  It takes
a path and an optional parent directory.

> I was saying that if we are to *replace* the ctl_path based mechanism
> with a string denoting the path, then some other registrants will need
> to allocate memory for those strings because the paths they register
> are computed at runtime. Then I gave two distinct examples where this
> is done. In both of those cases, ctl_path saves us from allocating a
> string before allocation, only to chop it then back to pieces in the
> __register function.

And I was saying if that string was treated as a relative path.  We
could have:

struct ctl_table_header *register_sysctl_path(struct ctl_table_header *parent,
						const char *path,
						struct ctl_table *table);

The optional parent parameter would save us from the pain of having to
even place the sysctl entry in a ctl_path.  __register_sysctl_paths
already has a very similar interface.

Eric


