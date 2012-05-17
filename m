Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967347Ab2EQWEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:04:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:46299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965954Ab2EQWEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:04:38 -0400
Message-ID: <1337292273.4281.101.camel@twins>
Subject: Re: [PATCH 2/2] block: Convert BDI proportion calculations to
 flexible proportions
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Date: Fri, 18 May 2012 00:04:33 +0200
In-Reply-To: <1337096583-6049-3-git-send-email-jack@suse.cz>
References: <1337096583-6049-1-git-send-email-jack@suse.cz>
	 <1337096583-6049-3-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 17:43 +0200, Jan Kara wrote:
> +static struct timer_list writeout_period_timer =
> +               TIMER_DEFERRED_INITIALIZER(writeout_period, 0, 0); 

So the problem with using a deferred timer is that it 'ignores' idle
time. So if a very busy period is followed by a real quiet period you'd
expect all the proportions to have aged to 0, but they won't have.

One way to solve that is to track a jiffies count of the last time the
timer triggered and compute the missed periods from that and extend
fprop_new_period() to deal with period increments of more than 1.

The other is of course to not use deferred timers.
