Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2JRXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:25:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41278 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab2JRXZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:25:54 -0400
Date: Thu, 18 Oct 2012 16:25:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: cancel_delayed_work() semantics broken?
Message-ID: <20121018232549.GX13370@google.com>
References: <444a6439-b1a4-4740-9e7e-bc37267cfe73@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <444a6439-b1a4-4740-9e7e-bc37267cfe73@default>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dan.

On Thu, Oct 18, 2012 at 04:00:03PM -0700, Dan Magenheimer wrote:
> Forgive me if I am missing something, but it appears
> that your commit:  57b30ae77bf00d2318df711ef9a4d2a9be0a3a2a
> (workqueue: reimplement cancel_delayed_work() using try_to_grab_pending())
> has subtly broken the semantics of the function. If
> work was idle, according to the comment, it should
> return false, correct?
> 
> It appears that very few callsites check the return value,
> but ramster does, as does ocfs2 from whence the code at the
> ramster callsite was derived.  They both decrement
> a kref count based on the return value.
> 
> I am still looking at try_to_grab_pending as I am not sure
> if its semantics have also changed.
> 
> Thanks,
> Dan
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index d951daa..042d221 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2982,7 +2982,7 @@ bool cancel_delayed_work(struct delayed_work *dwork)
>  
>  	set_work_cpu_and_clear_pending(&dwork->work, work_cpu(&dwork->work));
>  	local_irq_restore(flags);
> -	return true;
> +	return ret;

Ah, you're right.  Applying to wq/for-3.7-fixes w/ patch description
updated.  Thanks!

-- 
tejun
