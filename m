Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab1FNKKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:10:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56191 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab1FNKKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UbQ5JQmDns/Khb6cPHDrQ02BMewMwOTMTPcO4vJv50KhPH2G/4eiaDDjElQws9IMBL
         9DLnst1yJUntf1tybh5Sh4mbyegfkG25pgdKU9ToMSB4SZVDNPAiHRZYoo9Yh2CRFXre
         nFUalc7IsGpX1Egv1KGoekXOh3t+8DE04W8r0=
Date: Tue, 14 Jun 2011 12:10:38 +0200
From: "tj@kernel.org" <tj@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [patch v4 1/2] stop_machine: enable __stop_machine() to be
 called from the cpu online path
Message-ID: <20110614101038.GH8141@htj.dyndns.org>
References: <20110613175832.331826123@sbsiddha-MOBL3.sc.intel.com>
 <20110613175915.504721985@sbsiddha-MOBL3.sc.intel.com>
 <20110613195613.GA11196@elte.hu>
 <1307998158.2682.33.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307998158.2682.33.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo, Suresh.

On Mon, Jun 13, 2011 at 01:49:18PM -0700, Suresh Siddha wrote:
> On Mon, 2011-06-13 at 12:56 -0700, Ingo Molnar wrote:
> > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > 
> > >  include/linux/stop_machine.h |   11 +++--
> > >  kernel/stop_machine.c        |   91 ++++++++++++++++++++++++++++++++++++++++---
> > >  2 files changed, 93 insertions(+), 9 deletions(-)
> > 
> > Btw., this is *way* too risky for a -stable backport.
> > 
> 
> Ingo, we can have a smaller patch (appended) for the -stable. How do you
> want to go ahead? Take this small patch for both mainline and -stable
> and the two code cleanup/consolidation patches for -tip (to go into
> 3.1?). Thanks.

So, here's what I think we should do.

* Polish up this simpler patch and send it for 3.0 through -tip.  It's
  slightly scary but not too much and fixes a real bug.  After a
  while, we can ask -stable to pull the simple version.

* Work on proper update which drops custom implementation from mtrr
  code for 3.1 window.  BTW, even after the recent revisions, I think
  the stop machine change is a bit too hacky.  I'll reply to that
  separately.

> diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
> index 092dc9b..8a28d4c 100644
> --- a/include/linux/stop_machine.h
> +++ b/include/linux/stop_machine.h
> @@ -33,6 +33,10 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
>  int stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg);
>  int try_stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg);
>  
> +void lock_stop_cpus(void);
> +int try_lock_stop_cpus(void);
> +void unlock_stop_cpus(void);

Ugh... Can you please just export stop_cpus_mutex and have CONFIG_SMP
in mtrr code.  After all, it's a temporary workaround for mtrr.  No
reason to add three functions for that.

Thank you.

-- 
tejun
