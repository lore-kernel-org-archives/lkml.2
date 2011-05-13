Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab1EMLLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 07:11:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42353 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab1EMLLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 07:11:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DCD1256.4070808@jp.fujitsu.com>
Date: Fri, 13 May 2011 20:13:26 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock seqlock to protect task->comm
 access
References: <1305241371-25276-1-git-send-email-john.stultz@linaro.org> <1305241371-25276-2-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1305241371-25276-2-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for the long delay.

>   char *get_task_comm(char *buf, struct task_struct *tsk)
>   {
> -	/* buf must be at least sizeof(tsk->comm) in size */
> -	task_lock(tsk);
> -	strncpy(buf, tsk->comm, sizeof(tsk->comm));
> -	task_unlock(tsk);
> +	unsigned long seq;
> +
> +	do {
> +		seq = read_seqbegin(&tsk->comm_lock);
> +
> +		strncpy(buf, tsk->comm, sizeof(tsk->comm));
> +
> +	} while (read_seqretry(&tsk->comm_lock, seq));
> +
>   	return buf;
>   }

Can you please explain why we should use seqlock? That said,
we didn't use seqlock for /proc items. because, plenty seqlock
write may makes readers busy wait. Then, if we don't have another
protection, we give the local DoS attack way to attackers.

task->comm is used for very fundamentally. then, I doubt we can
assume write is enough rare. Why can't we use normal spinlock?


