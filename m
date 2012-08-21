Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab2HUUjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:39:43 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:60728 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab2HUUjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:39:39 -0400
X-IronPort-AV: E=Sophos;i="4.77,804,1336348800"; 
   d="scan'208";a="14113832"
Message-ID: <5033EEE9.70806@citrix.com>
Date: Tue, 21 Aug 2012 21:26:17 +0100
From: Attilio Rao <attilio.rao@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 3/5] X86/XEN: Introduce the x86_init.paging.pagetable_init
 PVOPS
References: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com> <1345511646-12427-4-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208211722560.2856@ionos>
In-Reply-To: <alpine.LFD.2.02.1208211722560.2856@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/08/12 16:44, Thomas Gleixner wrote:
> On Tue, 21 Aug 2012, Attilio Rao wrote:
>
>    
>> This new PVOPS is responsible to setup the kernel pagetables and
>> replace entirely x86_init.paging.pagetable_setup_start and
>> x86_init.paging.pagetable_setup_done PVOPS work.
>>      
>
>    
>> For performance the x86_64 stub is implemented as a macro to paging_init()
>> rather than an actual function stub.
>>      
> Huch, using a macro for an once per boot time call is really a massive
> performance improvement.
>
> It's confusing and wrong. You just use a macro because x86_64 does not
> need any extra setups aside of paging_init().
>
>    
>> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
>> index 849be14..c1e910a 100644
>> --- a/arch/x86/kernel/x86_init.c
>> +++ b/arch/x86/kernel/x86_init.c
>> @@ -68,6 +68,7 @@ struct x86_init_ops x86_init __initdata = {
>>   	},
>>
>>   	.paging = {
>> +		.pagetable_init		= native_pagetable_init,
>>      
> I'd prefer to see these patches implemented differently.
>
>   #1 Remove the base argument from pagetable_setup_start (leave
>      pagetable_setup_done() alone).
>
>   #2 Rename pagetable_setup_start to pagetable_init,
>      native_pagetable_setup_start to native_pagetable_init and
>      xen_pagetable_setup_start to xen_pagetable_init
>
>   #3 Instead of copying the whole native_pagetable_setup_start()
>      function and deleting it later, move the paging_init() call from
>      setup.c to native_pagetable_init() and xen_pagetable_init()
>      and define native_pagetable_init as paging_init() for x86_64
>
>   #4 Move the code from xen_pagetable_setup_done() into
>      xen_pagetable_init() and remove the now unused
>      pagetable_setup_done().
>
> That's less code shuffling and pointless copying which makes the
> review way easier.
>    

I've followed these steps in a new patch series (integrating suggestions 
from Konrad and Stefano too).

Attilio
