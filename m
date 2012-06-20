Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab2FTJpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:45:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:55461 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab2FTJpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:45:40 -0400
Message-ID: <1340185528.21745.86.camel@twins>
Subject: RE: [PATCH] sched: Folding nohz load accounting more accurate
From: Peter Zijlstra <peterz@infradead.org>
To: Doug Smythies <dsmythies@telus.net>
Cc: "'Yong Zhang'" <yong.zhang0@gmail.com>,
        "'Charles Wang'" <muming.wq@gmail.com>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@redhat.com>, "'Tao Ma'" <tm@tao.ma>,
        =?UTF-8?Q?=27=E5=90=AB=E9=BB=9B=27?= <handai.szj@taobao.com>,
        "'Thomas Gleixner'" <tglx@linutronix.de>
Date: Wed, 20 Jun 2012 11:45:28 +0200
In-Reply-To: <000001cd4e33$496f6c30$dc4e4490$@net>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
		 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>
		 <1339494970.31548.66.camel@twins> <4FDB4642.5070509@gmail.com>
		 <1340035417.15222.95.camel@twins> <20120619060824.GA31684@zhy>
	 <1340097532.21745.19.camel@twins> <000001cd4e33$496f6c30$dc4e4490$@net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 08:50 -0700, Doug Smythies wrote:
> My automated 63 hour test has been terminated, the code changed
> and the test re-started. 

There's another boo-boo in there:


> @@ -2369,11 +2493,35 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
>   */
>  void calc_global_load(unsigned long ticks)
>  {
> -       long active;
> +       long active, delta;
>  
>         if (time_before(jiffies, calc_load_update + 10))
>                 return;
>  
> +       /*
> +        * Fold the 'old' idle-delta to include all NO_HZ cpus.
> +        *
> +        *      cpu0    cpu1    cpu2    ..
> +        *
> +        * >--- [sample A]
> +        *
> +        *                      -> NOHZ
> +        *              -> NOHZ
> +        *      ->NOHZ
> +        *
> +        * >--- [sample B]
> +        *
> +        * >--- [sample C]
> +        *
> +        *      NOHZ-> (here)
> +        *
> +        * Since all CPUs went into NOHZ state, all 'missed' samples (B, C)
> +        * should include the folded idle-delta.
> +        */
> +       delta += calc_load_fold_idle();

This gives a gcc warning about use without init, which is true, that should be:

	delta = calc_load_fold_idle();

> +       if (delta)
> +               atomic_long_add(delta, &calc_load_tasks);
