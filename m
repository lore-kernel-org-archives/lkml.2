Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab0KMGZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 01:25:26 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38982 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab0KMGZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 01:25:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=C2qzvWdx/vRfJGgpVVUiYzdzN0g/58iQP+Bjin+cmy5x+I1qrMkZx+sKeVHI7EBLxr
         aUdNbpp8uFzBWlYKSukSCzeGvh1qYrYzQQFj26jFUKp7U/anko+rSSr4b7ZV0x1OMxrN
         4HsyVY+Pzv/gDCi2GqoouXQ9UMFPvWa8ixdUk=
Date: Sat, 13 Nov 2010 14:28:24 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Cypher Wu <cypher.w@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: Kernel rwlock design, Multicore and IGMP
Message-ID: <20101113062824.GC3837@hack>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com> <1289489007.17691.1310.camel@edumazet-laptop> <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com> <20101112071323.GB5660@cr0.nay.redhat.com> <1289546874.17691.1774.camel@edumazet-laptop> <20101112081945.GA5949@cr0.nay.redhat.com> <AANLkTik-KDvc2fgH91vBHGT6vqxbZrv=9DoQknujPWy2@mail.gmail.com> <20101112091818.GB5949@cr0.nay.redhat.com> <20101112130017.GA9752@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101112130017.GA9752@zhy>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 09:00:17PM +0800, Yong Zhang wrote:
>On Fri, Nov 12, 2010 at 05:18:18PM +0800, Américo Wang wrote:
>> On Fri, Nov 12, 2010 at 05:09:45PM +0800, Yong Zhang wrote:
>> >On Fri, Nov 12, 2010 at 4:19 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> >> On Fri, Nov 12, 2010 at 08:27:54AM +0100, Eric Dumazet wrote:
>> >>>Le vendredi 12 novembre 2010 à 15:13 +0800, Américo Wang a écrit :
>> >>>> On Fri, Nov 12, 2010 at 11:32:59AM +0800, Cypher Wu wrote:
>> >>>> >On Thu, Nov 11, 2010 at 11:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> >>>> >> Le jeudi 11 novembre 2010 à 21:49 +0800, Cypher Wu a écrit :
>> >>>> >>
>> >>>> >> Hi
>> >>>> >>
>> >>>> >> CC netdev, since you ask questions about network stuff _and_ rwlock
>> >>>> >>
>> >>>> >>
>> >>>> >>> I'm using TILEPro and its rwlock in kernel is a liitle different than
>> >>>> >>> other platforms. It have a priority for write lock that when tried it
>> >>>> >>> will block the following read lock even if read lock is hold by
>> >>>> >>> others. Its code can be read in Linux Kernel 2.6.36 in
>> >>>> >>> arch/tile/lib/spinlock_32.c.
>> >>>> >>
>> >>>> >> This seems a bug to me.
>> >>>> >>
>> >>>> >> read_lock() can be nested. We used such a schem in the past in iptables
>> >>>> >> (it can re-enter itself),
>> >>>> >> and we used instead a spinlock(), but with many discussions with lkml
>> >>>> >> and Linus himself if I remember well.
>> >>>> >>
>> >>>> >It seems not a problem that read_lock() can be nested or not since
>> >>>> >rwlock doesn't have 'owner', it's just that should we give
>> >>>> >write_lock() a priority than read_lock() since if there have a lot
>> >>>> >read_lock()s then they'll starve write_lock().
>> >>>> >We should work out a well defined behavior so all the
>> >>>> >platform-dependent raw_rwlock has to design under that principle.
>> >>>>
>> >>>
>> >>>AFAIK, Lockdep allows read_lock() to be nested.
>> >>>
>> >>>> It is a known weakness of rwlock, it is designed like that. :)
>> >>>>
>> >>>
>> >>>Agreed.
>> >>>
>> >>
>> >> Just for record, both Tile and X86 implement rwlock with a write-bias,
>> >> this somewhat reduces the write-starvation problem.
>> >
>> >Are you sure(on x86)?
>> >
>> >It seems that we never realize writer-bias rwlock.
>> >
>> 
>> Try
>> 
>> % grep RW_LOCK_BIAS -nr arch/x86
>> 
>> *And* read the code to see how it works. :)
>
>If read_lock()/write_lock() fails, the subtracted value(1 for
>read_lock() and RW_LOCK_BIAS for write_lock()) is added back.
>So reader and writer will contend on the same lock fairly.
>
>And RW_LOCK_BIAS based rwlock is a variant of sighed-test
>rwlock, so it works in the same way to highest-bit-set mode
>rwlock.
>
>Seem you're cheated by it's name(RW_LOCK_BIAS). :)

Ah, no, I made a mistake that I thought the initial value
of rwlock is something like 0, but clearly it is RW_LOCK_BIAS.
Yeah, then there is certainly no bias to writers, and x86
must be using almost the same algorithm with Tile.

-- 
Live like a child, think like the god.
 
