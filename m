Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab0JPPRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 11:17:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38752 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0JPPRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 11:17:54 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=nEQxJ46sMH0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=p_xzYSLjkpEMSUq1a8MA:9 a=vISfD-sDvw5_1qUcmbz-bcLQnNgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: ftrace does not work on cpus > 999.
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101016144529.GA5384@nowhere>
References: <20101016131505.GW14064@sgi.com> <20101016144529.GA5384@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 16 Oct 2010 11:17:52 -0400
Message-ID: <1287242272.16971.53.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-16 at 16:45 +0200, Frederic Weisbecker wrote:

> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 9ec59f5..3565f9e 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3999,7 +3999,7 @@ static void tracing_init_debugfs_percpu(long cpu)
>  	/* strlen(cpu) + MAX(log10(cpu)) + '\0' */
>  	char cpu_dir[7];
>  
> -	if (cpu > 999 || cpu < 0)
> +	if (cpu < 0)
>  		return;
>  
>  	sprintf(cpu_dir, "cpu%ld", cpu);

You need to change the size of cpu_dir, otherwise this will overflow.

The other case is to dynamically allocate cpu_dir.

	char *cpu_dir;
	int count = cpu;
	int size;

	if (cpu < 0)
		return;

	/* log10 sizeof cpu */
	for (size = 0; count > 0; count /= 10, size++)
		;

	cpu_dir = kmalloc(size + 4, GFP_KERNEL);

	if (!cpu_dir)
		return;

	snprintf(cpu_dir, size + 4, "cpu%ld", cpu);

	[...]

	kfree(cpu_dir);

-- Steve


