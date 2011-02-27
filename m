Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab1B0MKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 07:10:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52528 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1B0MKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 07:10:02 -0500
Date: Sun, 27 Feb 2011 13:09:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/4] printk: Allocate kernel log buffer earlier
Message-ID: <20110227120949.GF16453@elte.hu>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
 <20110225180634.017570095@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225180634.017570095@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> On larger systems, because of the numerous ACPI, Bootmem and EFI
> messages, the static log buffer overflows before the larger one
> specified by the log_buf_len param is allocated.  Minimize the
> potential for overflow by allocating the new log buffer as soon
> as possible.
> 
> We do this by changing the log_buf_len from an early_param to a
> _setup param.  But _setup params are processed before the
> alloc_bootmem is available, so this function will now just save
> the requested log buf len.  The real work routine (setup_log_buf)
> is called after bootmem is available.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Jack Steiner <steiner@sgi.com>
> Reviewed-by: Robin Holt <holt@sgi.com>
> ---
>  arch/x86/kernel/setup.c |    5 +++
>  include/linux/printk.h  |    4 ++
>  init/main.c             |    1 
>  kernel/printk.c         |   75 ++++++++++++++++++++++++++++--------------------
>  4 files changed, 54 insertions(+), 31 deletions(-)

Well, the modern allocation method is memblock - available on all major 
architectures.

You could avoid all this ugly workaround of bootmem limitations by moving the 
allocation to memblock_alloc() and desupporting the log_buf_len= boot parameter
on non-memblock architectures.

kernel log buffer size can be configured via the .config so they will not be left 
without larger buffers.

Doing this should also have the advantage of getting all the early x86 messages into 
the larger buffer already, reducing the pressure to apply some of the other patches 
in your series.

Thanks,

	Ingo
