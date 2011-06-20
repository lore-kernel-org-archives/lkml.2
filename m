Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab1FTEsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 00:48:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45902 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1FTEsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 00:48:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFED0A4.1060002@jp.fujitsu.com>
Date: Mon, 20 Jun 2011 13:46:28 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 1/8] x86, mce: stop calling del_timer_sync() from interrupt
References: <4DFB1242.90404@jp.fujitsu.com> <4DFB1304.10604@jp.fujitsu.com> <20110617135634.GF18054@aftab>
In-Reply-To: <20110617135634.GF18054@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/17 22:56), Borislav Petkov wrote:
> On Fri, Jun 17, 2011 at 04:40:36AM -0400, Hidetoshi Seto wrote:
>> Function del_timer_sync() has WARN_ON(in_irq()) in it because
>> calling it from interrupt context can cause deadlock if it
>> interrupts the target timer running.
> 
> No need to explain the del_timer_sync() code here - just say that it's
> not allowed to call it from an IRQ context.
> 

I'd like to add "why not allowed" in brief too...
Anyway I'll update the patch description and make it short.

>> only few MCE geeks experience this warning on write.
> 
> MCE geeks ??? I wonder who those are :-)

I'm just joking ;-)

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
> 
> You're adding the mce_available(..) check just to remove it in the next
> patch. Since all those sysfs nodes are behind such a check, there's no
> need for it here too.

Maybe it would be better to change the order of patches to make
this fix after the removal of unnecessary mce_available().


Thanks,
H.Seto


