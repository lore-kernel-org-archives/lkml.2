Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab1EQVmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:42:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56867 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab1EQVmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xw8wxO3K1AGw629yCJfKWCvkPTU8u+Hqyiy/bW60rHM/6UghD8d6mm6FR65V7SDKpJ
         N195q07XacuHgSOzfK5BwahFrI36bma+0+e+Sl4/CsvG1//0oe09+kLPX7C6szwZiLBe
         URXGmNKKkYwfxag5pMCQ8vWiuyf13JzRaWG0A=
Message-ID: <4DD2EBAB.5080004@gmail.com>
Date: Tue, 17 May 2011 23:42:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
References: <1305665263-20933-1-git-send-email-john.stultz@linaro.org> <1305665263-20933-3-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1305665263-20933-3-git-send-email-john.stultz@linaro.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 10:47 PM, John Stultz wrote:
> Accessing task->comm requires proper locking. However in the past
> access to current->comm could be done without locking. This
> is no longer the case, so all comm access needs to be done
> while holding the comm_lock.
> 
> In my attempt to clean up unprotected comm access, I've noticed
> most comm access is done for printk output. To simplify correct
> locking in these cases, I've introduced a new %ptc format,
> which will print the corresponding task's comm.
> 
> Example use:
> printk("%ptc: unaligned epc - sending SIGBUS.\n", current);
> 
> CC: Joe Perches <joe@perches.com>
> CC: Michal Nazarewicz <mina86@mina86.com>
> CC: Andy Whitcroft <apw@canonical.com>
> CC: Jiri Slaby <jirislaby@gmail.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: David Rientjes <rientjes@google.com>
> CC: Dave Hansen <dave@linux.vnet.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-mm@kvack.org
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  lib/vsprintf.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index bc0ac6b..b7a9953 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -797,6 +797,23 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
>  	return string(buf, end, uuid, spec);
>  }
>  
> +static noinline_for_stack

I still fail to see why this should be slowed down by noinlining it.
Care to explain?

With my setup, the code below inlined will use 32 bytes of stack. The
same as %pK case. Uninlined it obviously eats "only" 8 bytes for IP.

> +char *task_comm_string(char *buf, char *end, void *addr,
> +			 struct printf_spec spec, const char *fmt)
> +{
> +	struct task_struct *tsk = addr;
> +	char *ret;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tsk->comm_lock, flags);
> +	ret = string(buf, end, tsk->comm, spec);
> +	spin_unlock_irqrestore(&tsk->comm_lock, flags);
> +
> +	return ret;
> +}

thanks,
-- 
js
