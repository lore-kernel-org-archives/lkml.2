Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab2GICbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:31:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41833 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2GICb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:31:29 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA4269.5050808@jp.fujitsu.com>
Date: Mon, 9 Jul 2012 11:31:05 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: <linux-acpi@vger.kernel.org>, <lenb@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] acpi : cpu hot-remove returns error number when cpu_down()
 fails
References: <4FF65898.3000301@jp.fujitsu.com> <4FF6B537.1030703@linux.vnet.ibm.com>
In-Reply-To: <4FF6B537.1030703@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srivatsa,

Thank you for your reviewing.

2012/07/06 18:51, Srivatsa S. Bhat wrote:
> On 07/06/2012 08:46 AM, Yasuaki Ishimatsu wrote:
>> Even if cpu_down() fails, acpi_processor_remove() continues to remove the cpu.
> 
> Ouch!
> 
>> But in this case, it should return error number since some process may run on
>> the cpu. If the cpu has a running process and the cpu is turned the power off,
>> the system cannot work well.
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> ---
>>   drivers/acpi/processor_driver.c |   18 ++++++++++++------
>>   1 file changed, 12 insertions(+), 6 deletions(-)
>>
>> Index: linux-3.5-rc4/drivers/acpi/processor_driver.c
>> ===================================================================
>> --- linux-3.5-rc4.orig/drivers/acpi/processor_driver.c	2012-06-25 04:53:04.000000000 +0900
>> +++ linux-3.5-rc4/drivers/acpi/processor_driver.c	2012-07-05 21:02:58.711285382 +0900
>> @@ -610,7 +610,7 @@ err_free_pr:
>>   static int acpi_processor_remove(struct acpi_device *device, int type)
>>   {
>>   	struct acpi_processor *pr = NULL;
>> -
>> +	int ret;
>>
>>   	if (!device || !acpi_driver_data(device))
>>   		return -EINVAL;
>> @@ -621,8 +621,9 @@ static int acpi_processor_remove(struct
>>   		goto free;
>>
>>   	if (type == ACPI_BUS_REMOVAL_EJECT) {
>> -		if (acpi_processor_handle_eject(pr))
>> -			return -EINVAL;
>> +		ret = acpi_processor_handle_eject(pr);
>> +		if (ret)
>> +			return ret;
>>   	}
>>
>>   	acpi_processor_power_exit(pr, device);
>> @@ -841,12 +842,17 @@ static acpi_status acpi_processor_hotadd
>>
>>   static int acpi_processor_handle_eject(struct acpi_processor *pr)
>>   {
>> -	if (cpu_online(pr->id))
>> -		cpu_down(pr->id);
>> +	int ret;
>> +
>> +	if (cpu_online(pr->id)) {
>> +		ret = cpu_down(pr->id);
>> +		if (ret)
>> +			return ret;
>> +	}
>>
> 
> Strictly speaking, this is not thorough enough. What prevents someone
> from onlining that same cpu again, at this point?
> So, IMHO, you need to wrap the contents of this function inside a
> get_online_cpus()/put_online_cpus() block, to prevent anyone else
> from messing with CPU hotplug at the same time.

If I understand your comment by mistake, please let me know.
If the contents is wrapped a inside get_online_cpus()/put_online_cpus() block
as below, cpu_down() will stop since cpu_down() calls cpu_hotplug_begin() and
cpu_hotplug_begin() waits for cpu_hotplug.refcount to become 0.

+	get_online_cpus()
+	if (cpu_online(pr->id)) {
+		ret = cpu_down(pr->id);
+		if (ret)
+			return ret;
+	}
+	put_online_cpus()

I think following patch can prevent it correctly. How about the patch?

---
 drivers/acpi/processor_driver.c |   12 ++++++++++++
 kernel/cpu.c                    |    8 +++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

Index: linux-3.5-rc4/drivers/acpi/processor_driver.c
===================================================================
--- linux-3.5-rc4.orig/drivers/acpi/processor_driver.c	2012-07-09 09:59:01.280211202 +0900
+++ linux-3.5-rc4/drivers/acpi/processor_driver.c	2012-07-09 11:05:34.559859236 +0900
@@ -844,14 +844,26 @@ static int acpi_processor_handle_eject(s
 {
 	int ret;

+retry:
 	if (cpu_online(pr->id)) {
 		ret = cpu_down(pr->id);
 		if (ret)
 			return ret;
 	}

+	get_online_cpus();
+	/*
+	 * Someone might online the cpu again at this point. So we check that
+	 * cpu has been onlined or not. If cpu is online, we try to offline
+	 * the cpu again.
+	 */
+	if (cpu_online(pr->id)) {
+		put_online_cpus();
+		goto retry;
+	}
 	arch_unregister_cpu(pr->id);
 	acpi_unmap_lsapic(pr->id);
+	put_online_cpus();
 	return ret;
 }
 #else
Index: linux-3.5-rc4/kernel/cpu.c
===================================================================
--- linux-3.5-rc4.orig/kernel/cpu.c	2012-07-09 09:59:01.280211202 +0900
+++ linux-3.5-rc4/kernel/cpu.c	2012-07-09 09:59:02.903190965 +0900
@@ -343,11 +343,13 @@ static int __cpuinit _cpu_up(unsigned in
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct task_struct *idle;

-	if (cpu_online(cpu) || !cpu_present(cpu))
-		return -EINVAL;
-
 	cpu_hotplug_begin();

+	if (cpu_online(cpu) || !cpu_present(cpu)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	idle = idle_thread_get(cpu);
 	if (IS_ERR(idle)) {
 		ret = PTR_ERR(idle);

