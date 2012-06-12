Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2FLTpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:45:35 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:10108 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2FLTpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:45:34 -0400
Message-ID: <4FD79C59.80205@hp.com>
Date: Tue, 12 Jun 2012 13:45:29 -0600
From: Thavatchai Makphaibulcboke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lasse Collin <lasse.collin@tukaani.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kaloz@openwrt.org" <kaloz@openwrt.org>,
        "jj@chaosbits.net" <jj@chaosbits.net>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
 functions
References: <1339470307-28223-1-git-send-email-tmac@hp.com>  <20120612191804.4211462a@tukaani.org>  <alpine.LFD.2.02.1206121316190.23555@xanadu.home>  <4FD77CAF.1020402@zytor.com> <1339522812.2404.4.camel@joe2Laptop>
In-Reply-To: <1339522812.2404.4.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 11:40 AM, Joe Perches wrote:
> On Tue, 2012-06-12 at 10:30 -0700, H. Peter Anvin wrote:
>> On 06/12/2012 10:26 AM, Nicolas Pitre wrote:
>>>
>>> Instead of copying, maybe this would be much better to make the content 
>>> of lib/string.c usable in a pre-boot environment.
> 
>> Not sure about that... a lot of it is #ifndef __HAVE_ARCH_* and you
>> *really* want those optimizations on some arches.
> 
> Can __weak be used?
> 

lib/string.c contains a lot of stuff that are not needed in preboot, and
would increase the kernel image size.  I'm not sure if we will be able
to make it usable in pre-boot and only bringing in what is needed by
preboot, withtut unnecessarily complicated lib/string.c.

Thanks Joe for the suggestion.  I guess we could remove the #ifndef by
renaming all arch specific mem helper functions to arch_<name>, and
declaring them with a weak attribute in mem.c and let the mem.c check to
see if it is provided, Here is an example for memcpy

Architecture specific,

void *arch_memcpy(void *__dest, __const void *__src, size_t __n)
{
...
}


lib/mem.c

extern void *arch_memcpy(void *__dest, __const void *__src, size_t __n)
__attribute __((weak));

void *memcpy(void *__dest, __const void *__src, size_t __n)
{
        if (arch_memcpy) {
		arch_memcpgoogly();
		return;	
	}

}

But this does not solve the memmove issue. Could we always trust
arch_memcpy in all architectures?  I guess the safest way would be to
use memmove in string.c.  Please let me know if you have any thoughts or
suggestions.

Thanks,
Mak.

.
