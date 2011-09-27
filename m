Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1I0Vsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:48:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:36006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1I0Vsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:48:53 -0400
Subject: Re: [RFD 3/9] Display /proc/stat information per cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com
Date: Tue, 27 Sep 2011 23:48:16 +0200
In-Reply-To: <1316816432-9237-4-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	 <1316816432-9237-4-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317160096.21836.14.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
> +static inline void task_cgroup_account_field(struct task_struct *p,
> +                                            cputime64_t tmp, int index)
> +{
> +       struct kernel_stat *kstat;
> +       struct task_group *tg = task_group(p);
> +
> +       do {
> +               kstat = this_cpu_ptr(tg->cpustat);
> +               kstat->cpustat[index] = cputime64_add(kstat->cpustat[index],
> +                                                     tmp);

So aside from the cputime64_t nonsense you could actually write that as:

		__this_cpu_add(tg->cpustat[index], tmp);

which should yield better asm I think, a quick grep seems to confirm
cputime64_t is indeed a u64 all over so its fair to just ignore that.

> +               tg = tg->parent;
> +       } while (tg);
> +} 


