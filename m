Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0EXWsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:48:41 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:55470 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab0EXWsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:48:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=k1vzZttbHeQyljm1Jhn4ErSalHAofMhfUi8RbemPU5m/KoSRg+mj4+wbU0UoTsM+gg
         9gIZVTPwAlxFiEDMcL5SWfaRscW6Jg02Ah3Jg1I71353cFOqUqlkjBbsJRl2tcapPqYV
         fHR5W+iQlnSkCxjioW2O2BDo2KZuBjA6pASMg=
Date: Tue, 25 May 2010 06:48:35 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Johannes Berg <johannes.berg@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Frans Pop <elendil@planet.nl>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Wireless IBSS on Linux-2.6.34 broken by commit
 3bbb9ec946428b96657126768f65487a48dd090c
Message-ID: <Pine.LNX.4.64.1005250637530.3140@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, May 24, 2010 at 10:57 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:>
> On Mon, 24 May 2010, Jeff Chua wrote:
>> +     if (timer->slack > -1)
>> +     else if (time_after(expires, jiffies)) /* auto slack: use 0.4% */
>>               expires_limit = expires + (expires - jiffies)/256;
>
> Please don't reload 'jiffies' twice. It's volatile, and the compiler will
> do a crap job of it.

Linus,

Sorry, didn't know what a jiffies was before, so didn't know about the 
crap it caused. Now I learned something new.

> Also, '0' is a normal number, but '-1' is a rather odd value. Please just
> test for non-negative by doing ">= 0" rather than "> -1"

Fixed.

Below is the patch to fix jiffies and checking for non-negative.


Thanks,
Jeff

--- a/kernel/timer.c.org	2010-05-25 06:05:46.000000000 +0800
+++ a/kernel/timer.c	2010-05-25 06:17:44.000000000 +0800
@@ -748,14 +748,15 @@
  unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
  {
  	unsigned long expires_limit, mask;
+	unsigned long now = jiffies;
  	int bit;

  	expires_limit = expires;

-	if (timer->slack > -1)
+	if (timer->slack >= 0)
  		expires_limit = expires + timer->slack;
-	else if (time_after(expires, jiffies)) /* auto slack: use 0.4% */
-		expires_limit = expires + (expires - jiffies)/256;
+	else if (time_after(expires, now)) /* auto slack: use 0.4% */
+		expires_limit = expires + (expires - now)/256;

  	mask = expires ^ expires_limit;
  	if (mask == 0)

