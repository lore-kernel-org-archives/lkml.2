Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab1EPVya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:54:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51844 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab1EPVy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:54:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=h1wPQkhLVm/e7HZoTfFvXXEIJp7OtnoZKmrBxzrV1eF53FFLshazhTZAedj7BMtk10
         cFw+IA6CUSfcZ8gA494+8BFJv5sjRKKSu13kL48SygJiWy/Zr9fzCgQXAE2+loRvXQhr
         xYioMJ8rRK29MqlQR9+aqbAMKKIBA8iwgM2+s=
Message-ID: <4DD19D10.3000201@gmail.com>
Date: Mon, 16 May 2011 23:54:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org> <1305580757-13175-3-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1305580757-13175-3-git-send-email-john.stultz@linaro.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2011 11:19 PM, John Stultz wrote:
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
> CC: Ted Ts'o <tytso@mit.edu>
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

Actually, why noinline? Did your previous version have there some
TASK_COMM_LEN buffer or anything on stack which is not there anymore?

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
> +
> +
> +
>  int kptr_restrict = 1;
>  
>  /*

thanks,
-- 
js
