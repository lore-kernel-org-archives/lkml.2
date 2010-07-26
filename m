Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0GZI4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:56:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0GZI4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:56:16 -0400
Date: Mon, 26 Jul 2010 10:53:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, andi.kleen@intel.com,
        stable@kernel.org
Subject: Re: [PATCH] Don't apply for write lock on tasklist_lock if parent
	doesn't ptrace other processes
Message-ID: <20100726085324.GA32223@redhat.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com> <20100721144944.5351c741.akpm@linux-foundation.org> <20100721222529.EFBAA400B6@magilla.sf.frob.com> <20100722090524.GA6647@redhat.com> <1279874705.2096.1274.camel@ymzhang.sh.intel.com> <20100723173453.GA29831@redhat.com> <1280120732.2085.3.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280120732.2085.3.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26, Zhang, Yanmin wrote:
>
> On Fri, 2010-07-23 at 19:34 +0200, Oleg Nesterov wrote:
> > On 07/23, Zhang, Yanmin wrote:
> > >
> > > After applying my patch (although it's incorrect as there is a race with TRACEME),
> > > perf shows write_lock_irq in forget_original_parent consumes less than 40% cpu time on
> > > 8-socket machine.
> >
> > Any chance you can test the patch I sent? It should have the same effect,
> > otherwise there is something interesting.
> 1) with my patch, we got about 13% improvement;
> 2) With your patch, we got about 11% improvement;
>
> Performance is very sensitive to spinlock contention on large machines.

Zhang, thank you very much.

But. In this case I do not trust these results or I missed something.
I mean, they do not look 100% accurate.

With your patch:

	forget_original_parent:

		exit_ptrace:
			if (list_empty(ptraced))
				return;


		write_lock_irq(tasklist);

		... do a lot more work ...

With my patch:

	forget_original_parent:

		write_lock_irq(tasklist);
	
		exit_ptrace:
			if (list_empty(ptraced))
				return;

		... do a lot more work ...

The only difference is that we are doing the function call + list_empty()
under tasklist, just a few instructions compared to "do a lot more work"
in forget_original_parent().

How this can make the 2% difference ? This looks like a noise to me,
or do you think I missed something?

> > Heh. We must optimize it. But it is not clear when ;)
> Thanks. It's better to remove the big lock.

Yes. The only problem this is very much nontrival with the current code.

Oleg.

