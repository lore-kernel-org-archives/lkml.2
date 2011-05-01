Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1EAXNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 19:13:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47444 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1EAXNE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 19:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AQmzdLk8QM3WgCltEzLs4QkYW1KFAqbWNfSy84juxVC1ulaUnrfRLvG1JUtTqDW3KO
         Cl1SXGqUK1BydAfkV9QWbkedWXruMvz34mzao2962YemxmwDuac0IGauRIl6g0C5cGkz
         PbiTv4wx+f95hkNjf9T0KdcQ1Ejjqs3JAWUP8=
MIME-Version: 1.0
In-Reply-To: <m1r58i2g02.fsf@fess.ebiederm.org>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
 <m1zkn68mpk.fsf@fess.ebiederm.org> <BANLkTi=NcpPQUGkR=pbOMPfMkyL7LiBeoA@mail.gmail.com>
 <m1r58i2g02.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 2 May 2011 01:12:41 +0200
Message-ID: <BANLkTinTMckhNYx1OiyH_YR+hr31naPQHw@mail.gmail.com>
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
>>> Since we are touching most if not all of the sysctl registrations this
>>> would also be a good time to pass a path string instead of the weird
>>> ctl_path data structure.  We needed ctl_path when we had both binary
>>> and proc paths to worry about but we no longer have that concern.
>>
>>
>> I still find good use for it in the next patches (some optimisations).
>> Getting rid of it makes some things more difficult:
>> - I wouldn't like to parse strings into path components at registeration
>
> I don't expect '/' being more difficult to deal with than an array.  In
> general I expect a single string to be more space efficient and easier
> for human comprehension.


We also use the string from ctl_path as a name for the sysctl
directory. We would need to either:
* strdup part of the string for each directory, remember to kfree
* replace '/' with '\0' in the given string (meaning it can't be put
in a read-only zone)

Also I make use of the ctl_path to add some optimisations that deal
with the case when there are very many known-to-be-uniquely-named
sub-directories like for /proc/sys/net/ipv4/conf/DEVICE. IXIACOM which
sponsored this work has usecases where they need to create 10^3..10^5
virtual network devices and these optimisations really add up for that
many interfaces.

For details about the optimisation see patches:
 61/69 http://thread.gmane.org/gmane.linux.kernel/1133667/focus=1133694 and
 62/69 http://thread.gmane.org/gmane.linux.kernel/1133667/focus=1133711


I will make another function that would take a string, parse it up,
create a ctl_path array and register it, but I'd really like to keep
ctl_path both in the implementation and as a means to register a
table.

>> - users of the register_sysctl_paths would need to create strings with
>> dynamic components (for example "net/conf/%s/" - where %s is a
>> netdevice-name or "kernel/sched_domain/%s/%s" with cpu-name and
>> domain-name).
>
> This is a good point.
>
> In the normal proc implementation this is solved by being able to
> pass the equivalent of a ctl_table_header into the registration
> function, which allows the use of relative paths in the registration
> function.
>
> In the examples you have given relative paths should also work for
> sysctl.


Hmm, I don't think we're on the same channel here. I don't understand
what you're trying to say
- normal proc implementation?
- the equivalent of a ctl_table_header?
- relative paths?

I was saying that if we are to *replace* the ctl_path based mechanism
with a string denoting the path, then some other registrants will need
to allocate memory for those strings because the paths they register
are computed at runtime. Then I gave two distinct examples where this
is done. In both of those cases, ctl_path saves us from allocating a
string before allocation, only to chop it then back to pieces in the
__register function.



-- 
 .
..: Lucian
