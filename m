Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab0DEJOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 05:14:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49387 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0DEJOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 05:14:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=pQm/5RWIlkbyh23jjZEP5JceUCJQjLNHvdb1jRgxe4+YhXAm5SGYaHVZR6x0qUpgS
	I9NM25nxgL8AyzOarpgoQ==
MIME-Version: 1.0
In-Reply-To: <4B9B1416.5020101@dcl.info.waseda.ac.jp>
References: <4B98BB50.1000002@cn.fujitsu.com>
	 <4B9B1416.5020101@dcl.info.waseda.ac.jp>
Date: Mon, 5 Apr 2010 02:14:06 -0700
Message-ID: <n2k8d20b11a1004050214m529fa5e7ke31a2213728ea511@mail.gmail.com>
Subject: Re: lock's trace events can improve mutex's performance in userspace?
From: Michel Lespinasse <walken@google.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ming Lei <tom.leiming@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply...

One thing to consider in locking micro-benchmarks is that often, code
changes that slow down parts of the contended code path where the lock
is not held, will result in an increase of the reported
micro-benchmark metric. This effect is particularly marked for
micro-benchmarks that consist of multiple threads doing empty
acquire/release loops.

As a thought experiment, imagine what would happen if you added a
one-millisecond sleep in the contended code path for mutex
acquisition. Soon all but one of your benchmark threads would be
sleeping, and the only non-sleeping thread would be able to spin on
that lock/unlock loop with no contention, resulting in very nice
results for the micro-benchmark. Remove the sleep and the lock/unlock
threads will have to contend, resulting in lower reported performance
metrics.

I think what you're seeing with lockdep events is a smaller case of
this - enabling lockdep slows down the contended code path, but also
reduces the number of times that it is taken...

On Fri, Mar 12, 2010 at 8:27 PM, Hitoshi Mitake
<mitake@dcl.info.waseda.ac.jp> wrote:
> On 03/11/10 18:43, Xiao Guangrong wrote:
>> We found that if enable lock's trace events, the 'sysbench mutex'
>> benchmark program can run quicker.
>>
>> The simple program that is attached can reproduce it, the system info,
>> kernel config, and the script are also attached.
>>
>> The test step is below:
>>
>> # tar -zxvf test-mutex.tar.bz
>> # cd test-mutex
>> # make
>> # ./tscript.sh>&  log
>> # cat log | grep "real"
>> real    0m46.765s<  all trace events are disabled>
>> real    0m47.073s
>> real    0m47.402s
>> real    0m46.458s
>> real    0m47.433s
>> real    0m47.395s
>> real    0m47.010s
>> real    0m47.454s
>> real    0m47.044s
>> real    0m47.464s
>> real    0m39.245s<  enable lock's trace events>
>> real    0m40.822s
>> real    0m40.779s
>> real    0m40.549s
>> real    0m40.605s
>> real    0m40.923s
>> real    0m40.560s
>> real    0m41.050s
>> real    0m40.757s
>> real    0m40.715s
>>
>> [ "<  ...>" is my comments ]
>>
>>  From the result, we can see the program's runtime is less if enable
> lock's
>> trace events.
>>
>> The conclusion is weird but i don't know why.
>
> Hi Xiao,
>
> It's hard to believe, but...
>
> % sudo ./tscript.sh &> log
> % grep real log
> real    0m24.132s
> real    0m23.535s
> real    0m20.064s
> real    0m16.636s <- enabled from here
> real    0m16.435s
> real    0m17.339s
>
> I could reproduce your surprising result.
> (I only execed your benchmark 3 times.)
>
> I rewrote your mainc.c and checked contended count of each test like
> this way,
>                if (pthread_mutex_trylock(&mutex) == EBUSY) {
>                        pthread_mutex_lock(&mutex);
>                        atomic_inc(&contended);
>                }
> # I'll attach my new mainc.c
>
> % cat log
> Run mutex with trace events disabled...
> contended:25191221
>
> real    0m24.132s
> user    0m17.149s
> sys     1m18.933s
> contended:25360563
>
> real    0m23.535s
> user    0m17.233s
> sys     1m16.213s
> contended:23813911
>
> real    0m20.064s
> user    0m15.561s
> sys     1m4.332s
> Run mutex with lockdep events enabled...
> contended:11458318
>
> real    0m16.636s
> user    0m10.173s
> sys     0m55.595s
> contended:11881095
>
> real    0m16.435s
> user    0m10.273s
> sys     0m54.911s
> contended:11261650
>
> real    0m17.339s
> user    0m10.225s
> sys     0m58.556s
>
> It seems that num of contention decreased to about half.
> I don't know why this happened and effect to performance of it,
> but this result is worth to consider.
>
> Thanks,
>        Hitoshi
>



-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
