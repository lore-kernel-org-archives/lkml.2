Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab1INMX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 08:23:29 -0400
Received: from mail.visioncatalog.de ([217.6.246.34]:44565 "EHLO
	root.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab1INMX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 08:23:28 -0400
Subject: Re: [RFC] w1: Disable irqs in critical section
From: Jan Weitzel <J.Weitzel@phytec.de>
Reply-To: J.Weitzel@phytec.de
To: Andrew Morton <akpm@google.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110913154142.f14b2c4c.akpm@google.com>
References: <1315385312-1176-1-git-send-email-j.weitzel@phytec.de>
	 <20110907175059.GA12074@ioremap.net> <1315460781.4396.10.camel@lws-weitzel>
	 <20110913154142.f14b2c4c.akpm@google.com>
Organization: PHYTEC Messtechnik GmbH
Date: Wed, 14 Sep 2011 14:23:25 +0200
Message-ID: <1316003005.4369.10.camel@lws-weitzel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-MIMETrack: Itemize by SMTP Server on Idefix/Phytec(Release 8.5.2FP2|March 22, 2011) at
 14.09.2011 14:23:25,
	Serialize by Router on Idefix/Phytec(Release 8.5.2FP2|March 22, 2011) at
 14.09.2011 14:23:26,
	Serialize complete at 14.09.2011 14:23:26
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 13.09.2011, 15:41 -0700 schrieb Andrew Morton:
> On Thu, 08 Sep 2011 07:46:21 +0200
> Jan Weitzel <J.Weitzel@phytec.de> wrote:
> 
> > Am Mittwoch, den 07.09.2011, 21:50 +0400 schrieb Evgeniy Polyakov:
> > > On Wed, Sep 07, 2011 at 10:48:32AM +0200, Jan Weitzel (j.weitzel@phytec.de) wrote:
> > > > Interrupting w1_delay in w1_read_bit results in missing the low level
> > > > on the w1 line and receiving "1" instead of "0".
> > > > Adding local_irq_save / local_irq_restore around the critical section
> > > 
> > > This means that CPU will be essentially stuck for 15 useconds for every
> > > bit transferred, doesn't really look like a good idea.
> > > 
> > > Are you absolutely sure that missing bit is because of timings and not
> > > some other bug?
> > > 
> > 
> > I trigger a gpio line after the samplepoint. I case of a wrong bit the
> > sample is taken after the "0 gap". The cycle time (samplt to sample)is
> > increased form about 80__s to 95__s. 
> > I did the measurement with the w1-gpio driver on a OMAP4 board.
> > 
> 
> I'm not clear on how w1 actually works.  Is it a bit-banging
> protocol in which the timing is provided by the host CPU?  If so then
correct.
> yes, we should carefully disable interrupts in places where an
> interrupt would disrupt critical timing.  (But what to do about NMIs
> and SMIs?)
fortunately on our embedded platform we have no SMIs
> Disabling interrupts for 15us is pretty obnoxious, but there's a 55us
> delay there with interrupts enabled, so the overall effect shouldn't be
> too bad.
> 
> Finally, can we fine-tune the interrupt-disabled section a bit?  For
> example, can the local_irq_disable() be moved to after the
> write_bit(..., 0)?
> 
The falling edge from 1 to 0 starts timing for the slave. After the 6µs
the slave should drive the line low (In case the information bit is
"0"). So there is no additional edge on the line. If there is an
interrupt and the low pulse from master is longer, slave did't see it.
Master need to generate the 1 -> 0 transition and measure after 15µs

I tested it anyhow. Behaviour is slightly better than without disabling
interrupts. Only disabling it for 15µs fix the problem. 

Jan

