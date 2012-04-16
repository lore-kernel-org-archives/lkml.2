Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2DPO7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:59:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:12815 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2DPO7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:59:47 -0400
X-IronPort-AV: E=Sophos;i="4.75,429,1330923600"; 
   d="scan'208";a="190522964"
Message-ID: <4F8C33E0.2080007@citrix.com>
Date: Mon, 16 Apr 2012 15:59:44 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Thomas Gleixner <tglx@linutronix.de>, xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tim (Xen.org)" <tim@xen.org>, Sheng Yang <sheng@yasker.org>
Subject: Re: [PATCH] xen: always set the sched clock as unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com> <4F8C1F6D020000780007E11A@nat28.tlf.novell.com>
In-Reply-To: <4F8C1F6D020000780007E11A@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/12 12:32, Jan Beulich wrote:
>>>> On 13.04.12 at 20:20, David Vrabel <david.vrabel@citrix.com> wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> The sched clock was considered stable based on the capabilities of the
>> underlying hardware.  This does not make sense for Xen PV guests as:
>> a) the hardware TSC is not used directly as the clock source; and b)
>> guests may migrate to hosts with different hardware capabilities.
>>
>> It is not clear to me whether the Xen clock source is supposed to be
>> stable and whether it should be stable across migration.  For a clock
>> source to be stable it must be: a) monotonic; c) synchronized across
>> CPUs; and c) constant rate.

Tim, Thomas, can you comment on the above paragraph?  Is it correct?

>> There have also been reports of systems with apparently unstable
>> clocks where clearing sched_clock_stable has fixed problems with
>> migrated VMs hanging.
>>
>> So, always set the sched clock as unstable when using the Xen clock
>> source.
>>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>> ---
>>  arch/x86/xen/time.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
>> index 0296a95..8469b5a 100644
>> --- a/arch/x86/xen/time.c
>> +++ b/arch/x86/xen/time.c
>> @@ -473,6 +473,7 @@ static void __init xen_time_init(void)
>>  	do_settimeofday(&tp);
>>  
>>  	setup_force_cpu_cap(X86_FEATURE_TSC);
>> +	sched_clock_stable = 0;
> 
> This, unfortunately, is not sufficient afaict: If a CPU gets brought up
> post-boot, the variable may need to be cleared again. Instead you
> ought to call mark_tsc_unstable().

Yeah, mark_tsc_unstable() is the right thing to do.

David
