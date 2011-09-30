Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab1I3Qe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 12:34:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57291 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab1I3Qe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 12:34:58 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=TSkoyBCu-xgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=tHz9FfFoAAAA:8 a=VwQbUJbxAAAA:8 a=Tty9oNO6AAAA:8 a=Z4Rwk6OoAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=zRWl2KqV2Ao-tY-EPN4A:9 a=ShD7TrALJDx9YB01x50A:7 a=PUjeQqilurYA:10 a=6O0IECtVFhoA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Q0Ba_xcqx-hsvtR_:21 a=74EcuGW53DtVH49J:21 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH RFC] stop_machine: make stop_machine safe and efficient
 to call early
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 30 Sep 2011 12:34:54 -0400
In-Reply-To: <4E85EE1F.7050508@goop.org>
References: <4E85EE1F.7050508@goop.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317400496.4588.54.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 09:28 -0700, Jeremy Fitzhardinge wrote:
> Make stop_machine() safe to call early in boot, before SMP has been
> set up, by simply calling the callback function directly if there's
> only one CPU online.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index ba5070c..2df15ca 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -485,6 +485,9 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
>  					    .num_threads = num_online_cpus(),
>  					    .active_cpus = cpus };
>  
> +	if (smdata.num_threads == 1)
> +		return (*fn)(data);

Doesn't interrupts need to be disabled here too? As stop machine
functions also guarantee that they will not be interrupted by
interrupts.

-- Steve

> +
>  	/* Set the initial state and stop all online cpus. */
>  	set_state(&smdata, STOPMACHINE_PREPARE);
>  	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
> 


