Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966667Ab2EQV4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:56:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34935 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965954Ab2EQV4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:56:53 -0400
Message-ID: <1337291805.4281.97.camel@twins>
Subject: Re: [PATCH 1/2] lib: Proportions with flexible period
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Date: Thu, 17 May 2012 23:56:45 +0200
In-Reply-To: <1337096583-6049-2-git-send-email-jack@suse.cz>
References: <1337096583-6049-1-git-send-email-jack@suse.cz>
	 <1337096583-6049-2-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 17:43 +0200, Jan Kara wrote:
> +void fprop_fraction_percpu(struct fprop_global *p,
> +                          struct fprop_local_percpu *pl,
> +                          unsigned long *numerator, unsigned long *denominator)
> +{
> +       unsigned int seq;
> +       s64 den;
> +
> +       do {
> +               seq = read_seqcount_begin(&p->sequence);
> +               fprop_reflect_period_percpu(p, pl);
> +               *numerator = percpu_counter_read_positive(&pl->events);
> +               den = percpu_counter_read(&p->events);
> +               if (den <= 0)
> +                       den = percpu_counter_sum(&p->events);
> +               *denominator = den;
> +       } while (read_seqcount_retry(&p->sequence, seq));
> +} 


why not use percpu_counter_read_positive(&p->events) and ditch
percpu_counter_sum()? That sum can be terribly expensive..
