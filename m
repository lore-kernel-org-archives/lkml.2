Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab2CZSBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:01:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58353 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab2CZSBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:01:33 -0400
Message-ID: <1332782624.16159.145.camel@twins>
Subject: Re: [PATCH v2.1 01/10] cpu: Introduce clear_tasks_mm_cpumask()
 helper
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org
Date: Mon, 26 Mar 2012 19:23:44 +0200
In-Reply-To: <20120326170443.GA25229@redhat.com>
References: <20120324102609.GA28356@lizard> <20120324102751.GA29067@lizard>
	 <1332593021.16159.27.camel@twins> <20120324164316.GB3640@lizard>
	 <20120325174210.GA23605@redhat.com> <1332748746.16159.62.camel@twins>
	 <20120326170443.GA25229@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 19:04 +0200, Oleg Nesterov wrote:

> Interesting... Why? I mean, why do you dislike stop_machine() in
> _cpu_down() ? Just curious.

It disturbs all cpus, the -rt people don't like that their FIFO tasks
don't get to run, the trading people don't like their RDMA poll loops to
be interrupted.. etc.

Now arguably, one should simply not do hotplug crap while such things
are running, and mostly that's a perfectly fine constraint. But it
doesn't help that people view cpu hotplug as a power savings or resource
provisioning 'feature' and there's userspace daemons that plug
on-demand.

But my ultimate goal is to completely remove synchronization that is
actively machine wide, since we all know that as long as such stuff
exists people will want to use it.

Now I don't know we'll ever fully get there -- see the BKL saga -- but
its worth trying I think. The module unload and esp. the text_poke usage
of stop_machine are much worse offenders, since both those are
relatively common and much harder to avoid.
