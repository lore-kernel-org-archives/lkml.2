Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab1CDVHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:07:23 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44175 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab1CDVHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:07:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cpb2YkvQ64s+A5vlGfTzZmICOD5XCfOxTHDoIQRwecNvKf9XjOr+5MBMk6ldhyaLBB
         iQ5UiIwWRL1ICLHZ9yV6nmZOVHWhqOCpGRzyfLJLlOUi/H8oVS219S3bJgT7cVJyQZFN
         dYd7cSpG0YiAchI3UL7zLo4ydW58T8vu1/u3g=
MIME-Version: 1.0
In-Reply-To: <20110304171619.GB9311@gere.osrc.amd.com>
References: <1299245367-20279-1-git-send-email-jp.lacerda@codethink.co.uk>
	<20110304171619.GB9311@gere.osrc.amd.com>
Date: Fri, 4 Mar 2011 22:07:21 +0100
Message-ID: <AANLkTim42BWV4EiM7M6m8CLQZMZ4j8LnBgA-+2Wz==9a@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Fix mcheck_init_device() to handle
 misc_register() correctly
From: Johan Wessfeldt <johan.wessfeldt@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "J.P. Lacerda" <jp.lacerda@codethink.co.uk>, akpm@linux-foundation.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 6:16 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Fri, Mar 04, 2011 at 01:29:27PM +0000, J.P. Lacerda wrote:
>> The return value for misc_register() was not being taken into account.
>> Furthermore, if misc_register() fails, we must rollback any changes made by
>> mcheck_init_device()
>
> If you're going to fix all error paths here, you still need to handle
> unrolling the setup done by mce_create_device() if we fail somewhere in
> between.
>
>> Signed-off-by: J.P. Lacerda <jp.lacerda@codethink.co.uk>
>> ---
>>  arch/x86/kernel/cpu/mcheck/mce.c |   13 ++++++++++++-
>>  1 files changed, 12 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
>> index d916183..20c2c44 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
>> @@ -2140,7 +2140,18 @@ static __init int mcheck_init_device(void)
>>       }
>>
>>       register_hotcpu_notifier(&mce_cpu_notifier);
>> -     misc_register(&mce_log_device);
>> +     err = misc_register(&mce_log_device);
>> +
>
> no newline here.
>
>> +     if (err) {
>> +             unregister_hotcpu_notifier(&mce_cpu_notifier);
>> +
>> +             for_each_online_cpu(i) {
>> +                     mce_remove_device(i);
>> +             }
>
> no need for braces around a single loop body statement.
>
>> +
>> +             sysdev_class_unregister(&mce_sysclass);
>> +             free_cpumask_var(mce_dev_initialized);
>> +     }
>>
>>       return err;
>
> Anyway, while this is makes sense from correctness POV, if we hit an
> error path here this early then something else is going terribly wrong
> which would've screamed very loudly already. Are you hitting this on a
> real workload or you caught this by code staring?
The orginal patch was made with the intention of auditing the code
according to the kernel-janitors TODO list:
http://kernelnewbies.org/KernelJanitors/Todo/ReturnCodes .

To clear things up. I originally posted a minor patch, which basically passed
the return value from misc_register up the stack. See
http://marc.info/?l=linux-kernel&m=129889198732342&w=2

The patch was rejected with comments about how to clean everything up
if misc_register() fails.

Here's my second attempt:
http://marc.info/?l=linux-kernel&m=129926353413345&w=2

(Dan Carpenter just explained to me how to go about resubmitting the
patches thanks)

Sorry for the confusion.
>
> Because if it is the second case, the merit of fixing those error
> paths vs adding code which is almost never executed is significantly
> diminished.
>
> Thanks.
>
> --
> Regards/Gruss,
> Boris.
>
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
> Registergericht Muenchen, HRB Nr. 43632
>
