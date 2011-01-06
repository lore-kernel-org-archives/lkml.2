Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1AFQIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:08:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37517 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1AFQIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:08:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fIy9z4QvXQywKXzZ/iBqf61uF0dhrlm+LCtgrD6NG33FH8BhEcwoDvQlfMPo4F9zGM
         UFKbueos35OlWjg41AabzE/ImWiDOT4+oXdPtPTFOCtn8vEZAegYJne+EKb6MrDH6Roc
         t4XD03rARU+xCS/xqAG26Ds0OX4CbVbKZ7nuU=
Date: Thu, 6 Jan 2011 17:07:52 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110106160752.GA2775@riccoc20.at.omicron.at>
References: <1294199462.347935.472473715866.0.gpush@pororo>
 <1294199462.348449.192344022926.1.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294199462.348449.192344022926.1.gpush@pororo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 11:51:02AM +0800, Jeremy Kerr wrote:

> + * The @lock member provides either a spinlock or a mutex to protect (at least)
> + * @enable_count. The type of lock used will depend on @flags; if CLK_ATOMIC is
> + * set, then the core clock code will use a spinlock, otherwise a mutex. This
> + * lock will be acquired during clk_enable and clk_disable, so for atomic
> + * clocks, these ops callbacks must not sleep.
> + *
> + * The choice of atomic or non-atomic clock depends on how the clock is enabled.
> + * Typically, you'll want to use a non-atomic clock. For clocks that need to be
> + * enabled/disabled in interrupt context, use CLK_ATOMIC. Note that atomic
> + * clocks with parents will typically cascade enable/disable operations to
> + * their parent, so the parent of an atomic clock *must* be atomic too.

...

> +struct clk {
> +	const struct clk_ops	*ops;
> +	unsigned int		enable_count;
> +	int			flags;
> +	union {
> +		struct mutex	mutex;
> +		spinlock_t	spinlock;
> +	} lock;
> +};

Here you have a "polymorphic" lock, where the clock instance knows
which type it is supposed to be.  I got flak from David Miller and
others trying to do the same thing with the mdio_bus:

   http://kerneltrap.org/mailarchive/linux-netdev/2010/7/6/6280618

The criticism, applied to your case, is that the clk_enable() caller
cannot know whether it is safe to make the call or not. I was told,
"there has got to be a better way."

Richard

