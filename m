Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2JZJ0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:26:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48018 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab2JZJ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:26:19 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <508A5716.1090509@jp.fujitsu.com>
Date: Fri, 26 Oct 2012 18:25:42 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <srivatsa.bhat@linux.vnet.ibm.com>, <toshi.kani@hp.com>, <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] acpi : cpu hot-remove returns error when cpu_down()
 fails
References: <50657D92.3010106@jp.fujitsu.com> <4180255.BSUqs0l2F5@vostro.rjw.lan> <5080D9AA.8070801@jp.fujitsu.com>
In-Reply-To: <5080D9AA.8070801@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v1 -> v2
- update Rafael's comment.

>>   static int acpi_processor_handle_eject(struct acpi_processor *pr)
>>   {
>> -    if (cpu_online(pr->id))
>> -        cpu_down(pr->id);
>> +    int ret = 0;
>> +
>> +    if (cpu_online(pr->id)) {
>> +        ret = cpu_down(pr->id);
>
> If you defined ret here ...
>
>> +        if (ret)
>> +            return ret;
>> +    }
>>

>>       arch_unregister_cpu(pr->id);
>>       acpi_unmap_lsapic(pr->id);
>> -    return (0);
>> +    return ret;
>
> ... this line wouldn't need to be changed.

---
Even if cpu_down() fails, acpi_processor_remove() continues to remove the cpu.
But in this case, it should return error number since some process may run on
the cpu. If the cpu has a running process and the cpu is turned the power off,
the system may not work well.

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
  drivers/acpi/processor_driver.c |   16 +++++++++++-----
  1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux-3.7-rc2/drivers/acpi/processor_driver.c
===================================================================
--- linux-3.7-rc2.orig/drivers/acpi/processor_driver.c	2012-10-21 04:11:32.000000000 +0900
+++ linux-3.7-rc2/drivers/acpi/processor_driver.c	2012-10-26 18:15:43.721665836 +0900
@@ -605,7 +605,7 @@ err_free_pr:
  static int acpi_processor_remove(struct acpi_device *device, int type)
  {
  	struct acpi_processor *pr = NULL;
-
+	int ret;
  
  	if (!device || !acpi_driver_data(device))
  		return -EINVAL;
@@ -616,8 +616,9 @@ static int acpi_processor_remove(struct
  		goto free;
  
  	if (type == ACPI_BUS_REMOVAL_EJECT) {
-		if (acpi_processor_handle_eject(pr))
-			return -EINVAL;
+		ret = acpi_processor_handle_eject(pr);
+		if (ret)
+			return ret;
  	}
  
  	acpi_processor_power_exit(pr);
@@ -848,8 +849,13 @@ static acpi_status acpi_processor_hotadd
  
  static int acpi_processor_handle_eject(struct acpi_processor *pr)
  {
-	if (cpu_online(pr->id))
-		cpu_down(pr->id);
+	int ret = 0;
+
+	if (cpu_online(pr->id)) {
+		ret = cpu_down(pr->id);
+		if (ret)
+			return ret;
+	}
  
  	arch_unregister_cpu(pr->id);
  	acpi_unmap_lsapic(pr->id);

