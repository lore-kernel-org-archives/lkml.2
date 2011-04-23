Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1DWM1i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 08:27:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5091 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1DWM1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 08:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mh5GnMpgdcbzARXpkfoxbg/KO/tH/P4HQbAAfUJ7q1aP8uVJkgTJegMS+NKve9w6Lb
         t+jAOzwxNfc7ovBWsqDQ==
MIME-Version: 1.0
In-Reply-To: <20110422210335.GB21364@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
	<20110422092322.GA1948@elte.hu>
	<BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
	<20110422105211.GB1948@elte.hu>
	<BANLkTinaZyHNV2Bm7CJFJ11WBCPGgsYijQ@mail.gmail.com>
	<20110422131846.GA20760@elte.hu>
	<BANLkTi=jdSG1Zefn_b7Pv2NyT1jdREzW8w@mail.gmail.com>
	<20110422210335.GB21364@elte.hu>
Date: Sat, 23 Apr 2011 14:27:33 +0200
Message-ID: <BANLkTi=v=nVGO43ad3oR-1us4Y_abYKOXQ@mail.gmail.com>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 11:03 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> Let's go back to your example.
>> Performance counter stats for './array' (10 runs):
>>
>>          6,719,130 cycles:u                   ( +-   0.662% )
>>          5,084,792 instructions:u           #      0.757 IPC     ( +-   0.000% )
>>          1,037,032 l1-dcache-loads:u          ( +-   0.009% )
>>          1,003,604 l1-dcache-load-misses:u    ( +-   0.003% )
>>
>> Looking at this I don't think you can pinpoint which function has a problem
>> [...]
>
> In my previous mail i showed how to pinpoint specific functions. You bring up
> an interesting question, cost/benefit analysis:
>
>> [...] and whether or not there is a real problem. You need to evaluate the
>> penalty. Once you know that you can estimate any potential gain from fixing
>> the code. Arun pointed that out rightfully in his answer. How do you know the
>> penalty if you don't decompose some more?
>
> We can measure that even with today's tooling - which doesnt do cost/benefit
> analysis out of box. In my previous example i showed the cachemisses profile:
>
>   weight    samples  pcnt funct DSO
>   ______    _______ _____ _____ ______________________
>
>      1.9       6184 98.8% func2 /home/mingo/opt/array2
>      0.0         69  1.1% func1 /home/mingo/opt/array2
>
> and here's the cycles profile:
>
>             samples  pcnt funct DSO
>             _______ _____ _____ ______________________
>
>             2555.00 67.4% func2 /home/mingo/opt/array2
>             1220.00 32.2% func1 /home/mingo/opt/array2
>
> So, given that there was no other big miss sources:
>
>  $ perf stat -a -e branch-misses:u -e l1-dcache-load-misses:u -e l1-dcache-store-misses:u -e l1-icache-load-misses:u sleep 1
>
>  Performance counter stats for 'sleep 1':
>
>            70,674 branch-misses:u
>       347,992,027 l1-dcache-load-misses:u
>             1,779 l1-dcache-store-misses:u
>             8,007 l1-icache-load-misses:u
>
>        1.000982021  seconds time elapsed
>
> I can tell you that by fixing the cache-misses in that function, the code will
> be roughly 33% faster.
>
33% based on what? l1d-load-misses? The fact that in the same program you have a
problematic function, func1(), and its fixed counter-part func2() +
you know both do
the same thing? How often do you think this happens in real life?

Now, imagine you don't have func2(). Tell me how much of an impact (cycles)
you think func1() is having on the overall execution of a program especially
if is far more complex that your toy example above?

Your arguments would carry more weight if you were to derive them from real
life applications.


> So i fixed the bug, and before it 100 iterations of func1+func2 took 300 msecs:
>
>  $ perf stat -e cpu-clock --repeat 10 ./array2
>
>  Performance counter stats for './array2' (10 runs):
>
>        298.405074 cpu-clock                  ( +-   1.823% )
>
> After the fix it took 190 msecs:
>
>  $ perf stat -e cpu-clock --repeat 10 ./array2
>
>  Performance counter stats for './array2' (10 runs):
>
>        189.409569 cpu-clock                  ( +-   0.019% )
>
>        0.190007596  seconds time elapsed   ( +-   0.025% )
>
> Which is 63% of the original speed - 37% faster. And no, i first did the
> calculation, then did the measurement of the optimized code.
>
> Now it would be nice to automate such analysis some more within perf - but i
> think i have established the principle well enough that we can use generic
> cache events for such measurements.
>
> Also, we could certainly add more generic events - a stalled-cycles event would
> certainly be useful for example, to collect all (or at least most) 'harmful
> delays' the execution flow can experience. Want to take a stab at that patch?
>
> Thanks,
>
>        Ingo
>
