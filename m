Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1CKR61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:58:27 -0500
Received: from www.tglx.de ([62.245.132.106]:46639 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab1CKR6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:58:23 -0500
Date: Fri, 11 Mar 2011 18:57:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
cc: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD v2 2/6] mfd: pm8xxx: Add irq support
In-Reply-To: <4D79A85D.8000301@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1103111853480.2787@localhost6.localdomain6>
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org> <1299564590-30116-3-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1103081201520.2787@localhost6.localdomain6> <4D770E47.6050402@codeaurora.org>
 <alpine.LFD.2.00.1103101126100.2787@localhost6.localdomain6> <4D79A85D.8000301@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011, Abhijeet Dharmapurikar wrote:
> Thomas Gleixner wrote:
> > On Tue, 8 Mar 2011, Abhijeet Dharmapurikar wrote:
> > > > ack is called before mask and it
> > > > should never be called when the interrupt is masked.
> > > I didnt quite understand this comment. handle_level_irq calls mask_ack
> > > which
> > > masks the interrupt and then acks it. In this case the ack is called after
> > > the
> > 
> > Indeed, sorry. So the right way to deal with that is to provide a
> > mask_ack() callback which does it in the correct order for your
> > HW. That way you avoid all the local state storage.
> 
> 
> Yes however while updating the code I noticed that I would need to keep
> account of all the interrupts enabled and all the interrupts marked wakeup.
> This aids in switching to the wakeup set in the suspend callback and the
> enabled set in the resume callback. I will update the resume callback to
> enable the interrupts in irqs_allowed(the local state storage) in the next
> patch (my current patch does not do that).
> 
> IOW I need to keep the local state storage.

Wrong. The interrupts are disabled and reenabled by the core code and
not by some extra suspend/resume callbacks in your driver. The core
checks those marked as IRQ_WAKE, the wake callback to the irq chip is
only there if you need to set up some hardware register in order to
make the wake functionality work. So again, you don't need local state
as the core tracks the state for you.

Thanks,

	tglx
