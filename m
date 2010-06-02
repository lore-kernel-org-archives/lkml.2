Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab0FBSkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:40:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757851Ab0FBSkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:40:39 -0400
Date: Wed, 2 Jun 2010 11:34:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: TAMUKI Shoichi <tamuki@linet.gr.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: keep blinking in spite of long spin timer mode
Message-Id: <20100602113446.060847eb.akpm@linux-foundation.org>
In-Reply-To: <201005272156.AA00412@tamuki.linet.gr.jp>
References: <201005272156.AA00412@tamuki.linet.gr.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 06:56:45 +0900
TAMUKI Shoichi <tamuki@linet.gr.jp> wrote:

> To keep panic_timeout accuracy when running under a hypervisor, the
> current implementation only spins on long time (1 second) calls to
> mdelay.  That brings a good effect, but we must give up blinking even
> if we have a panic_blink.
> 
> This patch keeps blinking in spite of long spin timer mode.
> 
> We now have new kernel parameter (panic_longspin) to enable long spin
> timer mode when kernel panics.  This is to be used when running under
> a hypervisor (default is disable).

The whole panic-blink setup seems rather poorly thought out.

Would it not be better if a call to (*panic_blink)() were to simply set
the state of the LED and then return?  So callers can do

	int state = 0;

	for ( ; ; ) {
		(*panic_blink)(state);
		state ^= 1;
		mdelay(MSEC_PER_SEC);
	}

?
