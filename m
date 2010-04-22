Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab0DVQnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:43:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271Ab0DVQny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:43:54 -0400
Date: Thu, 22 Apr 2010 09:41:56 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Sreedhara DS <sreedhara.ds@intel.com>
Subject: Re: [PATCH] IPC driver for Intel Mobile Internet Device (MID)
 platforms
Message-Id: <20100422094156.11b0e119.akpm@linux-foundation.org>
In-Reply-To: <20100422141611.2599ee67@lxorguk.ukuu.org.uk>
References: <20100409102629.22832.30883.stgit@localhost.localdomain>
	<20100421131615.d8430a50.akpm@linux-foundation.org>
	<20100422141611.2599ee67@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 14:16:11 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > +static inline int busy_loop(void) /* Wait till scu status is busy */
> > > +{
> > > +	u32 status = 0;
> > > +	u32 loop_count = 0;
> > > +
> > > +	status = __raw_readl(IPC_STATUS_REG);
> > > +	while (status & 1) {
> > > +		udelay(1); /* scu processing time is in few u secods */
> > > +		status = __raw_readl(IPC_STATUS_REG);
> > > +		loop_count++;
> > > +		/* break if scu doesn't reset busy bit after huge retry */
> > > +		if (loop_count > 100000)
> > > +			return -ETIMEDOUT;
> 
> > This function has seven-odd callsites and is waaaaaaaay to fat and slow
> > to be inlined.
> 
> Looking at the asm I'm not convinced.

I tried two version of gcc and both of them just refuse to inline
the function anyway.

If the function is changed to __always_inline, gcc will then inline it.

                  text    data     bss     dec     hex filename
inline            6182     960    1680    8822    2276 arch/x86/kernel/intel_scu_ipc.o
__always_inline   6582     928    1760    9270    2436 arch/x86/kernel/intel_scu_ipc.o

I agree with gcc ;)
