Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1EAXem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 19:34:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57898 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1EAXek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 19:34:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Jq2IGBCr7XM5/rSIOwDC4fTvsXljQ9+ZrFhtePj/ZZpi5enSxgcvXc6svXANuUOZi7
         S2ZvhPdnVQFUCHjhM02wTub0yVza/USSDk0mnT6OWBz0T/O7KnaRCYzsPfVu1vOGc9dC
         NrRIJcQ5vv2mfsxFxfmwPRmhw4rvSkVrI/+Jw=
MIME-Version: 1.0
In-Reply-To: <m1r58i2g02.fsf@fess.ebiederm.org>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
 <m1zkn68mpk.fsf@fess.ebiederm.org> <BANLkTi=NcpPQUGkR=pbOMPfMkyL7LiBeoA@mail.gmail.com>
 <m1r58i2g02.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 2 May 2011 01:34:19 +0200
Message-ID: <BANLkTi=JzmOm+Sm+xnY+rT-r8EwxQXO-xw@mail.gmail.com>
Subject: Re: [PATCH 00/69] faster tree-based sysctl implementation
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 12:49 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>> Patch 60 makes sure that if a directory is not found a
>> ctl_table_header will be created for it. That directory can be freed
>> by anyone else when the reference count becomes 0.
>> E.g. register /newdir/file1, register /newdir/file2, unregister
>> /newdir/file1, unregister /newdir/file1
>> - 1st registration created 'newdir' and takes a reference to it.
>> - 2nd regisitration incs the reference count.
>> - 1st unregister decs the reference count.
>> - 2nd unregister decs the reference count which becomes 0 and frees 'newdir'.
>>
>> I may have misunderstood your comment.
>
> While you can make directory lifetimes work by ref counting.  Making it
> work by ref counting removes a concept of ownership and makes it hard to
> see when a sysctl directory should exist.


I can do what you want but I see no good reason to this restriction.
Entities that register sysctls are interested in their files showing
up there.
In my previous example if two modules want to add /newdir/file1 and
/newdir/file2 they must either:
- find a third party that will register /newdir for them
- make sure they have a strict dependency relation (only registere
/newdir/file2 if the first module is loaded and it registered
/newdir/file1 or at least /newdir)

This is why we register an empty directory for "/proc/sys/dev/" (a
third party that registers the 'dev' dir and all others use it).


Again, I can do what you ask, but it either means rethinking some of
my patches, or adding the restriction on top of them.

> If we are reforming this we should go all of the way and make strict
> lifetime rules of directories.  So that it is required to do:
>
> register newdir
> register newdir/file1
> unregister newdir/file1
> unregister newdir
>
> Today there is a WARN_ON in unregister_sysctl_table enforcing the
> ordering that directories must come first and be removed after
> the files in those directories.  If we change the table registrations
> to only include leaves (as your removal of .child patches do) I
> believe that rule becomes absolute.


> That WARN_ON came in with Al Viro's last major sweep through the code,
> and it started moving sysctl in the direction of a normal filesystem.


Regarding that: I'm now trying to reproduce a NULL access in
sysctl_is_seen that I got only once. It's coupled with a
"rcu_sched_state stall detected" warning from RCU.


> For long term maintainability and comprehensibility I think moving
> sysctl in the direction of a normal filesystem makes a lot of sense.


Ok, I agree that a later redesign of sysctl would suffer if there
would be a mess regarding registration/unregistration of directories
and no ownership information/enforcement. I'll see how this can be
addressed in the next respin of this series.


-- 
 .
..: Lucian
