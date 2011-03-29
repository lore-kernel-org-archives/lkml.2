Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1C2Lyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:54:54 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45580 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab1C2Lyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=kaGCmV3vC8nsukwDRsEr4XOmN03VVfuQ5eGmvT2s5+gX3OIVJHScReaUavL5+0Oy7u
         vNu/Rp7Mlj4VZ45rkqU0Pd+hDs9Mz1C8QhixMAaeUg2T232lb9czMoLziS/e5+JAj501
         f6q41nPPHoDS6bvv+AQ0An0WREOTzQpDF2+CQ=
MIME-Version: 1.0
In-Reply-To: <20110329062112.GC27398@elte.hu>
References: <cover.1301324270.git.luto@mit.edu> <75824c7636ab74a71598080867c927d313c8ab66.1301324270.git.luto@mit.edu>
 <20110329062112.GC27398@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 29 Mar 2011 07:54:32 -0400
X-Google-Sender-Auth: OSqA_GOsdTRHiPyW69hez3gpKgE
Message-ID: <AANLkTimKhuZ3QbvRROj+-gKpFO2w-SyMDnGoDbqK9iPi@mail.gmail.com>
Subject: Re: [PATCH 4/6] x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever
 see nsec < 0
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 2:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@MIT.EDU> wrote:
>
>> vclock_gettime's do_monotonic helper can't ever generate a negative
>> nsec value, so it doesn't need to check whether it's negative.  This
>> saves a single easily-predicted branch.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> ---
>>  arch/x86/vdso/vclock_gettime.c |   40 ++++++++++++++++++++++------------------
>>  1 files changed, 22 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
>> index ee55754..67d54bb 100644
>> --- a/arch/x86/vdso/vclock_gettime.c
>> +++ b/arch/x86/vdso/vclock_gettime.c
>> @@ -56,22 +56,6 @@ notrace static noinline int do_realtime(struct timespec *ts)
>>       return 0;
>>  }
>>
>> -/* Copy of the version in kernel/time.c which we cannot directly access */
>> -notrace static void
>> -vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
>> -{
>> -     while (nsec >= NSEC_PER_SEC) {
>> -             nsec -= NSEC_PER_SEC;
>> -             ++sec;
>> -     }
>> -     while (nsec < 0) {
>> -             nsec += NSEC_PER_SEC;
>> -             --sec;
>> -     }
>> -     ts->tv_sec = sec;
>> -     ts->tv_nsec = nsec;
>> -}
>> -
>>  notrace static noinline int do_monotonic(struct timespec *ts)
>>  {
>>       unsigned long seq, ns, secs;
>> @@ -82,7 +66,17 @@ notrace static noinline int do_monotonic(struct timespec *ts)
>>               secs += gtod->wall_to_monotonic.tv_sec;
>>               ns += gtod->wall_to_monotonic.tv_nsec;
>>       } while (unlikely(read_seqretry(&gtod->lock, seq)));
>> -     vset_normalized_timespec(ts, secs, ns);
>> +
>> +     /* wall_time_nsec, vgetns(), and wall_to_monotonic.tv_nsec
>> +      * are all guaranteed to be nonnegative.
>> +      */
>> +     while (ns >= NSEC_PER_SEC) {
>> +             ns -= NSEC_PER_SEC;
>> +             ++secs;
>> +     }
>> +     ts->tv_sec = secs;
>> +     ts->tv_nsec = ns;
>> +
>>       return 0;
>>  }
>>
>> @@ -107,7 +101,17 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
>>               secs += gtod->wall_to_monotonic.tv_sec;
>>               ns += gtod->wall_to_monotonic.tv_nsec;
>>       } while (unlikely(read_seqretry(&gtod->lock, seq)));
>> -     vset_normalized_timespec(ts, secs, ns);
>> +
>> +     /* wall_time_nsec and wall_to_monotonic.tv_nsec are
>> +      * guaranteed to be between 0 and NSEC_PER_SEC.
>> +      */
>> +     if (ns >= NSEC_PER_SEC) {
>> +             ns -= NSEC_PER_SEC;
>> +             ++secs;
>> +     }
>> +     ts->tv_sec = secs;
>> +     ts->tv_nsec = ns;
>> +
>>       return 0;
>
> Beyond the change you describe in the changelog, you also uninlined the helper
> function.
>
> You can use __always_inline instead and still keep the code maintainable.
>

I think I should fix the changelog instead.  The two copies are
different (one uses while because nsec > 2e9 is possible and one uses
if because nsec < 2e9 always).

--Andy
