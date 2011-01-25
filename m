Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1AYB7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:59:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52566 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab1AYB7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:59:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t3KUO2kbWxt8WPxgz6y1eaZfq+OUx+xuVMaC5umUSCP9pKHAuSIvuTg0WpyTx6iEee
         NJY2KRFZTELYrSqVGE4fER6khJh6B0UEQhe0hPdjZac4wYb+YLf7fgU2sbqXd08ggX0T
         q2I1ZL2Om5IxPpSVUTeJoETskTPQorW2fjJFw=
MIME-Version: 1.0
In-Reply-To: <1295894492.28776.470.camel@laptop>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
	<1295894492.28776.470.camel@laptop>
Date: Mon, 24 Jan 2011 20:59:37 -0500
Message-ID: <AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused by pm_idle
From: Luming Yu <luming.yu@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 2:41 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-01-24 at 02:34 -0500, Luming Yu wrote:
>> Hi there,
>>
>> I've seen many problems caused by deep-c-state-capable pm_idle on a
>> NHM-EX system with this test script
>> # for i in `seq 1 1000`; do echo $i; echo 0 >
>> /sys/devices/system/cpu/cpu59/online ; sleep 1; echo 1 >
>> /sys/devices/system/cpu/cpu59/online; done
>>
>> As the bug " CPU online/offline causes system slowdown"
>> https://bugzilla.redhat.com/show_bug.cgi?id=586551 described.
>>
>> The simplest and easiest and cleanest way I can think of now is as the
>> patch attached.
>>
>> Signed-off-by: Yu Luming <luming.yu@intel.com>
>>
>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>> index c75fcdd..d419eb3 100644
>> --- a/kernel/cpu.c
>> +++ b/kernel/cpu.c
>> @@ -135,6 +135,7 @@ int __ref register_cpu_notifier(struct notifier_block *nb)
>>
>>  #ifdef CONFIG_HOTPLUG_CPU
>>
>> +static void (*pm_idle_saved) (void) __read_mostly;
>>  EXPORT_SYMBOL(register_cpu_notifier);
>>
>>  void __ref unregister_cpu_notifier(struct notifier_block *nb)
>> @@ -145,6 +146,19 @@ void __ref unregister_cpu_notifier(struct
>> notifier_block *nb)
>>  }
>>  EXPORT_SYMBOL(unregister_cpu_notifier);
>>
>> +static inline void save_pm_idle(void)
>> +{
>> +     pm_idle_saved = pm_idle;
>> +     pm_idle = default_idle;
>> +     cpu_idle_wait();
>> +}
>> +
>> +static inline void restore_pm_idle(void)
>> +{
>> +     pm_idle = pm_idle_saved;
>> +     cpu_idle_wait();
>> +}
>> +
>>  static inline void check_for_tasks(int cpu)
>>  {
>>       struct task_struct *p;
>> @@ -278,7 +292,9 @@ int __ref cpu_down(unsigned int cpu)
>>               goto out;
>>       }
>>
>> +     save_pm_idle();
>>       err = _cpu_down(cpu, 0);
>> +     restore_pm_idle();
>>
>>  out:
>>       cpu_maps_update_done();
>> @@ -376,7 +392,9 @@ int __cpuinit cpu_up(unsigned int cpu)
>>               goto out;
>>       }
>>
>> +     save_pm_idle();
>>       err = _cpu_up(cpu, 0);
>> +     restore_pm_idle();
>>
>>  out:
>>       cpu_maps_update_done();
>
> Ow god this is ugly.. pm_idle should die asap, not find it way into generic code, so NAK!

Without the ugly fix, we seem not able to fix the problem in short time.
Or , Are you suggesting to wrap  pm_idle or similar in some generic
code that would not disappear in foreseeable future , Or  Are you just
suggesting me don't do the stuff in kerne/cpu.c, and do it in Arch
code?
But..I bet It's not that wise to let CPU hot-plug code to interact
with PM code for all Arch, so I proposed the ugly patch in generic
code.

--Luming
