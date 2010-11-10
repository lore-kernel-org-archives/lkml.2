Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0KJSNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:13:30 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26552 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab0KJSN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:13:29 -0500
Message-ID: <4CDAE069.4040007@oracle.com>
Date: Wed, 10 Nov 2010 10:11:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Steffen Klassert <steffen.klassert@secunet.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: Linux 2.6.37-rc1 (pcrypt fault)
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com> <20101103141519.0a6f5906.randy.dunlap@oracle.com> <20101110112143.GB1868@secunet.com>
In-Reply-To: <20101110112143.GB1868@secunet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/10 03:21, Steffen Klassert wrote:
> On Wed, Nov 03, 2010 at 02:15:19PM -0700, Randy Dunlap wrote:
>>
>> modprobe pcrypt; rmmod pcrypt ==>
>>
>>
>> [   76.081639] calling  pcrypt_init+0x0/0x107 [pcrypt] @ 3016
>> Nov  3 13:02:15 control kernel: [   76.089883] initcall pcrypt_init+0x0/0x107 [pcrypt] returned 0 after 2476 usecs
>> [   76.081639] calling  pcrypt_i
>>
>>
>> [   79.940445] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> 
> Looks like a use after free of the padata instance.
> Does the patch below fix it?

Yes, it does.  Thanks.

Tested-by: Randy Dunlap <randy.dunlap@oracle.com>


> Thanks for reporting,
> 
> Steffen
> 
> 
> Subject: [PATCH] crypto: pcrypt - Fix use after free on padata_free
> 
> kobject_put is called from padata_free for the padata kobject.
> The kobject's release function frees the padata instance,
> so don't call kobject_put for the padata kobject from pcrypt.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>  crypto/pcrypt.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> index de30782..75586f1 100644
> --- a/crypto/pcrypt.c
> +++ b/crypto/pcrypt.c
> @@ -504,7 +504,6 @@ err:
>  
>  static void pcrypt_fini_padata(struct padata_pcrypt *pcrypt)
>  {
> -	kobject_put(&pcrypt->pinst->kobj);
>  	free_cpumask_var(pcrypt->cb_cpumask->mask);
>  	kfree(pcrypt->cb_cpumask);
>  


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
