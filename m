Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab0DGRLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:11:21 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30848 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105Ab0DGRLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:11:11 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 07 Apr 2010 19:11:12 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 3/8] USB: f_fs: the FunctionFS driver
In-reply-to: <d8e956ce78914750460877b87ba2b0f707ab8a0f.1270644740.git.mina86@mina86.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-usb@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.vasx0y1d7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <cover.1270644740.git.mina86@mina86.com>
 <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
 <b866157fc128769a3cdf9ae76f9fc21743776778.1270644740.git.mina86@mina86.com>
 <d8e956ce78914750460877b87ba2b0f707ab8a0f.1270644740.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Apr 2010 15:41:30 +0200, Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:
> +static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
> +				     size_t n)
> +{
> +	/* We are holding ffs->ev.waitq.lock and ffs->mutex and we need
> +	 * to release them. */
> +
> +	struct usb_functionfs_event events[n];
> +	unsigned i = 0;
> +
> +	memset(events, 0, sizeof events);
> +
> +	do {
> +		events[i].type = ffs->ev.types[i];
> +		if (events[i].type == FUNCTIONFS_SETUP) {
> +			events[i].u.setup = ffs->ev.setup;
> +			ffs->setup_state = FFS_SETUP_PENDING;
> +		}
> +	} while (++i < n);
> +
> +	ffs->ev.count = 0;

I've just noticed.  This line should instead read:

+	if (n < ffs->ev.count) {
+		ffs->ev.count -= n;
+		memmove(ffs->ev.types, ffs->ev.types + n,
+			ffs->ev.count * sizeof *ffs->ev.types);
+	} else {
+		ffs->ev.count = 0;
+	}

This is a minor bug which should be rather hard to observe (and only
if user-space reads() less then 4 * sizeof(struct usb_functionfs_event)
bytes when reading from "ep0") so posted code is good for testing.
(I'll post a fixed version later on with possibly other fixes and
changes.)

> +
> +	spin_unlock_irq(&ffs->ev.waitq.lock);
> +	mutex_unlock(&ffs->mutex);
> +
> +	return unlikely(__copy_to_user(buf, events, sizeof events))
> +		? -EFAULT : sizeof events;
> +}

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
