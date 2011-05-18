Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab1ERCBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 22:01:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55753 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab1ERCBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 22:01:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD3287A.2030808@jp.fujitsu.com>
Date: Wed, 18 May 2011 11:01:30 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: john.stultz@linaro.org
CC: linux-kernel@vger.kernel.org, joe@perches.com, mingo@elte.hu,
        mina86@mina86.com, apw@canonical.com, jirislaby@gmail.com,
        rientjes@google.com, dave@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] comm: Introduce comm_lock spinlock to protect task->comm
 access
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org> <1305682865-27111-2-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1305682865-27111-2-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/fs/exec.c b/fs/exec.c
> index 5e62d26..34fa611 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -998,17 +998,28 @@ static void flush_old_files(struct files_struct * files)
> 
>   char *get_task_comm(char *buf, struct task_struct *tsk)
>   {
> -	/* buf must be at least sizeof(tsk->comm) in size */
> -	task_lock(tsk);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tsk->comm_lock, flags);
>   	strncpy(buf, tsk->comm, sizeof(tsk->comm));
> -	task_unlock(tsk);
> +	spin_unlock_irqrestore(&tsk->comm_lock, flags);
>   	return buf;
>   }
> 
>   void set_task_comm(struct task_struct *tsk, char *buf)
>   {
> +	unsigned long flags;
> +
> +	/*
> +	 * XXX - Even though comm is protected by comm_lock,
> +	 * we take the task_lock here to serialize against
> +	 * current users that directly access comm.
> +	 * Once those users are removed, we can drop the
> +	 * task locking&  memsetting.
> +	 */

If we provide __get_task_comm(), we can't remove memset() forever.


>   	task_lock(tsk);
> +	spin_lock_irqsave(&tsk->comm_lock, flags);

This is strange order. task_lock() doesn't disable interrupt.
And, can you please document why we need interrupt disabling?


>   	/*
>   	 * Threads may access current->comm without holding
>   	 * the task lock, so write the string carefully.


