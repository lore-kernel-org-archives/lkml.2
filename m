Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab0HWBgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:36:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44874
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589Ab0HWBgH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:36:07 -0400
Date: Sun, 22 Aug 2010 18:36:24 -0700 (PDT)
Message-Id: <20100822.183624.28802617.davem@davemloft.net>
To: xiaosuo@gmail.com
Cc: arnd@arndb.de, eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: define __packed for the userspace code
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTiktOcAvAxcXUxh+4jKh0nBmYCf0OVG0wqRNMb9T@mail.gmail.com>
References: <AANLkTin1BOgHBc4sTwFAmQhKFNvZ+90herc4Dsh9P8y2@mail.gmail.com>
	<201008221507.42023.arnd@arndb.de>
	<AANLkTiktOcAvAxcXUxh+4jKh0nBmYCf0OVG0wqRNMb9T@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changli Gao <xiaosuo@gmail.com>
Date: Sun, 22 Aug 2010 21:47:06 +0800

> On Sun, Aug 22, 2010 at 9:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Sunday 22 August 2010 13:23:42 Changli Gao wrote:
>>> On Sun, Aug 22, 2010 at 7:12 PM, Changli Gao <xiaosuo@gmail.com> wrote:
>>> > This commit
>>> >
>>> >  commit bc10502dba37d3b210efd9f3867212298f13b78e
>>> >  Author: Eric Dumazet <eric.dumazet@gmail.com>
>>> >  Date:   Thu Jun 3 03:21:52 2010 -0700
>>> >
>>> >    net: use __packed annotation
>>> >
>>> > makes use of __packed in the userspace code. So we'd better define __packed
>>> > for the userspace code too.
>>> >
>>>
>>> Oh, sorry. This patch can't work as include/linux/compiler.h isn't
>>> exported to the userspace. But where should we define __packed for the
>>> userspace code? include/linux/types.h?
>>
>> I would try to avoid making those structures packed to start with.
>> From what I can see, they structures annotated in the above commit
>> mostly don't even require explicit packing because they are already
>> packed. Not marking them packed makes the code portable to non-gcc
>> compilers.
>>
> 
> Maybe __packed is used somewhere to hint that some members of a
> structure maybe unaligned.

I don't think this it the reason it was being used here.

Any, for one thing, we definitely cannot remove the existing packed
markers or else we will break every single userland tool out there
using these socket address structures.

Even the first two members (sa_family_t and unsigned int) will be
positioned differently if we remove the marker.

I suspect the packed attribute is there to make sure the pppo* socket
address structures fit within the generic socket address object size.
(see struct __kernel_sockaddr_storage and struct sockaddr).

As to the problem at-hand, I think we need to use __attribute__((packed))
here.  And that's what I'll commit into net-2.6 and net-next-2.6
