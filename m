Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab1FGTEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:04:24 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61875 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab1FGTEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=LHpqpMCp2o9GjAnkLUR7bqCELhLWjhXnzD3N5P9cHtdcBjk6zBc7m0Is8GLcXYvxC8
         EW3z028bD6A2lCSijHwjqYs/VVxUQdtF79sUNdFkLBuvnh/npfLq4mbKOjfuSfwW2yjA
         jxBwbEvRY33k6jUqPwIHO3PkFX5UKG/U7MJak=
MIME-Version: 1.0
In-Reply-To: <4DEE758F.8060002@linux.intel.com>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
 <1307373819.3098.40.camel@edumazet-laptop> <1307376672.2322.167.camel@twins>
 <1307376989.2322.171.camel@twins> <1307377349.3098.65.camel@edumazet-laptop>
 <1307377782.2322.183.camel@twins> <1307378564.3098.67.camel@edumazet-laptop>
 <4DED1421.5000300@linux.intel.com> <1307383898.3098.90.camel@edumazet-laptop>
 <4DED976C.90009@linux.intel.com> <4DEE3944.5020005@mit.edu>
 <1307462300.3091.39.camel@edumazet-laptop> <BANLkTinyuHUGXACJYUT241g8rzg6AzPBiA@mail.gmail.com>
 <4DEE758F.8060002@linux.intel.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 7 Jun 2011 15:04:03 -0400
X-Google-Sender-Auth: UwKUgf2DtVptT99dKGCp5WttUJU
Message-ID: <BANLkTi=fJ6dY04uz9O0WaNb+f+wg-528Sg@mail.gmail.com>
Subject: Re: Change in functionality of futex() system call.
To: Darren Hart <dvhart@linux.intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 3:01 PM, Darren Hart <dvhart@linux.intel.com> wrote:
>>> If a group of cooperating processes uses a memory segment to exchange
>>> critical information, do you really think this memory segment will be
>>> readable by other unrelated processes on the machine ?
>>
>> Depends on the design.
>>
>> I have some software I'm working on that uses shared files and could
>> easily use futexes.  I don't want random read-only processes to
>> interfere with the futex protocol.
>
>
> So don't use world readable files.

...which prevents people from *reading* them, which was the whole point.

>
>
>>>
>>> How is this related to futex code ?
>>
>> Because this usage is currently safe and would become unsafe with the
>> proposed change.
>>
>>>
>>> Same problem for legacy IPC (shm, msg, sem) : Appropriate protections
>>> are needed, obviously.
>>>
>>> BTW, kernel/futex.c uses a global hash table (futex_queues[256]) and a
>>> very predictable hash_futex(), so its easy to slow down futex users...
>>
>> There's a difference between slowing down users by abusing a kernel
>> hash and deadlocking users by eating a wakeup.  (If you eat a wakeup
>> the wakeup won't magically come back later.  It's gone.)
>
> That's the nature of SHARED, you have to protect the mapping independent
> of the futex mechanism.

Well... it used to mean you have to protect from untrusted RW users.
Now it will mean you have to protect from untrusted RO users.

AFAICT sys_futex will become the only way that a user with RO access
to a file can actually interfere with the owner of the file (as
opposed to just learning information).

Why do we need this change again?

--Andy
