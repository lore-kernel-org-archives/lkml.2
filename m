Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0KLLGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:06:50 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37744 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab0KLLGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:06:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sHM15uuixdWoARvBnA862h8/GyuEk8HdueKSi7BDQIOEVbS5csfYoR/+K30ogyvlcZ
         04x7kAL/cG8fYTUnigrdi1L6fa3v80jX+Y87kKRmRk8fA/6jw3Ag+ZEgdUYysTOnV4LC
         5HrOo6BBNK/pmI5yXIjeJApHk6c2VDVgkl3I4=
MIME-Version: 1.0
In-Reply-To: <20101112091818.GB5949@cr0.nay.redhat.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	<1289489007.17691.1310.camel@edumazet-laptop>
	<AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	<20101112071323.GB5660@cr0.nay.redhat.com>
	<1289546874.17691.1774.camel@edumazet-laptop>
	<20101112081945.GA5949@cr0.nay.redhat.com>
	<AANLkTik-KDvc2fgH91vBHGT6vqxbZrv=9DoQknujPWy2@mail.gmail.com>
	<20101112091818.GB5949@cr0.nay.redhat.com>
Date: Fri, 12 Nov 2010 19:06:47 +0800
Message-ID: <AANLkTi=0Z1zVqCvYwKiQ8cUZoeD_rLgZ+C07GuFgA7E7@mail.gmail.com>
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Cypher Wu <cypher.w@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/12 Américo Wang <xiyou.wangcong@gmail.com>:
> On Fri, Nov 12, 2010 at 05:09:45PM +0800, Yong Zhang wrote:
>>On Fri, Nov 12, 2010 at 4:19 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>> On Fri, Nov 12, 2010 at 08:27:54AM +0100, Eric Dumazet wrote:
>>>>Le vendredi 12 novembre 2010 à 15:13 +0800, Américo Wang a écrit :
>>>>> On Fri, Nov 12, 2010 at 11:32:59AM +0800, Cypher Wu wrote:
>>>>> >On Thu, Nov 11, 2010 at 11:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>> >> Le jeudi 11 novembre 2010 à 21:49 +0800, Cypher Wu a écrit :
>>>>> >>
>>>>> >> Hi
>>>>> >>
>>>>> >> CC netdev, since you ask questions about network stuff _and_ rwlock
>>>>> >>
>>>>> >>
>>>>> >>> I'm using TILEPro and its rwlock in kernel is a liitle different than
>>>>> >>> other platforms. It have a priority for write lock that when tried it
>>>>> >>> will block the following read lock even if read lock is hold by
>>>>> >>> others. Its code can be read in Linux Kernel 2.6.36 in
>>>>> >>> arch/tile/lib/spinlock_32.c.
>>>>> >>
>>>>> >> This seems a bug to me.
>>>>> >>
>>>>> >> read_lock() can be nested. We used such a schem in the past in iptables
>>>>> >> (it can re-enter itself),
>>>>> >> and we used instead a spinlock(), but with many discussions with lkml
>>>>> >> and Linus himself if I remember well.
>>>>> >>
>>>>> >It seems not a problem that read_lock() can be nested or not since
>>>>> >rwlock doesn't have 'owner', it's just that should we give
>>>>> >write_lock() a priority than read_lock() since if there have a lot
>>>>> >read_lock()s then they'll starve write_lock().
>>>>> >We should work out a well defined behavior so all the
>>>>> >platform-dependent raw_rwlock has to design under that principle.
>>>>>
>>>>
>>>>AFAIK, Lockdep allows read_lock() to be nested.
>>>>
>>>>> It is a known weakness of rwlock, it is designed like that. :)
>>>>>
>>>>
>>>>Agreed.
>>>>
>>>
>>> Just for record, both Tile and X86 implement rwlock with a write-bias,
>>> this somewhat reduces the write-starvation problem.
>>
>>Are you sure(on x86)?
>>
>>It seems that we never realize writer-bias rwlock.
>>
>
> Try
>
> % grep RW_LOCK_BIAS -nr arch/x86
>
> *And* read the code to see how it works. :)
>
> Note, on Tile, it uses a little different algorithm.
>

It seems that rwlock on x86 and tile have different behavior, x86 use
RW_LOCK_BIAS, when read_lock() it will test if the lock is 0, and if
so then the read_lock() have to 'spinning', otherwise it dec the lock;
when write_lock() tried it first check if lock is It seems that rwlock
on x86 and tile have different behavior, x86 use RW_LOCK_BIAS and if
so, set lock to 0 and continue, otherwise it will 'spinning'.
I'm not very familiar with x86 architecture, but the code seems like
working that way.
