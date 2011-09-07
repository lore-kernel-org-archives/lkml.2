Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab1IGUW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:22:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1IGUW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:22:26 -0400
Message-ID: <4E67D276.2060809@canonical.com>
Date: Wed, 07 Sep 2011 13:22:14 -0700
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: stefano.stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: disable PV spinlocks on HVM
References: <1315327307-392-1-git-send-email-stefano.stabellini@eu.citrix.com> <20110906170255.GA29839@dumpdata.com>
In-Reply-To: <20110906170255.GA29839@dumpdata.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.09.2011 10:02, Konrad Rzeszutek Wilk wrote:
> On Tue, Sep 06, 2011 at 05:41:47PM +0100, stefano.stabellini@eu.citrix.com wrote:
>> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>
>> PV spinlocks cannot possibly work with the current code because they are
>> enabled after pvops patching has already been done, and because PV
>> spinlocks use a different data structure than native spinlocks so we
>> cannot switch between them dynamically. A spinlock that has been taken
>> once by the native code (__ticket_spin_lock) cannot be taken by
>> __xen_spin_lock even after it has been released.
> 
> Let me stick it on my 3.1-rc5 bug-fix list and add stable@kernel.org to it.
> 
> Stefan, if you have some time this week, and can test it - I can also
> stick 'Tested-by' if you would like.
> 
> Thinking to send the patches on Friday.
> 
>>
>> Reported-by: Stefan Bader <stefan.bader@canonical.com>
>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> ---
>>  arch/x86/xen/smp.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
>> index e79dbb9..51339b4 100644
>> --- a/arch/x86/xen/smp.c
>> +++ b/arch/x86/xen/smp.c
>> @@ -522,7 +522,6 @@ static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
>>  	WARN_ON(xen_smp_intr_init(0));
>>  
>>  	xen_init_lock_cpu(0);
>> -	xen_init_spinlocks();
>>  }
>>  
>>  static int __cpuinit xen_hvm_cpu_up(unsigned int cpu)
>> -- 
>> 1.7.2.3
>>
>>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xensource.com
>> http://lists.xensource.com/xen-devel

Ok, tried with a kernel that only disables the init call and it does work the same.

That said, something still is not completely right with the NIC device
interrupts. Setup looks good and pings work. But doing any larger trnasfers
seems to loose interrupts, resulting in tx queue being full and getting timeouts...

-Stefan
