Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2HTV1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:27:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56946 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab2HTV1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:27:14 -0400
Date: Mon, 20 Aug 2012 14:24:51 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Brian Swetland <swetland@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH v4 0/12] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120820212451.GA15823@lizard>
References: <20120820144449.GA32560@lizard>
 <CANqkERCzQdViRjhtz19wbSWEEnxYjpDcuUZNP9jNHYrtANwp-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANqkERCzQdViRjhtz19wbSWEEnxYjpDcuUZNP9jNHYrtANwp-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Mon, Aug 20, 2012 at 01:51:33PM -0700, Brian Swetland wrote:
> > - KGDB/KDB FIQ debugger shell is synchronous. In Google's version you
> >   could have a dedicated shell always running in the FIQ context,
[...]
> The main reason we did this asynchronously was that it's entirely possible
> to get the occasional random character on the debug serial port (which is
> often multiplexed with the audio path on the headphone jack), and having
> the device freeze mysteriously when this happens is problematic.
> 
> Since the FIQ debugger is incredibly useful for diagnosing "my device is
> stuck" type problems, we tend to leave it enabled on large numbers of
> devices during internal testing, so that if somebody runs into a problem
> an engineer can plug in a serial debug cable and take a look.  It's
> important that the presence of the debug feature doesn't lead to instability,
> and thus we don't want a single random character to stop the normal
> operation ofthe device.

Yup, and that's why in my approach I implemented a tiny async "shell" on
to of KDB, the shell accepts just one command "$3#33" -- GDB-protocol
escape sequence:

/**
 * kgdb_nmi_poll_knock - Check if it is time to enter the debugger
 *
 * "Serial ports are often noisy, especially when muxed over another port (we
 * often use serial over the headset connector). Noise on the async command
 * line just causes characters that are ignored, on a command line that blocked
 * execution noise would be catastrophic." -- Colin Cross
 *
 * So, this function implements KGDB/KDB knocking on the serial line: we won't
 * enter the debugger until we receive a known magic phrase (which is actually
 * "$3#33", known as "escape to KDB" command.
 ...

I.e. the kernel will print this prompt on the NMI debugger console:

        Type $3#33 to enter the debugger>

And this command will be processed asynchronously.

Thanks!

Anton.
