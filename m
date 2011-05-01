Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926Ab1EAQVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:21:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50120 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab1EAQVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Qx3L3uPFiLu81n0yVk6eNvcGjWieUuxx3tGYDW33BAsunL47DmWLSn3k4qWQ0RRJF3
         Wfk9g2wtINpCjgK2BOoMAFlVdGCDsMaSbYIvK4NXJwK1xszGRyXrAuncn16IxyWMMMrT
         A0bL1dyXG7KwMbqDu7i/o46dO0+yS+m0pcVYw=
MIME-Version: 1.0
In-Reply-To: <m1zkn68mpk.fsf@fess.ebiederm.org>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com> <m1zkn68mpk.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Sun, 1 May 2011 18:20:47 +0200
Message-ID: <BANLkTi=NcpPQUGkR=pbOMPfMkyL7LiBeoA@mail.gmail.com>
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

On Sun, May 1, 2011 at 5:28 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> The first patches remove the .child field of ctl_table. This is a
>> requirement for the new algorithm. These patches are scattered all
>> over the tree :(
>
> Only registering sysctl leaves seems very reasonable, the code has
> been slowly moving in that direction for quite a while.
>
> We need to make it a firm rule that directories are created before
> they are used. (aka normal filesystem semantics) before we churn
> through and change everything.


I don't understand what you want to say.

Patch 60 makes sure that if a directory is not found a
ctl_table_header will be created for it. That directory can be freed
by anyone else when the reference count becomes 0.
E.g. register /newdir/file1, register /newdir/file2, unregister
/newdir/file1, unregister /newdir/file1
- 1st registration created 'newdir' and takes a reference to it.
- 2nd regisitration incs the reference count.
- 1st unregister decs the reference count.
- 2nd unregister decs the reference count which becomes 0 and frees 'newdir'.

I may have misunderstood your comment.


> This also addresses a question you asked in patch 60.
>
>> This can be fixed in two ways:
>>
>> - A) by making sure to never register a netns specific directory and
>>   after that register that directory as a common one. From what I can
>>   tell there isn't such a problem in the kernel at the moment, but I
>>   did not study the source in detail.
>
> Currently it is a requirement that if you are going to have a netns
> component and a non nents component the non-netns directory must
> be created first.  However that requirement is not currently enforced.
>
> It is a bit too easy to get that wrong.  So we need enforcement of that
> rule and enforcement of duplicate checks.  The sysctl_check code should
> become mandatory at this point, or at least the duplicate checks.


I'll post a modified check enforcing this.


> Since we are touching most if not all of the sysctl registrations this
> would also be a good time to pass a path string instead of the weird
> ctl_path data structure.  We needed ctl_path when we had both binary
> and proc paths to worry about but we no longer have that concern.


I still find good use for it in the next patches (some optimisations).
Getting rid of it makes some things more difficult:
- I wouldn't like to parse strings into path components at registeration
- users of the register_sysctl_paths would need to create strings with
dynamic components (for example "net/conf/%s/" - where %s is a
netdevice-name or "kernel/sched_domain/%s/%s" with cpu-name and
domain-name).


> We may also want to add a special sysctl directory creation and removal
> operations.

That can be done very easily now: register an empty table. But I can
add something special for directories only if needed.


>> People interested in the core sysctl changes/networking should read:
>>
>>    [PATCH 60/69] sysctl: faster tree-based sysctl implementation
>>
>> which introduces the new algorithm (commit message and comments have
>> more details), and the next few patches which add some further (simple
>> and effective) optimisations for networking (and not only).
>
> Patch 60 does too many things all in one patch.  It would be very good
> if it could be split up some more, so it could be more easily verified.


Ok. I'll see what I can do.


-- 
 .
..: Lucian
