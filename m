Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab2DBI1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 04:27:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40296 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2DBI1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 04:27:49 -0400
Message-ID: <4F796300.5040905@openvz.org>
Date: Mon, 02 Apr 2012 12:27:44 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Igor Mammedov <imammedo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: v3.4-rc1 s2ram regression
References: <20120401132643.4922.79748.stgit@zurg> <20120401165354.GA18526@amt.cnet>
In-Reply-To: <20120401165354.GA18526@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> On Sun, Apr 01, 2012 at 05:26:43PM +0400, Konstantin Khlebnikov wrote:
>> commit b74f05d61b73af584d0c39121980171389ecfaaa
>> ("x86: kvmclock: abstract save/restore sched_clock_state")
>> breaks s2ram for my notebook. It hangs (maybe panic) somewhere on resume stage
>> and blinks with all possible leds =) Screen is black, so I don't know what happened.
>>
>> reverting or following patch helps
>>
>> Bisected-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> Cc: Thomas Gleixner<tglx@linutronix.de>
>> Cc: Marcelo Tosatti<mtosatti@redhat.com>
>> Cc: Avi Kivity<avi@redhat.com>
>> Cc: Igor Mammedov<imammedo@redhat.com>
>> ---
>>   arch/x86/power/cpu.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
>> index 4793683..2bc5a82 100644
>> --- a/arch/x86/power/cpu.c
>> +++ b/arch/x86/power/cpu.c
>> @@ -231,8 +231,8 @@ static void __restore_processor_state(struct saved_context *ctxt)
>>   /* Needed by apm.c */
>>   void restore_processor_state(void)
>>   {
>> -	x86_platform.restore_sched_clock_state();
>>   	__restore_processor_state(&saved_context);
>> +	x86_platform.restore_sched_clock_state();
>>   }
>>   #ifdef CONFIG_X86_32
>>   EXPORT_SYMBOL(restore_processor_state);
>
> The correct fix is in kvm.git (see below).

Thanks. Your patch works for me too.

>
> Ingo, can you please merge it through x86 tree while the
> kvm.git issues are resolved? It has been forward to you directly.
>
>      x86: call restore_sched_clock_state after %gs is initialized
>
>      restore_sched_clock_state methods use percpu data, therefore they
>      must run after %gs is initialized, but before mtrr_bp_restore (due to
>      lockstat using sched_clock).
>
>      Move it to the correct place.
>
>      Signed-off-by: Marcelo Tosatti<mtosatti@redhat.com>
>      Signed-off-by: Avi Kivity<avi@redhat.com>
>
>

