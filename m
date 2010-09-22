Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0IVQ1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:27:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42708 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0IVQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NG670jDK39yP4hgQF0PkN8RnkO8DVEjBTXK73CTL+tD2nynRimrFDnWNBAeeWgLaQL
         JFJdkgt7swLEvNkVZQOHNbrdKLSLi+qKYWB3QosiDhpkYKxOSY0bSk/J3W57wWPijYmg
         4dFJz8FuDx218DM5KpCNVaiT1exXGcZhXGZi8=
Date: Wed, 22 Sep 2010 18:27:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] avoid second smp_processor_id() call in
	__touch_watchdog
Message-ID: <20100922162730.GC5302@nowhere>
References: <20100813102158.GA5434@swordfish.minsk.epam.com> <20100818123346.02028e96.akpm@linux-foundation.org> <20100922090012.GA5459@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922090012.GA5459@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 12:00:12PM +0300, Sergey Senozhatsky wrote:
> Hello,
> 
> Per our previous conversation:
> 
> Andrew Morton wrote:
> > Fair enough, although strictly speaking this should be done in a
> > separate and later patch.
> > 
> 
> 
> Avoid double smp_processor_id() call in __touch_watchdog (smp_processor_id() 
> itself and later call in __get_cpu_var())
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 7f9c3c5..03d97c5 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -116,8 +116,7 @@ static unsigned long get_sample_period(void)
>  static void __touch_watchdog(void)
>  {
>  	int this_cpu = smp_processor_id();
> -
> -	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
> +	per_cpu(watchdog_touch_ts, this_cpu) = get_timestamp(this_cpu);



I'm not sure we want this. This is called by the watchdog internally,
from the timer or the cpu bound thread, so we probably should better
keep __get_cpu_var() because it checks that we are not in a preemptable
section.

Most of the time, accessing local data using per_cpu instead
of __get_cpu_var is wrong.

