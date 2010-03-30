Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab0CaC46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:56:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024Ab0CaC4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:56:54 -0400
Date: Tue, 30 Mar 2010 19:55:01 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: InKi Dae <daeinki@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] added S6E63M0 AMOLED LCD Panel driver.
Message-Id: <20100330195501.747515e9.akpm@linux-foundation.org>
In-Reply-To: <90b950fc1003301941r69dc5ce1ida64b590646049a7@mail.gmail.com>
References: <90b950fc1003252024i5ba8989bg95f0a81e8e5e708e@mail.gmail.com>
	<20100330160257.e5f978a9.akpm@linux-foundation.org>
	<90b950fc1003301941r69dc5ce1ida64b590646049a7@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 11:41:54 +0900 InKi Dae <daeinki@gmail.com> wrote:

> Hi Andrew,
> 
> all the calls to s6e63m0_panel_send_sequence() would return -EINVAL.
> by api_async() of driver/spi/spi.c

No, spi_async() does

	master->transfer(spi, message);

which can return at least EIO, EINPROGRESS, EINVAL or ETIMEDOUT.

> so I think that those return values aren't changed to other.
> 
> and final step is to check only whether the return value is 0 or not.
> if you still think that this code has minor problem or you want it to
> be corrected
> then I will patch this code to be corrected anytime.

It's a bug.

Also s6e63m0_power_on() is sloppy.  It again or's together disparate
errnos.  Then if _anything_ failed it returns hardwired -EIO, but it
should instead propagate the callee's errno back up to the caller.

And s6e63m0_power_on() can return -EFAULT in several places, which is
nonsensical.

None of this is very critical, just ... sloppy.


