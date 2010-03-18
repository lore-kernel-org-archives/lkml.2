Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab0CRTu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:50:26 -0400
Received: from mail-px0-f198.google.com ([209.85.216.198]:52482 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0CRTuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OlXVzBmVBcJWTGw/oiCXIUYTvI9KWwFWEqMAlznrcRoN6z7Coh3i2j/fyBE4fIkbwU
         Y3+F1bBjns+Nn3bXoVMNzetSIraBdCctjH0qHkoUDGI5SQoVpkf+LIhp9IsC7SM4zwck
         6zBKUrDjq6ySdfMZE3MUEFboWR2PNtoBgIRn8=
Date: Thu, 18 Mar 2010 20:50:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sparc <sparclinux@vger.kernel.org>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] percpu misaligned allocation
Message-ID: <20100318195023.GE5103@nowhere>
References: <20100318044930.GC5045@nowhere> <4BA1F2BA.30604@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1F2BA.30604@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 06:30:34PM +0900, Tejun Heo wrote:
> Hello,
> 
> On 03/18/2010 01:49 PM, Frederic Weisbecker wrote:
> > Hi,
> > 
> > While using the lock events through perf in a sparc box, I can see
> > the following message repeated many times:
> > 
> > 	Kernel unaligned access at TPC[49357c] perf_trace_lock_acquire+0xb4/0x180
> > 
> > It actually hangs the box as the messages are sent to a serial console.
> > 
> > When used with perf, the trace events use a per cpu buffer allocated
> > in kernel/trace/trace_event_perf.c, and the allocation appears to return
> > a misaligned percpu pointer. It is aligned to 4 while it seems it
> > requires to be aligned to 8.
> 
> Does this fix the problem?
> 
> diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
> index c1cc3ab..d3f7d1b 100644
> --- a/kernel/trace/trace_event_profile.c
> +++ b/kernel/trace/trace_event_profile.c
> @@ -27,13 +27,15 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
>  		return 0;
>  
>  	if (!total_profile_count) {
> -		buf = (char *)alloc_percpu(perf_trace_t);
> +		buf = (char *)__alloc_percpu(sizeof(perf_trace_t),
> +					     __alignof__(unsigned long));
>  		if (!buf)
>  			goto fail_buf;
>  
>  		rcu_assign_pointer(perf_trace_buf, buf);
>  
> -		buf = (char *)alloc_percpu(perf_trace_t);
> +		buf = (char *)__alloc_percpu(sizeof(perf_trace_t),
> +					     __alignof__(unsigned long));
>  		if (!buf)
>  			goto fail_buf_nmi;


Yep, it does the trick.

In case you test, I have two other misalignments, one is in
perf_trace_buf_prepare but it is my bad and it is nothing
related to percpu. I'm going to fix it.
Another is in the ring buffer and Steve has a pending fix.

Thanks.

