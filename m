Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab1AQO7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:59:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:40881 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1AQO7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:59:30 -0500
Subject: Re: Bug in scheduler when using rt_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: samu.p.onkalo@nokia.com
Cc: mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <1295275365.12840.13.camel@kolo>
References: <1295275365.12840.13.camel@kolo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Jan 2011 16:00:01 +0100
Message-ID: <1295276401.30950.125.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 16:42 +0200, Onkalo Samu wrote:
> Hi
> 
> I believe that there are some problems in the scheduling when
> the following happens:
> - Normal priority process locks rt_mutex and sleeps while keeping it
> locked.

There's your fail, don't do that!

> - RT priority process blocks on the rt_mutex while normal priority
> process is sleeping
> 
> This sequence can occur with I2C access when both normal priority
> thread and irq-thread access the same I2C bus. I2C core
> contains rt_mutex and I2C drivers can sleep with wait_for_completion.

Why does I2C core use rt_mutex, that's utterly broken.

> Based on my debugging following sequence occurs (single CPU
> system):
> 
> 1) There is some user process running at the background (like
> cat /dev/zero..)
> 2) User process reads sysfs entry which causes I2C acccess
> 3) User process locks rt_mutex in the I2C-core
> 4) User process sleeps while it keeps rt_mutex locked
> (wait_for_completion in I2C transfer function)

That's where things go wrong, there's absolutely nothing you can do to
fix the system once you block while holding a mutex.

