Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1EAWtm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 18:49:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60967 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1EAWtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 18:49:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/69] faster tree-based sysctl implementation
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
	<m1zkn68mpk.fsf@fess.ebiederm.org>
	<BANLkTi=NcpPQUGkR=pbOMPfMkyL7LiBeoA@mail.gmail.com>
Date: Sun, 01 May 2011 15:49:33 -0700
In-Reply-To: <BANLkTi=NcpPQUGkR=pbOMPfMkyL7LiBeoA@mail.gmail.com> (Lucian
	Adrian Grijincu's message of "Sun, 1 May 2011 18:20:47 +0200")
Message-ID: <m1r58i2g02.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+2wpXHMbnegMm0KOHinNBzbh1zm2QTTGw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> On Sun, May 1, 2011 at 5:28 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> The first patches remove the .child field of ctl_table. This is a
>>> requirement for the new algorithm. These patches are scattered all
>>> over the tree :(
>>
>> Only registering sysctl leaves seems very reasonable, the code has
>> been slowly moving in that direction for quite a while.
>>
>> We need to make it a firm rule that directories are created before
>> they are used. (aka normal filesystem semantics) before we churn
>> through and change everything.
>
>
> I don't understand what you want to say.
>
> Patch 60 makes sure that if a directory is not found a
> ctl_table_header will be created for it. That directory can be freed
> by anyone else when the reference count becomes 0.
> E.g. register /newdir/file1, register /newdir/file2, unregister
> /newdir/file1, unregister /newdir/file1
> - 1st registration created 'newdir' and takes a reference to it.
> - 2nd regisitration incs the reference count.
> - 1st unregister decs the reference count.
> - 2nd unregister decs the reference count which becomes 0 and frees 'newdir'.
>
> I may have misunderstood your comment.

While you can make directory lifetimes work by ref counting.  Making it
work by ref counting removes a concept of ownership and makes it hard to
see when a sysctl directory should exist.

If we are reforming this we should go all of the way and make strict
lifetime rules of directories.  So that it is required to do:

register newdir
register newdir/file1
unregister newdir/file1
unregister newdir

Today there is a WARN_ON in unregister_sysctl_table enforcing the
ordering that directories must come first and be removed after
the files in those directories.  If we change the table registrations
to only include leaves (as your removal of .child patches do) I
believe that rule becomes absolute.

That WARN_ON came in with Al Viro's last major sweep through the code,
and it started moving sysctl in the direction of a normal filesystem.
For long term maintainability and comprehensibility I think moving
sysctl in the direction of a normal filesystem makes a lot of sense.

>> Since we are touching most if not all of the sysctl registrations this
>> would also be a good time to pass a path string instead of the weird
>> ctl_path data structure.  We needed ctl_path when we had both binary
>> and proc paths to worry about but we no longer have that concern.
>
>
> I still find good use for it in the next patches (some optimisations).
> Getting rid of it makes some things more difficult:
> - I wouldn't like to parse strings into path components at registeration

I don't expect '/' being more difficult to deal with than an array.  In
general I expect a single string to be more space efficient and easier
for human comprehension.

> - users of the register_sysctl_paths would need to create strings with
> dynamic components (for example "net/conf/%s/" - where %s is a
> netdevice-name or "kernel/sched_domain/%s/%s" with cpu-name and
> domain-name).

This is a good point.

In the normal proc implementation this is solved by being able to
pass the equivalent of a ctl_table_header into the registration
function, which allows the use of relative paths in the registration
function.

In the examples you have given relative paths should also work for
sysctl.

Using string paths is not a must have but in practice I think it
simplifies things quite a bit

Eric
