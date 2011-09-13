Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab1IMWmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 18:42:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54463 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab1IMWmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 18:42:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=eKzM3ohjFvs36k0rlsirdgr4mmzU+JHTn9pWZ9wJ1kATMDZ9biih00yHcfvjL5aZ2
	qigmZgwQlA+iUAJiGxggg==
Date: Tue, 13 Sep 2011 15:41:42 -0700
From: Andrew Morton <akpm@google.com>
To: J.Weitzel@phytec.de
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] w1: Disable irqs in critical section
Message-Id: <20110913154142.f14b2c4c.akpm@google.com>
In-Reply-To: <1315460781.4396.10.camel@lws-weitzel>
References: <1315385312-1176-1-git-send-email-j.weitzel@phytec.de>
	<20110907175059.GA12074@ioremap.net>
	<1315460781.4396.10.camel@lws-weitzel>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Sep 2011 07:46:21 +0200
Jan Weitzel <J.Weitzel@phytec.de> wrote:

> Am Mittwoch, den 07.09.2011, 21:50 +0400 schrieb Evgeniy Polyakov:
> > On Wed, Sep 07, 2011 at 10:48:32AM +0200, Jan Weitzel (j.weitzel@phytec.de) wrote:
> > > Interrupting w1_delay in w1_read_bit results in missing the low level
> > > on the w1 line and receiving "1" instead of "0".
> > > Adding local_irq_save / local_irq_restore around the critical section
> > 
> > This means that CPU will be essentially stuck for 15 useconds for every
> > bit transferred, doesn't really look like a good idea.
> > 
> > Are you absolutely sure that missing bit is because of timings and not
> > some other bug?
> > 
> 
> I trigger a gpio line after the samplepoint. I case of a wrong bit the
> sample is taken after the "0 gap". The cycle time (samplt to sample)is
> increased form about 80__s to 95__s. 
> I did the measurement with the w1-gpio driver on a OMAP4 board.
> 

I'm not clear on how w1 actually works.  Is it a bit-banging
protocol in which the timing is provided by the host CPU?  If so then
yes, we should carefully disable interrupts in places where an
interrupt would disrupt critical timing.  (But what to do about NMIs
and SMIs?)

Disabling interrupts for 15us is pretty obnoxious, but there's a 55us
delay there with interrupts enabled, so the overall effect shouldn't be
too bad.

Finally, can we fine-tune the interrupt-disabled section a bit?  For
example, can the local_irq_disable() be moved to after the
write_bit(..., 0)?

