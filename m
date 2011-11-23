Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab1KWIzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:55:53 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43761 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1KWIzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:55:51 -0500
X-AuditID: b753bd60-a1286ba000000655-51-4eccb51561bd
X-AuditID: b753bd60-a1286ba000000655-51-4eccb51561bd
Message-ID: <4ECCB507.6040701@hitachi.com>
Date: Wed, 23 Nov 2011 17:55:35 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Randy Dunlap <rdunlap@xenotime.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/5] x86: check stack overflows more reliably
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp> <CAOJsxLGH6maRZPx0TX4r6Zy=AiXQMRssoySeOmjn02O-BkBDEA@mail.gmail.com> <4EB8DB84.6070300@hitachi.com> <20111117165938.GA2441@redhat.com>
In-Reply-To: <20111117165938.GA2441@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

> Another thought might be to make stack_overflow_check() depend on a jump
> label. Its not something that going to be switch on/off often, and then perhaps
> we wouldn't even need DEBUG_STACKOVERFLOW...It seems like a good
> use-case to me.

It is interesting to use a jump label for stack overflow checking...
However, I'd like to implement this detail-check simply using
DEBUG_STACKOVERFLOW option because I guess stack_overflow_check() will
be seldom switched on/off after the system operation starts, as you said.

In addition, I will change the default overflow checking to the
detail-check instead of the original one if the option is enabled in
Kconfig. This is because it turned out that the additional checking
overhead is negligible (about 17 cycles) from the evaluation below.


[Evaluation]

The performance of the detail-check was compared to original one
which checks kernel stack only, on the following conditions.

- Measure the worst performance using tsc.
  In the detail-check, all stack type were checked for every IRQ
  even if the stack pointer pointed to all available stacks.
  That is, the patch was changed a little for this evaluation.
- Calculate the average from the 30,000 IRQ evaluations.

The results show the performance regression of the detail-check
for a IRQ is 17 cycles compared to the original one.


	| Original | Detail Check |
-----------------------------------
Average	|    49    |      66      |
(cycles)

I think this overhead can be ignored.

Thanks

(2011/11/18 1:59), Jason Baron wrote:
> On Tue, Nov 08, 2011 at 04:34:28PM +0900, HAYASAKA Mitsuo wrote:
>> Hi Pekka,
>>
>> Thank you for your comments.
>>
>> (2011/11/07 16:00), Pekka Enberg wrote:
>>> On Mon, Nov 7, 2011 at 7:51 AM, Mitsuo Hayasaka
>>> <mitsuo.hayasaka.hu@hitachi.com> wrote:
>>>> (2) check stack overflow in detail
>>>>    Currently, only kernel stack is checked for the overflow,
>>>>    which is not sufficient for enterprise systems. To enhance
>>>>    reliability, expand stack overflow checking to IRQ and
>>>>    exception stacks optionally. This is disabled by default
>>>>    in Kconfig.
>>>
>>> This sounds useful. What's the reason for not enabling this by
>>> default? Performance regressions?
>>
>> I'm worried about performance regressions because this patch checks 
>> a stack overflow in detail.
>>
>> However, I guess there is no problem for enabling it by default 
>> since this option is for debug and appears only if a DEBUG_STACKOVERFLOW
>> option is enabled.
>>
>> So, I'd like to send the revised patch if it does not have any further problem.
>>
>>
> 
> Another thought might be to make stack_overflow_check() depend on a jump
> label. Its not something that going to be switch on/off often, and then perhaps
> we wouldn't even need DEBUG_STACKOVERFLOW...It seems like a good
> use-case to me.
> 
> Thanks,
> 
> -Jason
> 

