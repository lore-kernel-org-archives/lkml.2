Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab0KLJJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:09:51 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51220 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0KLJJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:09:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L8qCmgj/MbDvK5e/WEif15iwgY+enca1bYD2wTV1+vINu9gsPhzj/1qXUqJjChNpc9
         DvxrRI/FK0kCPKovT/f8vENYdmphZY4ayZ7ZylV/ycXf7z4LKDsrJc/swr5pTENVZUxW
         CNXDd8ZMJHZEqfD7hFG0dLUqrLMxUjIY3vKOY=
MIME-Version: 1.0
In-Reply-To: <20101112081945.GA5949@cr0.nay.redhat.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	<1289489007.17691.1310.camel@edumazet-laptop>
	<AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	<20101112071323.GB5660@cr0.nay.redhat.com>
	<1289546874.17691.1774.camel@edumazet-laptop>
	<20101112081945.GA5949@cr0.nay.redhat.com>
Date: Fri, 12 Nov 2010 17:09:45 +0800
Message-ID: <AANLkTik-KDvc2fgH91vBHGT6vqxbZrv=9DoQknujPWy2@mail.gmail.com>
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Yong Zhang <yong.zhang0@gmail.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Cypher Wu <cypher.w@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 4:19 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, Nov 12, 2010 at 08:27:54AM +0100, Eric Dumazet wrote:
>>Le vendredi 12 novembre 2010 à 15:13 +0800, Américo Wang a écrit :
>>> On Fri, Nov 12, 2010 at 11:32:59AM +0800, Cypher Wu wrote:
>>> >On Thu, Nov 11, 2010 at 11:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> >> Le jeudi 11 novembre 2010 à 21:49 +0800, Cypher Wu a écrit :
>>> >>
>>> >> Hi
>>> >>
>>> >> CC netdev, since you ask questions about network stuff _and_ rwlock
>>> >>
>>> >>
>>> >>> I'm using TILEPro and its rwlock in kernel is a liitle different than
>>> >>> other platforms. It have a priority for write lock that when tried it
>>> >>> will block the following read lock even if read lock is hold by
>>> >>> others. Its code can be read in Linux Kernel 2.6.36 in
>>> >>> arch/tile/lib/spinlock_32.c.
>>> >>
>>> >> This seems a bug to me.
>>> >>
>>> >> read_lock() can be nested. We used such a schem in the past in iptables
>>> >> (it can re-enter itself),
>>> >> and we used instead a spinlock(), but with many discussions with lkml
>>> >> and Linus himself if I remember well.
>>> >>
>>> >It seems not a problem that read_lock() can be nested or not since
>>> >rwlock doesn't have 'owner', it's just that should we give
>>> >write_lock() a priority than read_lock() since if there have a lot
>>> >read_lock()s then they'll starve write_lock().
>>> >We should work out a well defined behavior so all the
>>> >platform-dependent raw_rwlock has to design under that principle.
>>>
>>
>>AFAIK, Lockdep allows read_lock() to be nested.
>>
>>> It is a known weakness of rwlock, it is designed like that. :)
>>>
>>
>>Agreed.
>>
>
> Just for record, both Tile and X86 implement rwlock with a write-bias,
> this somewhat reduces the write-starvation problem.

Are you sure(on x86)?

It seems that we never realize writer-bias rwlock.

Thanks,
Yong
>
>
>>> The solution is to use RCU or seqlock, but I don't think seqlock
>>> is proper for this case you described. So, try RCU lock.
>>
>>In the IGMP case, it should be easy for the task owning a read_lock() to
>>pass a parameter to the called function saying 'I already own the
>>read_lock(), dont try to re-acquire it'
>>
>>A RCU conversion is far more complex.
>>
>
> Yup.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
