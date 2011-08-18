Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab1HRNZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:25:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40771 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab1HRNZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:25:02 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=AuKrfTuNYe0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=XX2W5SojtypHe4WF3dcA:9 a=2xRl0xuGYysel83vv5QA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: how to handle tracing .h loops
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1313668662.5010.303.camel@zakaz.uk.xensource.com>
References: <1313668307.5010.300.camel@zakaz.uk.xensource.com>
	 <1313668662.5010.303.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Aug 2011 09:24:59 -0400
Message-ID: <1313673899.15704.66.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 12:57 +0100, Ian Campbell wrote:
> On Thu, 2011-08-18 at 12:51 +0100, Ian Campbell wrote:
> > Clearly other places are including interrupt.h and highmem.h without
> > issue so what am I doing wrong here?
> 
> I guess I should have look at the .c file instead of concentrating on
> the .h's because this works:
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 7b996ed..3f5ee74 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -29,6 +29,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/dmaengine.h>
>  #include <linux/hrtimer.h>
> +#include <linux/highmem.h>
>  
>  /* Don't change this without changing skb_csum_unnecessary! */
>  #define CHECKSUM_NONE 0
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 291c970..ff432ec 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -30,6 +30,7 @@
>  #include <linux/nsproxy.h>
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/signal.h>
> +#undef CREATE_TRACE_POINTS

I think the better solution is to move this down below the asms. But as
this does work, I'm don't have any big preference against it.

>  
>  #include <asm/param.h>
>  #include <asm/uaccess.h>
> 
> 
> But that seems odd (noone else does it). Perhaps I should instead move
> that include to last in the file? i.e.:
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 291c970..d3cd4e7 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -28,8 +28,6 @@
>  #include <linux/freezer.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/nsproxy.h>
> -#define CREATE_TRACE_POINTS
> -#include <trace/events/signal.h>
>  
>  #include <asm/param.h>
>  #include <asm/uaccess.h>
> @@ -37,6 +35,9 @@
>  #include <asm/siginfo.h>
>  #include "audit.h"	/* audit_signal_info() */
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/signal.h>
> +

Yes, the trace events headers are suppose to be the last headers
included.

Either method works. Either undefine CREATE_TRACE_POINTS or move the
headers down. Only the C file should be depending on the header anyway.

Thanks!

-- Steve

>  /*
>   * SLAB caches for signal bits.
>   */
> 
> Ian.


