Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2IJSAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:00:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55727 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab2IJR77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:59:59 -0400
Date: Mon, 10 Sep 2012 10:57:25 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH 06/14] tty/serial/core: Introduce poll_init callback
Message-ID: <20120910175725.GA13673@lizard>
References: <20120910040802.GA1261@lizard>
 <20120910041335.GF29537@lizard>
 <20120910121320.03c9dfc7@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120910121320.03c9dfc7@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 12:13:20PM +0100, Alan Cox wrote:
> > +	tport = &state->port;
> > +	if (!(tport->flags & ASYNC_INITIALIZED) && port->ops->poll_init) {
> > +		mutex_lock(&tport->mutex);
> > +		ret = port->ops->poll_init(port);
> > +		/*
> > +		 * We don't set ASYNCB_INITIALIZED as we only initialized the
> > +		 * hw, e.g. state->xmit is still uninitialized.
> > +		 */
> > +		mutex_unlock(&tport->mutex);
> > +		if (ret)
> > +			return ret;
> > +	}
> 
> What stops a parallel open or close changing ASYNC_INITIALIZED after you
> test and before you lock ?

Yeah, I should do the whole thing under the mutex.

Not related to this particular issue, but the fact that close() can powerdown
the hardware is quite bad. Today it is always possible to use open,close
sequence on /dev/ttyXXXX, and polling would break if close() deinitializes the
hardware (e.g. via uart_change_pm()).

In console= case, serial core handles the issue via uart_console(), checking if
the port is used for console, preventing it to power down the hardware. We can
do the same, or make tty_find_polling_driver() refcount individual ports/lines.
But the issue is orthogonal to this particular patch, although needs to be
fixed some day.

Thanks!

Anton.
