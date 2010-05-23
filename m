Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab0EWXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 19:16:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47920 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab0EWXQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 19:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:mime-version
         :content-type;
        b=CYLKVhvhyoI/gE7fQTZe+490JOpbUGbNBxN6qc8EARZD8Z2iT2vHFxTSGUr6xqLReR
         l2hhbJydR4fuMPA8gnwydJ7dK6VJhNMw8tPcgIXKrt6ybHcZFrx+eKxEJCANQOjNJTN+
         5Un7EZNLfRhN5qIBoYthKnjG5Izi5o2zfOKqg=
Date: Mon, 24 May 2010 07:16:24 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Johannes Berg <johannes.berg@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Frans Pop <elendil@planet.nl>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Wireless IBSS on Linux-2.6.34 broken by commit
 3bbb9ec946428b96657126768f65487a48dd090c
Message-ID: <Pine.LNX.4.64.1005240710460.3159@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mon, May 24, 2010 at 5:25 AM, Arjan van de Ven <arjan@linux.intel.com> 
wrote:
>>> can you try, instead do the following, in the apply_slack() function:
>>>
>>> just before the return expires_limit; do
>>>
>>> if (expires_limit<  expires)
>>> # # #expires_limit = expires;
>>
>> This doesn't work.
>>
>>
>>> if that does not fix it, a second thought:
>>> add, after the first if (timer->slack<  0)
>>>
>>> if (timer->slack<  0&&  expires<  jiffies)
>>> # # # #expires_limit = expires;
>>
>> This works.
>
> hmm ok so the wireless stack sets a timer way back in the past
> ok that's technically legal.
>
> how about
>
> expires_limit = expires;
>
> if (timer->slack > -1)
>        expires_limit = expires + timer->slack;
> else if (time_after(expires, jiffies))
>        expires_limit = expires + (expires - jiffies)/256;
>
> can you test such a thing and send a patch?
> (it has my Acked-By: either way)


Arjan,

Tested and working. Here's the patch. Thanks for the fix!

Jeff



--- a/kernel/timer.c.org	2010-05-24 07:09:04.000000000 +0800
+++ a/kernel/timer.c	2010-05-24 07:05:22.000000000 +0800
@@ -750,9 +750,11 @@
  	unsigned long expires_limit, mask;
  	int bit;

-	expires_limit = expires + timer->slack;
+	expires_limit = expires;

-	if (timer->slack < 0) /* auto slack: use 0.4% */
+	if (timer->slack > -1)
+		expires_limit = expires + timer->slack;
+	else if (time_after(expires, jiffies)) /* auto slack: use 0.4% */
  		expires_limit = expires + (expires - jiffies)/256;

  	mask = expires ^ expires_limit;


