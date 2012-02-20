Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2BTHvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 02:51:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37514 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab2BTHva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 02:51:30 -0500
Date: Mon, 20 Feb 2012 08:51:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] i387: support lazy restore of FPU state
Message-ID: <20120220075101.GB30810@elte.hu>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202191423270.3898@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202191426460.3898@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1202191426460.3898@i5.linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> +DECLARE_PER_CPU(struct task_struct *, fpu_owner_task);

> +static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
> +{
> +	return new == percpu_read_stable(fpu_owner_task) &&
> +		cpu == new->thread.fpu.last_cpu;
> +}

I guess the CPU hotplug case deserves a comment in the code: CPU 
hotplug + replug of the same (but meanwhile reset) CPU is safe 
because fpu_owner_task[cpu] gets reset to NULL.

Likewise, if we hot-unplug two CPUs and then insert the second 
one, it's the same CPU index but not the same FPU state anymore. 
There too the CPU hotplug code resetting fpu_owner_task to NULL 
makes this optimization safe.

Thanks,

	Ingo
