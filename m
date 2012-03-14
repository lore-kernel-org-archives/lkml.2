Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031088Ab2CNVqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:46:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030902Ab2CNVqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:46:02 -0400
Date: Wed, 14 Mar 2012 14:46:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [REGRESSION][PATCH] mqueue: Ignore the validity of abs_timeout
 parameter when message can be performed immediately
Message-Id: <20120314144601.ccc50a68.akpm@linux-foundation.org>
In-Reply-To: <20120302164234.4938.38390934@jp.panasonic.com>
References: <20120302164234.4938.38390934@jp.panasonic.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2012 16:42:35 +0900
Akira Takeuchi <takeuchi.akr@jp.panasonic.com> wrote:

> This patch fixes up the regression problem of mq_timed{send,receive} syscall.
> 
> When a message of mqueue can be performed immediately,
> the validity of abs_timeout parameter should not be checked.
> 
> According to the manpage of mq_timedreceive:
>     Under no circumstance shall the operation fail with a timeout
>     if a message can be removed from the message queue immediately.
>     The validity of the abstime parameter need not be checked
>     if a message can be removed from the message queue immediately.
> 
> On 2.6.35+ kernel, mq_timed{send,receive} returns EINVAL incorrectly,
> in this situation.
> 
> I found this problem during the OPTS testcase
> "conformance/interfaces/mq_timedreceive/10-2":
> 
>     # ./10-2.test
>     FAIL: the validity of abs_timeout is checked
>     Test FAILED

Are you able to identify the commit which caused this regression?  I'm
guessing

commit 9ca7d8e6834c40a99622bbe4a88aaf64313ae43c
Author:     Carsten Emde <C.Emde@osadl.org>
AuthorDate: Fri Apr 2 22:40:20 2010 +0200
Commit:     Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue Apr 6 21:50:03 2010 +0200

    mqueue: Convert message queue timeout to use hrtimers                       


> Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
> Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
> ---
>  ipc/mqueue.c |   31 +++++++++++++++++++++++++++----
>  1 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 86ee272..7cd4411 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -861,14 +861,22 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
>  	struct msg_msg *msg_ptr;
>  	struct mqueue_inode_info *info;
>  	ktime_t expires, *timeout = NULL;
> +	int timeout_param_error = 0;
>  	struct timespec ts;
>  	int ret;
>  
>  	if (u_abs_timeout) {
>  		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
>  		if (res)
> -			return res;
> -		timeout = &expires;
> +			/*
> +			 * The validity of the abs_timeout parameter need not be
> +			 * checked when there is sufficient room in the queue.
> +			 * So, do not return here, even if the parameter is
> +			 * invalid.
> +			 */
> +			timeout_param_error = res;
> +		else
> +			timeout = &expires;
>  	}
>  
>  	if (unlikely(msg_prio >= (unsigned long) MQ_PRIO_MAX))
> @@ -916,6 +924,9 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
>  		if (filp->f_flags & O_NONBLOCK) {
>  			spin_unlock(&info->lock);
>  			ret = -EAGAIN;
> +		} else if (unlikely(timeout_param_error)) {
> +			spin_unlock(&info->lock);
> +			ret = timeout_param_error;
>  		} else {
>  			wait.task = current;
>  			wait.msg = (void *) msg_ptr;
> @@ -955,13 +966,21 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
>  	struct mqueue_inode_info *info;
>  	struct ext_wait_queue wait;
>  	ktime_t expires, *timeout = NULL;
> +	int timeout_param_error = 0;
>  	struct timespec ts;
>  
>  	if (u_abs_timeout) {
>  		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
>  		if (res)
> -			return res;
> -		timeout = &expires;
> +			/*
> +			 * The validity of the abs_timeout parameter need not be
> +			 * checked if a message can be removed from the message
> +			 * queue immediately. So, do not return here, even if
> +			 * the parameter is invalid.
> +			 */
> +			timeout_param_error = res;
> +		else
> +			timeout = &expires;
>  	}
>  
>  	audit_mq_sendrecv(mqdes, msg_len, 0, timeout ? &ts : NULL);
> @@ -996,6 +1015,10 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
>  		if (filp->f_flags & O_NONBLOCK) {
>  			spin_unlock(&info->lock);
>  			ret = -EAGAIN;
> +		} else if (unlikely(timeout_param_error)) {
> +			spin_unlock(&info->lock);
> +			ret = timeout_param_error;
> +			msg_ptr = NULL; /* just for shutting up warning */
>  		} else {
>  			wait.task = current;
>  			wait.state = STATE_NONE;
> -- 
> 1.7.4.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
