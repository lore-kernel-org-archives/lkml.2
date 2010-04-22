Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0DVNMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:12:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53276 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753068Ab0DVNMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:12:06 -0400
Date: Thu, 22 Apr 2010 14:16:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Sreedhara DS <sreedhara.ds@intel.com>
Subject: Re: [PATCH] IPC driver for Intel Mobile Internet Device (MID)
 platforms
Message-ID: <20100422141611.2599ee67@lxorguk.ukuu.org.uk>
In-Reply-To: <20100421131615.d8430a50.akpm@linux-foundation.org>
References: <20100409102629.22832.30883.stgit@localhost.localdomain>
	<20100421131615.d8430a50.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> __packed, please.  (I've requested that this be added to checkpatch,
> but Mr Checkpatch is asleep).

Done


> > +static inline int busy_loop(void) /* Wait till scu status is busy */
> > +{
> > +	u32 status = 0;
> > +	u32 loop_count = 0;
> > +
> > +	status = __raw_readl(IPC_STATUS_REG);
> > +	while (status & 1) {
> > +		udelay(1); /* scu processing time is in few u secods */
> > +		status = __raw_readl(IPC_STATUS_REG);
> > +		loop_count++;
> > +		/* break if scu doesn't reset busy bit after huge retry */
> > +		if (loop_count > 100000)
> > +			return -ETIMEDOUT;

> This function has seven-odd callsites and is waaaaaaaay to fat and slow
> to be inlined.

Looking at the asm I'm not convinced.


> > +	if (id == IPC_CMD_PCNTRL_R) { /* Read rbuf */
> > +		/* Workaround: values are read as 0 without memcpy_fromio */
> > +		memcpy_fromio(cbuf, IPC_READ_BUFFER, 16);
> 
> Should we still be doing this if busy_loop() failed?
> 
> (Lots of dittoes on this question)

Does no harm

> > +}
> 
> I wonder if this function would look better if cbuf had type u16[],

No - we do byte aligned access to it. and cbuf[offset + 1.5] is sadly not
supported by C (although I suspect you can make it work in C++ ;))

> > +	mutex_lock(&ipclock);
> > +	if (ipcdev.pdev == NULL) {
> 
> This check happens a lot.  Can it really happen?

Yes.

> I think mailbox_base could/should have had type `struct
> fw_update_mailbox __iomem *'.  ioremap_nocache() should handle that
> cleanly, and this cast goes away.

Definitely - and the rest them cleans up by magic

Alan
