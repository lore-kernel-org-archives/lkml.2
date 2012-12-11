Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2LKIHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:07:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:24620 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab2LKIHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:07:02 -0500
X-IronPort-AV: E=Sophos;i="4.84,258,1355068800"; 
   d="scan'208";a="6374362"
Message-ID: <50C6E927.9040605@cn.fujitsu.com>
Date: Tue, 11 Dec 2012 16:04:55 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Gleb Natapov <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH] x86/kexec: crash_vmclear_local_vmcss needs __rcu
References: <50C18168.305@cn.fujitsu.com> <20121210203014.GB2402@amt.cnet>
In-Reply-To: <20121210203014.GB2402@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/11 16:06:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/11 16:06:13
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月11日 04:30, Marcelo Tosatti 写道:
> On Fri, Dec 07, 2012 at 01:40:56PM +0800, Zhang Yanfei wrote:
>> This removes the sparse warning:
>> arch/x86/kernel/crash.c:49:32: sparse: incompatible types in comparison expression (different address spaces)
>>
>> Reported-by: kbuild test robot <fengguang.wu@intel.com>
>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> ---
>>  arch/x86/include/asm/kexec.h |    4 +++-
>>  arch/x86/kernel/crash.c      |    4 ++--
>>  2 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
>> index 28feeba..16882cd 100644
>> --- a/arch/x86/include/asm/kexec.h
>> +++ b/arch/x86/include/asm/kexec.h
>> @@ -163,7 +163,9 @@ struct kimage_arch {
>>  };
>>  #endif
>>  
>> -extern void (*crash_vmclear_loaded_vmcss)(void);
>> +extern void __rcu (*crash_vmclear_loaded_vmcss)(void);
>> +#define vmclear_func_rcu(vmclear_func) \
>> +	((void (*)(void)) rcu_dereference(vmclear_func))
>>  
>>  #endif /* __ASSEMBLY__ */
>>  
>> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
>> index 2f6b8e8..50ce1d6 100644
>> --- a/arch/x86/kernel/crash.c
>> +++ b/arch/x86/kernel/crash.c
>> @@ -38,7 +38,7 @@ int in_crash_kexec;
>>   *
>>   * protected by rcu.
>>   */
>> -void (*crash_vmclear_loaded_vmcss)(void) = NULL;
>> +void __rcu (*crash_vmclear_loaded_vmcss)(void) = NULL;
> 
> Isnt this (__rcu AS tag) sufficient? After all, sparse is complaining
> about namespaces.
> 
> Creating a #define to cast seems excessive.
> 
> 

I am not very familiar with the rcu.
Adding __rcu tag could solve the problem. But it imported another warning
when I try to assign rcu_dereference(crash_vmclear_loaded_vmcss) to
do_vmclear_operation:

arch/x86/kernel/crash.c:49:30: warning: incorrect type in assignment (different modifiers)
arch/x86/kernel/crash.c:49:30:    expected void ( *do_vmclear_operation )( ... )
arch/x86/kernel/crash.c:49:30:    got void ( [noderef] *<noident> )( ... )
arch/x86/kernel/crash.c:49:30: warning: incorrect type in assignment (different modifiers)
arch/x86/kernel/crash.c:49:30:    expected void ( *do_vmclear_operation )( ... )
arch/x86/kernel/crash.c:49:30:    got void ( [noderef] *<noident> )( ... )

So I made the #define to cast its type.

If you have any suggestion, that'll be helpful.

Thanks
Zhang Yanfei
