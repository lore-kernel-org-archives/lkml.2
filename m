Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab1FQBtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:49:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60060 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab1FQBtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:49:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFAB26D.6050202@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 10:48:29 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: linux-kernel@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] x86, mce: stop calling del_timer_sync() from interrupt
References: <4DF9B0A3.4030904@jp.fujitsu.com> <20110616140915.GA5065@gere.osrc.amd.com>
In-Reply-To: <20110616140915.GA5065@gere.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/16 23:09), Borislav Petkov wrote:
> On Thu, Jun 16, 2011 at 04:28:35PM +0900, Hidetoshi Seto wrote:
>> Use of on_each_cpu() results in calling the function passed as the
>> argument on interrupt context.
> 
> 	   in
> 
>> Calling del_timer_sync() from interrupt context can cause deadlock
>> if it interrupts the target timer running.
>>
>> MCE code has some such misuse of del_timer_sync() in parts for sysfs
>> file; bank*, check_interval, cmci_disabled and ignore_ce.
>> Fortunately these files are rare-used but you will be warned on write.
> 
> So, you're saying you're hitting the WARN_ON(in_irq()) in
> del_timer_sync() ?

Yes.  It is terrible that there are simultaneous WARN_ON() * online_cpus.
I should have write something clear about that here in patch description.

>> This patch will fix it.
> 
> You could say
> 
>   "Move timer deletion outside of the interrupt context as a fix"
> 
> or something to that effect to make it much more precise what the patch
> is doing.

Sure, I'll update it.
 
> Patch idea looks fine, see below for some nitpicking :).
> 
>>
>> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>> ---
>>  arch/x86/kernel/cpu/mcheck/mce.c |   22 ++++++++++++++++------
>>  1 files changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
>> index ff1ae9b..77df54f 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
>> @@ -1170,6 +1170,17 @@ static void mce_start_timer(unsigned long data)
>>  	add_timer_on(t, smp_processor_id());
>>  }
>>  
>> +/* Must not be called from interrupt where del_timer_sync() can deadlock */
>> +static void mce_timer_delete_all(void)
>> +{
>> +	int cpu;
>> +
>> +	for_each_online_cpu(cpu) {
>> +		if (mce_available(&per_cpu(cpu_info, cpu)))
>> +			del_timer_sync(&per_cpu(mce_timer, cpu));
>> +	}
>> +}
>> +
>>  static void mce_do_trigger(struct work_struct *work)
>>  {
>>  	call_usermodehelper(mce_helper, mce_helper_argv, NULL, UMH_NO_WAIT);
>> @@ -1768,7 +1779,6 @@ static struct syscore_ops mce_syscore_ops = {
>>  
>>  static void mce_cpu_restart(void *data)
>>  {
>> -	del_timer_sync(&__get_cpu_var(mce_timer));
>>  	if (!mce_available(__this_cpu_ptr(&cpu_info)))
>>  		return;
> 
> I'm wondering, was this actually a bug - the fact that we deleted the
> timer _before_ we do the mce_available() check.
> 
> In looking at it a bit more, it looks like mce_restart() is always
> executed on codepaths behind mce_available() checks so the
> 
> 	if (mce_available(...))
> 		del_timer_sync(...);
> 
> part in mce_timer_delete_all could be done without the if-check, no?

Yes, I've noticed it too.
Notable point is that these sysfs files are not created when
!mce_available(). :-P

However it is an entirely different matter than what this patch is
addressed.  Just to keep old logic in mce_disable_ce(), I've added
mce_available() in the mce_timer_delete_all().

I think we can remove many redundant if-checks w/ mce_available()
around here and there.

Now I'm writing a patch for that... Please wait.


Thanks,
H.Seto

