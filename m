Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab1DYLw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:52:59 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59824 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758528Ab1DYLw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:52:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=suguA5KdDFLXiDlMvJwfCd/yLl0UmAo2BCbMqiPviWZEivj4aJ9F5AQqkatxvul1yR
         0e5Yimaw3sUOta4rGG/QAxw74MgtRAyhYbbNIU6OCsouxpQtZVnMdceOEQKTXPRdIqn0
         IA7eUh2RMUxcxfBv1aeRD8inu759IF7mfwF3w=
Date: Mon, 25 Apr 2011 13:52:53 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] signal: do_sigtimedwait() needs
 retarget_shared_pending()
Message-ID: <20110425115253.GP17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com>
 <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com>
 <20110423180000.GD484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110423180000.GD484@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Apr 23, 2011 at 08:00:00PM +0200, Oleg Nesterov wrote:
> do_sigtimedwait() changes current->blocked and thus it needs
> set_current_bloked()->retarget_shared_pending().
> 
> We could use set_current_bloked() directly. It is fine to change
> ->real_blocked from all-zeroes to ->blocked and vice versa lockless,
> but this is not immediately clear, looks racy, and needs a huge
> comment to explain why this is correct.
> 
> To keep the things simple this patch adds the new static helper,
> __set_task_blocked() which should be called with ->siglock held. This
> way we can change both ->real_blocked and ->blocked atomically under
> ->siglock as the current code does. This is more understandable.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

> @@ -2322,7 +2327,8 @@ int do_sigtimedwait(sigset_t *these, sig
>  		/*
>  		 * None ready -- temporarily unblock those we're
>  		 * interested while we are sleeping in so that we'll
> -		 * be awakened when they arrive.
> +		 * be awakened when they arrive. Unblocking is always
> +		 * fine, we can avoid set_current_blocked().
>  		 */
>  		tsk->real_blocked = tsk->blocked;
>  		sigandsets(&tsk->blocked, &tsk->blocked, these);

Maybe it would be a good idea to introduce a new helper which checks /
enforces that the operation indeed is only unblocking?  Also, it can
be a pure preference but I think _locked suffix is better / more
common for APIs which expect the caller to be responsible for locking.

Thanks.

-- 
tejun
