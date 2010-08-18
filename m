Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab0HRI7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:59:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0HRI7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:59:16 -0400
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
From: Peter Zijlstra <peterz@infradead.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4C6B8562.1070902@ladisch.de>
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>
	 <20100817143509.GC2838@zhy> <4C6AB76C.9060809@s5r6.in-berlin.de>
	 <4C6B8562.1070902@ladisch.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 Aug 2010 10:59:02 +0200
Message-ID: <1282121942.1926.3552.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 09:01 +0200, Clemens Ladisch wrote:
> +retry:
>         spin_lock_irqsave(&card->lock, flags);
>         list_for_each_entry(t, &card->transaction_list, link) {
>                 if (t == transaction) {
> +                       if (!del_timer(&t->split_timeout_timer)) {
> +                               /* wait for the timer to cancel it */
> +                               spin_unlock_irqrestore(&card->lock, flags);
> +                               cpu_relax();
> +                               goto retry;
> +                       } 

Open-coding spin loops like that is really ugly, and could cause trouble
for -rt.

Also, I believe that if you want the very same semantics as before, you
need to use try_to_del_timer_sync(), not del_timer().

Also, if del_timer_sync() is not allowed from any interrupt context
(including softirq) then doing the spin-loop like that doesn't actually
solve anything.

Thomas, any comments?
