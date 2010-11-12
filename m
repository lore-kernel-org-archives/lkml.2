Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab0KLIPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:15:25 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37380 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0KLIPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:15:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=iRN9Rfnt+wJ5bhrwF0YmEs2WSjRXTCuUBcgfDGo+uLOAPT6V3WuP88ufv4d+AdPHM1
         KC1b97ATMDLkVMRhyLjrEiltLo3WpyI2Fz7XjS+EObnIdAF9l/PWI7BO2oArSzFhkupp
         ipGA+xxWM3NxJuyb6gCxqfJl1Y5uZZnj+kNSo=
Date: Fri, 12 Nov 2010 16:19:45 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Cypher Wu <cypher.w@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Kernel rwlock design, Multicore and IGMP
Message-ID: <20101112081945.GA5949@cr0.nay.redhat.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
 <1289489007.17691.1310.camel@edumazet-laptop>
 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
 <20101112071323.GB5660@cr0.nay.redhat.com>
 <1289546874.17691.1774.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1289546874.17691.1774.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 08:27:54AM +0100, Eric Dumazet wrote:
>Le vendredi 12 novembre 2010 à 15:13 +0800, Américo Wang a écrit :
>> On Fri, Nov 12, 2010 at 11:32:59AM +0800, Cypher Wu wrote:
>> >On Thu, Nov 11, 2010 at 11:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> >> Le jeudi 11 novembre 2010 à 21:49 +0800, Cypher Wu a écrit :
>> >>
>> >> Hi
>> >>
>> >> CC netdev, since you ask questions about network stuff _and_ rwlock
>> >>
>> >>
>> >>> I'm using TILEPro and its rwlock in kernel is a liitle different than
>> >>> other platforms. It have a priority for write lock that when tried it
>> >>> will block the following read lock even if read lock is hold by
>> >>> others. Its code can be read in Linux Kernel 2.6.36 in
>> >>> arch/tile/lib/spinlock_32.c.
>> >>
>> >> This seems a bug to me.
>> >>
>> >> read_lock() can be nested. We used such a schem in the past in iptables
>> >> (it can re-enter itself),
>> >> and we used instead a spinlock(), but with many discussions with lkml
>> >> and Linus himself if I remember well.
>> >>
>> >It seems not a problem that read_lock() can be nested or not since
>> >rwlock doesn't have 'owner', it's just that should we give
>> >write_lock() a priority than read_lock() since if there have a lot
>> >read_lock()s then they'll starve write_lock().
>> >We should work out a well defined behavior so all the
>> >platform-dependent raw_rwlock has to design under that principle.
>> 
>
>AFAIK, Lockdep allows read_lock() to be nested.
>
>> It is a known weakness of rwlock, it is designed like that. :)
>> 
>
>Agreed.
>

Just for record, both Tile and X86 implement rwlock with a write-bias,
this somewhat reduces the write-starvation problem.


>> The solution is to use RCU or seqlock, but I don't think seqlock
>> is proper for this case you described. So, try RCU lock.
>
>In the IGMP case, it should be easy for the task owning a read_lock() to
>pass a parameter to the called function saying 'I already own the
>read_lock(), dont try to re-acquire it'
>
>A RCU conversion is far more complex.
>

Yup.
