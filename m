Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab0HPW1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 18:27:21 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:42025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab0HPW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 18:27:20 -0400
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1281994939.1926.2075.camel@laptop>
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>
	 <1281994939.1926.2075.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 00:27:13 +0200
Message-ID: <1281997633.3683.50.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 23:42 +0200, Peter Zijlstra wrote:

> softirq:
>   spin_lock(&t->split_timeout_timer);
> 
> IRQ:
>   spin_lock(&(shost->host_lock)->rlock);
>    spin_lock(&t->split_timeout_timer);

Actually, I think it's worried that you could have


CPU 0                         CPU 1
 softirq:                      softirq:
   spin_lock(timer)              spin_lock(rlock)
 irq:
   spin_lock(rlock)
                                 spin_lock(timer) [still in softirq]

because it has previously seen the nesting that I put on CPU 1, and now
found that the timer "lock" is used with interrupts enabled.

At least that's a scenario I could understand?

I'm convinced it's a false positive though, question is how to shut it
up :-)

johannes

