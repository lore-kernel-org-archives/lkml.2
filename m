Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0JEBmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 21:42:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33650 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0JEBmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 21:42:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Oct 2010 10:36:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jack Steiner <steiner@sgi.com>
Cc: yinghai@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: Problem: scaling of /proc/stat on large systems
Message-Id: <20101005103650.7ebe64f0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101004143414.GA4261@sgi.com>
References: <20100929122206.GA30317@sgi.com>
	<20100930140901.037f9dc7.kamezawa.hiroyu@jp.fujitsu.com>
	<20101004143414.GA4261@sgi.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010 09:34:15 -0500
Jack Steiner <steiner@sgi.com> wrote:

> On Thu, Sep 30, 2010 at 02:09:01PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 29 Sep 2010 07:22:06 -0500
> > Jack Steiner <steiner@sgi.com> wrote:
> 
> 
> I was able to run on the 4096p system over the weekend. The patch is a 
> definite improvement & partially fixes the problem:
> 
> A "cat /proc/stat >/dev/null" improved:
> 
>         OLD:    real    12.627s
>         NEW:    real     2.459
> 
> 
Thank you.

> A large part of the remaining overhead is in the second summation 
>  of irq information:
> 
> 
>     static int show_stat(struct seq_file *p, void *v)
>         ...
>         /* sum again ? it could be updated? */
>         for_each_irq_nr(j) {
>                 per_irq_sum = 0;
>                 for_each_possible_cpu(i)
>                         per_irq_sum += kstat_irqs_cpu(j, i);
> 
>                 seq_printf(p, " %u", per_irq_sum);
>         }
> 
> Can this be fixed using the same approach as in the current patch?
> 
> 

I guess this requres different approarch as per-cpu counter + threshould.
like vmstat[] or lib/percpu_counter. 
Maybe people don't like to access shared counter in IRQ.

But, this seems to call radixtree-lookup for the # of possible cpus.
I guess impleimenting a call to calculate a sum of irqs in a radix-tree
lookup will reduce overhead. If it's not enough, we'll have to make the
counter not-precise. I'll write an another patch.


Thanks,
-Kame

