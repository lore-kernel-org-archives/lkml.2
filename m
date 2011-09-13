Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1IMCQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 22:16:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50338 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1IMCQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 22:16:29 -0400
Message-ID: <4E6EBDA8.2040401@vlnb.net>
Date: Mon, 12 Sep 2011 22:19:20 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110424 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Lockdep and rw_semaphores
References: <4E6C1016.8030703@vlnb.net> <20110911023840.GZ2203@ZenIV.linux.org.uk>
In-Reply-To: <20110911023840.GZ2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:+OVVq70dfUDakM86F7kRrxD1VLSsttyvGbZ3QIjtK24
 fJ4tmidhYreCjYFn9/0l9yV1zbO3zqFD5+xwYb9iersn3PgQTX
 mGKEZPrHXqEIIroujpDOCPCjevXfaDOPK1G/MpOVkbnbIHfp0T
 X+NHrR6ihXOYGVNvTXK8cE1nwDqbTODRktrgFOo11xqIE84je4
 3LcC7uVP9247lYVtdawaf9OQeKdIwfUnUkphkZFkMu3uyvdK3F
 QM9wT1aRhPLhoj5qDBJGJfjwUozaCdlOtnv/0iCIdLzvNYuyvY
 5mUUY5gBLO1myZxf9JbRbMu/TbBOP8nXJn+YiUQ/YlC1GUDXma
 6IgtmtweC6PovVheTHFI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro, on 09/10/2011 10:38 PM wrote:
> On Sat, Sep 10, 2011 at 09:34:14PM -0400, Vladislav Bolkhovitin wrote:
>> Hello,
>>
>> Looks like lockdep somehow over-restrictive for rw_semaphores in case when they
>> are taken for read (down_read()) and requires them to follow the same inner-outer
>> rules as for plain locks.
>>
>> For instance, code like:
>>
>> DECLARE_RWSEM(QQ_sem);
>> DECLARE_RWSEM(QQ1_sem);
>>
>> thread1:
>>
>>         down_read(&QQ_sem);
>>         down_read(&QQ1_sem);
> 
>> thread2:
>>
>> 	down_read(&QQ1_sem);
>> 	down_read(&QQ_sem);
> 
>> Is it by design or just something overlooked? I don't see how reverse order of
>> down_read()'s can lead to any deadlock. Or am I missing anything?
> 
> thread1: got QQ
> thread2: got QQ1
> thread3: tries to do down_write() on QQ, gets blocked
> thread4: tries to do down_write() on QQ1, gets blocked
> 
> Now we have thread1 that can't get QQ1 once the threads trying to get it
> exclusive get a shot at it.  Thread2 is blocked in the same way on QQ.
> And neither is going to release the (shared) lock they are holding, so
> thread3 and thread4 are not going to get anywhere either.
> 
> IOW, ordering *is* needed there.  Note that for the same reason trying to
> grab the same lock shared twice is a deadlock:
> 
> A: already holds X shared
> B: blocks trying to grab it exclusive
> A: tries to grab it shared again and gets stuck, since there is a pending
> down_write() and we are guaranteed that writer will get served as soon
> as all current readers are through; no new readers are allowed to starve it.

Sure, if nested write locking is involved, lockdep should loudly complain, but on
the first nested write, not read, because what's the point to complain on nested
reads? I may not have nested write locking at all (and don't have).

Plus, the deadlock scenario lockdep described for me

       CPU0                    CPU1
       ----                    ----
  lock(QQ1_sem);
                               lock(QQ_sem);
                               lock(QQ1_sem);
  lock(QQ_sem);

 *** DEADLOCK ***

is simply wrong. Such deadlock can never happen, correct?

Thanks,
Vlad
