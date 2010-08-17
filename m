Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab0HQE1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:27:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45977 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0HQE1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lw1T51DKj0UYsu2C58ml4afzd0KVSlxAZ0+GKBr5K/TeciM1NosWYDB+D1O6XbNx1Q
         uogKGKcdC7jYG/3V3jCZ/pSGROoazND4hxZzh3qHfPYEOjfxGgoKOjwkmDY7aAuUitCD
         4ith1Dyq5aOOgjs/4V1kgFETBzQbvvipxI24w=
MIME-Version: 1.0
In-Reply-To: <20100816143052.GV4879@redhat.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
	<1281946970.1926.998.camel@laptop>
	<20100816133452.GS4879@redhat.com>
	<1281966418.1926.1421.camel@laptop>
	<20100816140829.GA5225@swordfish.minsk.epam.com>
	<20100816143052.GV4879@redhat.com>
Date: Tue, 17 Aug 2010 12:27:05 +0800
Message-ID: <AANLkTikiLsPPbnZ0KESFmb903KgmpP0DFcrcr5rR0V1=@mail.gmail.com>
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
From: Yong Zhang <yong.zhang0@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 10:30 PM, Don Zickus <dzickus@redhat.com> wrote:
>> Patch also removes double smp_processor_id call (smp_processor_id itself and in
>> __get_cpu_var) in __touch_watchdog.

After checking touch_softlockup_watchdog() and touch_nmi_watchdog() in
before version, __raw_get_cpu_var() is used there.

Thanks,
Yong

>>
>> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>
> Acked-by: Don Zickus <dzickus@redhat.com>
>
>>
>> ---
>>
>> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
>> index 613bc1f..8822f1e 100644
>> --- a/kernel/watchdog.c
>> +++ b/kernel/watchdog.c
>> @@ -116,13 +116,14 @@ static unsigned long get_sample_period(void)
>>  static void __touch_watchdog(void)
>>  {
>>       int this_cpu = smp_processor_id();
>> -
>> -     __get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
>> +     per_cpu(watchdog_touch_ts, this_cpu) = get_timestamp(this_cpu);
>>  }
>>
>>  void touch_softlockup_watchdog(void)
>>  {
>> -     __get_cpu_var(watchdog_touch_ts) = 0;
>> +     int this_cpu = get_cpu();
>> +     per_cpu(watchdog_touch_ts, this_cpu) = 0;
>> +     put_cpu();
>>  }
>>  EXPORT_SYMBOL(touch_softlockup_watchdog);
>>
>> @@ -142,7 +143,9 @@ void touch_all_softlockup_watchdogs(void)
>>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>>  void touch_nmi_watchdog(void)
>>  {
>> -     __get_cpu_var(watchdog_nmi_touch) = true;
>> +     int this_cpu = get_cpu();
>> +     per_cpu(watchdog_nmi_touch, this_cpu) = true;
>> +     put_cpu();
>>       touch_softlockup_watchdog();
>>  }
>>  EXPORT_SYMBOL(touch_nmi_watchdog);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
