Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab1FCVIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:08:11 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:17186 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab1FCVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:08:07 -0400
Message-ID: <4DE94D31.3040104@caviumnetworks.com>
Date: Fri, 03 Jun 2011 14:08:01 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Sameer Nanda <snanda@chromium.org>
CC: Andrew Morton <akpm@linux-foundation.org>, ext-phil.2.carmody@nokia.com,
        Tim.Deegan@citrix.com, jbeulich@novell.com, snanda@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: skip calibration delay if previously done
References: <1306279146-23487-1-git-send-email-snanda@chromium.org> <20110603140054.a0f1859d.akpm@linux-foundation.org>
In-Reply-To: <20110603140054.a0f1859d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2011 21:08:06.0557 (UTC) FILETIME=[5587BCD0:01CC2232]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2011 02:00 PM, Andrew Morton wrote:
> On Tue, 24 May 2011 16:19:06 -0700
> Sameer Nanda<snanda@chromium.org>  wrote:
>
>> For each CPU, do the calibration delay only once. For subsequent calls,
>> use the cached per-CPU value of loops_per_jiffy.
>>
>> This saves about 200ms of resume time on dual core Intel Atom N5xx based
>> systems. This helps bring down the kernel resume time on such systems from
>> about 500ms to about 300ms.
>>
>> Signed-off-by: Sameer Nanda<snanda@chromium.org>
>> ---
>>   init/calibrate.c |   10 +++++++++-
>>   1 files changed, 9 insertions(+), 1 deletions(-)
>>
>> diff --git a/init/calibrate.c b/init/calibrate.c
>> index 76ac919..47d3408 100644
>> --- a/init/calibrate.c
>> +++ b/init/calibrate.c
>> @@ -183,11 +183,18 @@ recalibrate:
>>   	return lpj;
>>   }
>>
>> +DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
>> +
>>   void __cpuinit calibrate_delay(void)
>>   {
>>   	static bool printed;
>> +	int this_cpu = smp_processor_id();
>>
>> -	if (preset_lpj) {
>> +	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
>> +		loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
>> +		pr_info("Calibrating delay loop (skipped) "
>> +				"already calibrated this CPU previously.. ");

That wording seems a little redundant, and there are two '.' at the end.

How about:
s/"already calibrated this CPU previously.. "/", this CPU previously 
calibrated."/

David Daney
