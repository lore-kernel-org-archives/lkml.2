Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1DVMqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:46:22 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36853 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362Ab1DVMqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:46:19 -0400
Date: Fri, 22 Apr 2011 13:46:16 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] signal: sigprocmask() should do
 retarget_shared_pending()
Message-ID: <20110422134616.7447e612@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110418134557.GF15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<20110418134557.GF15951@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 15:45:57 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> In short, almost every changing of current->blocked is wrong, or at least
> can lead to the unexpected results.
> 
> For example. Two threads T1 and T2, T1 sleeps in sigtimedwait/pause/etc.
> kill(tgid, SIG) can pick T2 for TIF_SIGPENDING. If T2 calls sigprocmask()
> and blocks SIG before it notices the pending signal, nobody else can handle
> this pending shared signal.
> 
> I am not sure this is bug, but at least this looks strange imho. T1 should
> not sleep forever, there is a signal which should wake it up.
> 
> This patch moves the code which actually changes ->blocked into the new
> helper, set_current_blocked() and changes this code to call
> retarget_shared_pending() as exit_signals() does. We should only care about
> the signals we just blocked, we use "newset & ~current->blocked" as a mask.
> 
> We do not check !sigisemptyset(newblocked), retarget_shared_pending() is
> cheap unless mask & shared_pending.
> 
> Note: for this particular case we could simply change sigprocmask() to
> return -EINTR if signal_pending(), but then we should change other callers
> and, more importantly, if we need this fix then set_current_blocked() will
> have more callers and some of them can't restart. See the next patch as a
> random example.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

This looks much simpler to me.

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
