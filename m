Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2LQPf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:35:29 -0500
Received: from tex.lwn.net ([70.33.254.29]:36863 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab2LQPf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:35:28 -0500
Date: Mon, 17 Dec 2012 08:37:59 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Marcos Lois =?UTF-8?B?QmVybcO6ZGV6?= <marcos.discalis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about using new request_threaded_irq
Message-ID: <20121217083759.0cbed418@lwn.net>
In-Reply-To: <50CF361A.1030203@gmail.com>
References: <50CF361A.1030203@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 16:11:22 +0100
Marcos Lois Bermúdez <marcos.discalis@gmail.com> wrote:

> For my understand if i call for example:
> 
> request_threaded_irq(irqmum, NULL, irq_handle, IRQF_TRIGGER_FALLING, 
> DEVICE_NAME, priv);
> 
> This seem to make a old Hard IRQ handler, and inside of this handler 
> sleep APIs can't be used, but i see some SPI drivers that seem to 
> register a IRQ of this form and make API calls that can sleep in the 
> handler.

Not quite.  The prototype for request_threaded_irq() is:

int request_threaded_irq(unsigned int irq, irq_handler_t handler,
			 irq_handler_t thread_fn, unsigned long irqflags,
			 const char *devname, void *dev_id)

Note the presents of *two* handlers, called "handler" and "thread_fn".
The first, "handler", is called in interrupt context; it's job is usually
to quiet the device and return; it cannot sleep.  If it's return value is
IRQ_WAKE_THREAD, the thread_fn() will be called in process context; it
*can* sleep.  In the example you cite, there is no immediate handler, only
the thread_fn(); the call to a blocking function from within the
thread_fn() is correct.

Hope that helps,

jon

Jonathan Corbet / LWN.net / corbet@lwn.net
