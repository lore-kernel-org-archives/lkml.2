Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab1ETPzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:55:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:18972 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933861Ab1ETPzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:55:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,243,1304319600"; 
   d="scan'208";a="4589634"
Message-ID: <4DD68EDF.4030301@linux.intel.com>
Date: Fri, 20 May 2011 08:55:11 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
References: <201105191526.31904.toralf.foerster@gmx.de>	<201105192218.18261.toralf.foerster@gmx.de>	<20110519204342.GA10792@home.goodmis.org>	<201105200937.15322.toralf.foerster@gmx.de> <BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
In-Reply-To: <BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/20/2011 12:56 AM, richard -rw- weinberger wrote:
> 2011/5/20 Toralf Förster <toralf.foerster@gmx.de>:
>> ...
>> Kernel panic - not syncing: Kernel mode fault at addr 0x0, ip 0x80a9f6b
> 
> Looks like a NULL-pointer bug.
> What code is at address 80a9f6b?
> Use "objdump -d -S | less" to find it.
> Please note, kernel binary and log message have to match!
> 
>> The file /var/log/messages of the UML says :
>>
>> 2011-05-20T09:33:03.455+02:00 n22_uml kernel: ------------[ cut here ]------------
>> 2011-05-20T09:33:03.455+02:00 n22_uml kernel: WARNING: at kernel/futex.c:789 wake_futex+0x28/0x60()
> 
> Is this really 2.6.39?
> Line 789 contains no WARN*().
> http://lxr.linux.no/#linux+v2.6.39/kernel/futex.c#L789
> 

I suspect Toralf is hitting the WARN_ON in __unqueue_futex:

	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
			|| plist_node_empty(&q->list)))

Toralf, can you instrument that let us know which of conditions is
triggering the WARN_ON? Something like the following should be adequate
to get you the line number. I suspect it is plist_node_empty give the
git bisect results you reported.


diff --git a/kernel/futex.c b/kernel/futex.c
index abd5324..7f31bca 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -782,8 +782,11 @@ static void __unqueue_futex(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;

-	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
-			|| plist_node_empty(&q->list)))
+	if (WARN_ON(!q->lock_ptr))
+		return;
+	if (!spin_is_locked(q->lock_ptr))
+		return;
+	if (plist_node_empty(&q->list))
 		return;

 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);




-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
