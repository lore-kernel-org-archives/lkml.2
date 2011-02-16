Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1BPXKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:10:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20769 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab1BPXKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:10:04 -0500
Message-ID: <4D5C5909.4020405@kernel.org>
Date: Wed, 16 Feb 2011 15:08:57 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: exit early on numa_reset_distance()
References: <4D5C3A0F.3080107@kernel.org> <20110216223943.GA29600@atj.dyndns.org>
In-Reply-To: <20110216223943.GA29600@atj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D5C5937.012F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 02:39 PM, Tejun Heo wrote:
> On Wed, Feb 16, 2011 at 12:56:47PM -0800, Yinghai Lu wrote:
>>
>> Do not call __pa(numa_distance), if it is not allocated before.
>>
>> it will get BUG_ON if VIRTUAL_DEBUG is on.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Thanks for spotting this.
> 
>> Index: linux-2.6/arch/x86/mm/numa_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/numa_64.c
>> +++ linux-2.6/arch/x86/mm/numa_64.c
>> @@ -371,6 +371,12 @@ static void __init numa_reset_distance(v
>>  {
>>  	size_t size;
>>  
>> +	if (!numa_distance_cnt) {
>> +		numa_distance = NULL;
>> +
>> +		return;
>> +	}
>> +
> 
> But please move the existing numa_distance = NULL before the
> conditional and do if (!numa_distance_cnt) return;

confused. Do you mean this one ?

[PATCH -v2] x86, numa: exit early on numa_reset_distance()

Do not call __pa(numa_distance), if it is not allocated before.

it will get BUG_ON if VIRTUAL_DEBUG is on.

-v2: change to check existing path as tj requested.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa_64.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -371,11 +371,13 @@ static void __init numa_reset_distance(v
 {
 	size_t size;
 
-	size = numa_distance_cnt * sizeof(numa_distance[0]);
-	memblock_x86_free_range(__pa(numa_distance),
-				__pa(numa_distance) + size);
+	if (numa_distance_cnt) {
+		size = numa_distance_cnt * sizeof(numa_distance[0]);
+		memblock_x86_free_range(__pa(numa_distance),
+					__pa(numa_distance) + size);
+		numa_distance_cnt = 0;
+	}
 	numa_distance = NULL;
-	numa_distance_cnt = 0;
 }
 
 /*

