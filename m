Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab1IOCNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 22:13:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab1IOCNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 22:13:01 -0400
Message-ID: <4E715FE1.5030503@vlnb.net>
Date: Wed, 14 Sep 2011 22:16:01 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110424 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Lockdep and rw_semaphores
References: <4E6C1016.8030703@vlnb.net> <20110911023840.GZ2203@ZenIV.linux.org.uk> <4E6EBDA8.2040401@vlnb.net> <20110913051714.GC2203@ZenIV.linux.org.uk> <4E70098D.2050504@vlnb.net> <20110914044013.GD2203@ZenIV.linux.org.uk>
In-Reply-To: <20110914044013.GD2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:CBHLwsMTHCUnmtK31x1QcTt+wcu/4mMky95xQMZGjiy
 HJwUxpH+EuPjPr3zPpJC/Z5SPCnQaWS6BcBuJJt4N0PhngR+T/
 KXjIzlduECAewSn8U+CECmE9SRruug2+5ZSnU1hEf3dCRxaWUD
 vAgxm0Ct7Nm8nBxDwxJYB5Iq0ueCVv6pCNvx6FssMlz3oM+e/j
 a3T9u5WBC+uMAdSNeAiF94x108vBVZFhMuSAXHjtsC4dqHz1s7
 LUFfsO0efQds630Hb/eVLviwnnf4aMrrEusyETp/2lH+l8P9aA
 G9zwJGBC4DnEQMhBiY9lm2yEsMyfN9+6VtEeW/1Sw8TAWNYHdH
 ezy5byQX/gMT6Tt8Av7o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro, on 09/14/2011 12:40 AM wrote:
> On Tue, Sep 13, 2011 at 09:55:25PM -0400, Vladislav Bolkhovitin wrote:
> 
>>> thread 1:
>>> 	down_read(&A); /* got it */
>>> thread 2:
>>> 	down_read(&B); /* got it */
>>> thread 3:
>>> 	down_write(&A);	/* blocked until thread 1 releases A */
> 
> That's the only thread here doing down_write() on A
> 
>>> thread 4:
>>> 	down_write(&B);	/* blocked until thread 2 releases B */
> 
> ... and that's the only thread here doing down_write() on B.  And neither
> of those is holding any other locks.  No nesting.
> 
>> 1. Reverse read locking isn't always a deadlock. For instance, if only 1 write
>> thread participating and doesn't do nested write locking, which is a quite valid
>> scenario, because by design of rw locks they are used with many readers and
>> limited amount of rare writers.
> 
> Um?  If you mean that here we have two threads doing down_write(), remember
> that you've got two locks.

No, consider there is only one management thread doing either down_write(&A), or
down_write(&B), never both, with a set of worker threads doing down_read() of any
locks in any order.

_One_ down_write() thread, no down_write() nesting => no deadlock possibility.

>> So, it should be better if this warning is issued, if there is >1 thread write
>> locking detected on any participated rw lock, and illustrated with a correct
>> explanation.
> 
> Which would be which threads, in the situation described above?  Again,
> we have no nesting for writes and we have one thread attempting down_write()
> for any given lock.  Two locks, two writers in total...

Consider we have N rw locks/semaphores depending from each other and not following
strict read locking rule, i.e. down_read() all or some of them in any order. The
lockdep warning should be issued only if detected that any of those locks
down_write() in more than 1 thread or there is attempt of nesting down_write() of
any of the locks. This will be more correct handling of the RW locks dependency
than currently.

I hope, lockdep already stores some info to recognize current thread/process and
separate dependency chains, so this info can be reused.

Vlad
