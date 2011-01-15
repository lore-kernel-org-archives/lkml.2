Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1AOQUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 11:20:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46413 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab1AOQUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 11:20:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EELrpTDNV3+LXXb+aI0rNUMx42ogWRBhupPcK5LsQvWeOVg6bLPb7oW6ZTytZ3FNPD
         AVuZbGzc+HHuqGUkGz9Y+whSgwEs9KATJ8Hke6+HbGeRS58WCWmgEx1RfO9mxk/Eg4ma
         d7EDhYYa0+3N9QdEYSxEMdS/xKbd1cL9/tOmo=
Date: Sat, 15 Jan 2011 10:20:27 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Stone <jwjstone@fastmail.fm>, Viresh Kumar <viresh.kumar@st.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH resend] fs/eventpoll.c: fix compilation warning
Message-ID: <20110115162027.GA2552@lintop>
References: <1295005953-12173-1-git-send-email-viresh.kumar@st.com>
 <4D304A84.1000601@fastmail.fm>
 <AANLkTikQwgzTZrTVQ_kfxwNdT-_8Ly5FjCxiXB2gxj3W@mail.gmail.com>
 <20110114160508.41105533.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114160508.41105533.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 04:05:08PM -0800, Andrew Morton wrote:
> I've looked at this warning several times - the code is non-buggy and
> it's a bit sad to add extra instructions unnecessarily.  It would be
> better to make this warning go away by cleaning up or restructuring the
> code.  

I agree there really isn't a bug here and thus we don't _need_ to
initialize 'slack', but that depends on the current implementation of
schedule_hrtimeout_range() not using 'slack' when 'to' is NULL.  I
can't imagine that changing anytime soon, but that does seem like it
may be a bad assumption.

Furthermore, I've looked at the code pretty hard and I don't see a way
to simply restructure and make the warning go away.

> And the code _is_ pretty stupid.  If timed_out is set to 1 then the
> function does a great pile of useless junk.  I had a quick tinkle, made
> things worse and gave up:

Ah, I think you may have misunderstood.  The warning that 'slack' may
be used uninitialized occurs when a negative timeout is provided, not
when timeout==0.

> --- a/fs/eventpoll.c~a
> +++ a/fs/eventpoll.c
> @@ -1124,16 +1124,20 @@ static int ep_poll(struct eventpoll *ep,
>  	struct timespec end_time;
>  	ktime_t expires, *to = NULL;
>  
> -	if (timeout > 0) {
> -		ktime_get_ts(&end_time);
> -		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
> -		slack = select_estimate_accuracy(&end_time);
> -		to = &expires;
> -		*to = timespec_to_ktime(end_time);
> -	} else if (timeout == 0) {
> -		timed_out = 1;
> +	if (timeout == 0) {
> +		/*
> +		 * explanation of what timeout==0 means goes here
> +		 */
> +		spin_lock_irqsave(&ep->lock, flags);
> +		goto skip;
>  	}
>  
> +	ktime_get_ts(&end_time);
> +	timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
> +	slack = select_estimate_accuracy(&end_time);
> +	to = &expires;
> +	*to = timespec_to_ktime(end_time);
> +
>  retry:
>  	spin_lock_irqsave(&ep->lock, flags);
>  
> @@ -1149,9 +1153,10 @@ retry:
>  
>  		for (;;) {
>  			/*
> -			 * We don't want to sleep if the ep_poll_callback() sends us
> -			 * a wakeup in between. That's why we set the task state
> -			 * to TASK_INTERRUPTIBLE before doing the checks.
> +			 * We don't want to sleep if the ep_poll_callback()
> +			 * sends us a wakeup in between. That's why we set the
> +			 * task state to TASK_INTERRUPTIBLE before doing the
> +			 * checks.
>  			 */
>  			set_current_state(TASK_INTERRUPTIBLE);
>  			if (!list_empty(&ep->rdllist) || timed_out)
> @@ -1171,6 +1176,7 @@ retry:
>  
>  		set_current_state(TASK_RUNNING);
>  	}
> +skip:
>  	/* Is it worth to try to dig for events ? */
>  	eavail = !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
>  
> _
> 
> 
> but you get the idea ;)
> 
> I think the attempt to munge the "timeout==0" spacial case into the
> main body of the polling loop was a mistake, and that the code would be
> better/cleaner if that special case was handled quite separately.

I agree that the timeout==0 case could be optimized here.  I've got a
patch set that I'm currently testing to do just that.  I'll send it
out shortly.

--
Shawn
