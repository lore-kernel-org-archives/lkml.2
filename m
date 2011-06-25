Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab1FYLnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 07:43:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59280 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab1FYLng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 07:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qLivveF+SaqGm0wWTjxs+LhZYGwHDVpAioey6QtsJDd0cj95UDcpM9cv4tT5z1Ufgn
         X5/1XQ4LnlNcoNjKJn0V1IOD/7eXIUuW80rLJeGK0xoPwp3tVRnT/l1YzryAf0oJuBXx
         fsCzbRY/+9rBqIT4pu3zFTozz5v11EqjDS3H8=
Date: Sat, 25 Jun 2011 13:43:31 +0200
From: Tejun Heo <tj@kernel.org>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org
Subject: Re: [RFC 1/1] workqueue: Add mod_delayed_work()
Message-ID: <20110625114331.GT30101@htj.dyndns.org>
References: <1308954457-21487-1-git-send-email-padovan@profusion.mobi>
 <1308954457-21487-2-git-send-email-padovan@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308954457-21487-2-git-send-email-padovan@profusion.mobi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jun 24, 2011 at 07:27:37PM -0300, Gustavo F. Padovan wrote:
> mod_delayed_work() updates a timer if the work is pending otherwise calls
> queue_delayed_work_on() to queue the work with the specified delay.
> 
> Call cancel_delayed_work_sync() and then queue_delayed_work() again to
> change a timer's delays is too expensive (and requires process context).
> Istead we call mod_delayed_work() to only modify the timer's timeout.

Yes, this part of the interface is lacking.  It might be best to
modify queue_delayed_work() to adjust the timer according to the new
timeout but we would need to audit the current users to make sure
nothing breaks and I agree introducing a new function probably makes
sense.

> +int mod_delayed_work(struct workqueue_struct *wq,
> +			struct delayed_work *dwork, unsigned long delay)
> +{
> +	struct timer_list *timer = &dwork->timer;
> +	struct work_struct *work = &dwork->work;
> +
> +	if (!test_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
> +		return queue_delayed_work_on(-1, wq, dwork, delay);
> +
> +	BUG_ON(!timer_pending(timer));
> +
> +	mod_timer(timer, jiffies + delay);
> +
> +	return 0;
> +}

But I think the current implementation is as it is because modifying
delayed work safely wasn't very simple.  The above code is broken in
multiple ways - a delayed work could be pending without timer pending,
and timer may expire after test_bit() but before the rest of the code.

I haven't thought about it too hard but think it would require the
timer sync part of __cancel_work_timer() (sans wait_on_work()) to get
it correctly.  Care to delve into it?

Thanks.

-- 
tejun
