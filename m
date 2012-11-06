Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2KFWdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:33:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36830 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab2KFWdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:33:35 -0500
Date: Tue, 6 Nov 2012 22:33:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: sched_debug / traverse allocation failures.
Message-ID: <20121106223334.GL2616@ZenIV.linux.org.uk>
References: <20121106204947.GA1762@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106204947.GA1762@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 03:49:47PM -0500, Dave Jones wrote:

> I added some instrumentation to traverse, and it appears that the /proc file
> in question is 'sched_debug'.
> 
> Most the time this is quite small, but can grow to large lengths it seems,
> which when we're under memory fragmentation results in the spew above.
> 
> >From my reading of the code, it doesn't actually use the seq_operations,
> to print out things record-at-a-time, but just dumps everything
> in its ->open routine.

Not ->open(), first ->read(), actually.  I'd suggest turning that
sucker into a saner iterator, though - it spews a smallish header
followed by a set of per-CPU entries, so I'd probably start with
something like
static void *c_start(struct seq_file *m, loff_t *pos)
{
	unsigned long n = *pos;
        if (n == 0)
		return (void *)1;	/* header */
	n--;
	/* find the first online CPU >= requested position */
	if (n > 0)
		n = cpumask_next(n - 1, cpu_online_mask);
	else
                n = cpumask_first(cpu_online_mask);
	*pos = n + 1;
        if (n < nr_cpu_ids)
                return (void *)(unsigned long)(n + 2);	/* CPU #n */
        return NULL;			/* EOF */
}

static void *c_next(struct seq_file *m, void *v, loff_t *pos)
{
        (*pos)++;
        return c_start(m, pos);
}

static int c_show(struct seq_file *m, void *v)
{
	if (v == (void *)1) {
		print header
	} else {
		unsigned long cpu = (unsigned long)v - 2;
		print for that cpu
	}
}
