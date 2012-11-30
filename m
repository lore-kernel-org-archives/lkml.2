Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab2K3Wa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 17:30:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2K3WaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:30:24 -0500
Date: Fri, 30 Nov 2012 14:30:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "jim.cromie@gmail.com" <jim.cromie@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH] Avoid dead lock of console related locks in panic case
Message-Id: <20121130143023.2d67d817.akpm@linux-foundation.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A02C44@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A02C44@USINDEM103.corp.hds.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012 17:11:07 +0000
Seiji Aguchi <seiji.aguchi@hds.com> wrote:

> If one cpu ,which is taking a logbuf_lock or console_sem, 
> receive IPI/NMI from a panicked cpu via smp_send_stop(),
> the panicked cpu hangs up in subsequent kmsg_dump()/printk()
> because logbuf_lock and console_sem are taken in the function calls.
> 
> This causes a console blank and users can't see panic messages.
> 
> [Solution]
> 
> this patch introduces a logic initializing logbuf_lock and console_sem
> just after smp_send_stop() to avoid dead locks above.

That is one nasty looking patch :(

- Makes the logic in this area even more twisty and complex, when
  what we need to do is to simplify it

- Reinitialises in-use locks

- Gives the boolean variable "yes" three states, but didn't rename
  that variable to something appropriate.

- Passes yes==2 into s390's unsuspecting bust_spinlocks() implementation.


Let's step back a bit.  Please identify with great specificity the code
sites which are stopping other CPUs before taking locks which those
other CPUs might have been holding.

Then let's see what we can do to fix up the callers, instead of trying
to tidy up after they have made this mess.

