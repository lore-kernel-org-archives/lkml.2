Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab0KMXJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 18:09:27 -0500
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:49174
	"EHLO qmta06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368Ab0KMXJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 18:09:26 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Nov 2010 18:09:26 EST
Message-ID: <4CDF1945.8090101@tilera.com>
Date: Sat, 13 Nov 2010 18:03:33 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
Newsgroups: linux-kernel
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Cypher Wu <cypher.w@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: Kernel rwlock design, Multicore and IGMP
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com> <1289489007.17691.1310.camel@edumazet-laptop> <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com> <ZXmP8hjgLHA.4648@exchange1.tad.internal.tilera.com>
In-Reply-To: <ZXmP8hjgLHA.4648@exchange1.tad.internal.tilera.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 2:13 AM, Américo Wang wrote:
> On Fri, Nov 12, 2010 at 11:32:59AM +0800, Cypher Wu wrote:
>> On Thu, Nov 11, 2010 at 11:23 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> Le jeudi 11 novembre 2010 à 21:49 +0800, Cypher Wu a écrit :
>>>> I'm using TILEPro and its rwlock in kernel is a liitle different than
>>>> other platforms. It have a priority for write lock that when tried it
>>>> will block the following read lock even if read lock is hold by
>>>> others. Its code can be read in Linux Kernel 2.6.36 in
>>>> arch/tile/lib/spinlock_32.c.
>>>
>>> This seems a bug to me.
>>> [...]
>>>
>> It seems not a problem that read_lock() can be nested or not since
>> rwlock doesn't have 'owner', it's just that should we give
>> write_lock() a priority than read_lock() since if there have a lot
>> read_lock()s then they'll starve write_lock().
>> We should work out a well defined behavior so all the
>> platform-dependent raw_rwlock has to design under that principle.
> 
> It is a known weakness of rwlock, it is designed like that. :)

Exactly.  The tile rwlock correctly allows recursively reacquiring the read
lock.  But it does give priority to writers, for the (unfortunately
incorrect) reasons Cypher Wu outlined above, e.g.:

- Core A takes a read lock
- Core B tries for a write lock and blocks new read locks
- Core A tries for a (recursive) read lock and blocks

Core A and B are now deadlocked.

The solution is actually to simplify the tile rwlock implementation so that
both readers and writers contend fairly for the lock.

I'll post a patch in the next day or two for tile.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
