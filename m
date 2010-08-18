Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab0HRJIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:08:41 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59670 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0HRJIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:08:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fo6eMUZwfgBxkpbfHS23g6rJwlqe8AFayLyhrta6UVCzqSpXET4hyRSsokQwgJbE/a
         17KFzgmyGrh1dzl54jjUhMFhLgsmN3yBP7P+e/Z0PVr8ByfVYUkGGRFwdHDGGubjzkWQ
         vDiZ165+jd/vf+ZThjCLHVF0MI93bngTopw9Y=
MIME-Version: 1.0
In-Reply-To: <4C6B9547.8060509@s5r6.in-berlin.de>
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>
	<20100817143509.GC2838@zhy>
	<4C6AB76C.9060809@s5r6.in-berlin.de>
	<4C6B8562.1070902@ladisch.de>
	<4C6B9547.8060509@s5r6.in-berlin.de>
Date: Wed, 18 Aug 2010 17:08:37 +0800
Message-ID: <AANLkTimqt22PHNsYt=M4de9VwGEB7REKqtc4zOanZ+JB@mail.gmail.com>
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
From: Yong Zhang <yong.zhang0@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 4:09 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Again, is the term "interrupt contexts" meant to include softIRQ contexts?

I can't think out a scene which prevent del_timer_sync() from using in
softirq. :(

Then I go back and find that comments comes before linux-2.6.12,
then in linux-2.6.12, del_timer_sync() is like this:

int del_timer_sync(struct timer_list *timer)
{
	tvec_base_t *base;
	int i, ret = 0;

	check_timer(timer);

del_again:
	ret += del_timer(timer);

	for_each_online_cpu(i) {
		base = &per_cpu(tvec_bases, i);
		if (base->running_timer == timer) {
			while (base->running_timer == timer) {
				cpu_relax();
				preempt_check_resched();
			}
			break;
		}
	}
	smp_rmb();
	if (timer_pending(timer))
		goto del_again;

	return ret;
}
EXPORT_SYMBOL(del_timer_sync);

Seems preempt_check_resched() is the proof of that comments, but
now del_timer_sync() is changed.

I don't know if there is any other restriction.

Thanks,
Yong

>
> (Nothing in firewire-core/-sbp2/-net etc. is called in hardware
> interrupts.  BTW, we actually could and maybe should change all the
> spinlocks in them from spin_lock_irq to spin_lock_bh.  Only
> firewire-ohci's local ohci->lock needs to be IRQ safe.  OTOH this could
> change if somebody comes up with a migration of the stack to threaded
> IRQ handling.)
> --
> Stefan Richter
> -=====-==-=- =--- =--=-
> http://arcgraph.de/sr/
>
