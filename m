Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934692Ab0EEQLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:11:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54592 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934436Ab0EEQL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:11:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/13] tty: make termios mutex nest under tty_lock
Date: Wed, 5 May 2010 18:11:22 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de> <1273012433-6125-5-git-send-email-arnd@arndb.de>
In-Reply-To: <1273012433-6125-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005051811.22511.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18vXef1aZ5hoIZcHxV84IIaxQBd3lUO4xLP1j6
 xxQiwlpXcmey5IvebrG1OeLNaETF5X714/kqa87eKyk4MXgVmq
 wA5OuJ+44N//ejTueE32A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010, Arnd Bergmann wrote:
> Most of these are always called without the BTM held.
> Annotate them so we know in the future which places
> to look at. If we can change the code to never
> get termios_mutex while holding the BTM, this
> will solve all lock-order problems between the two.
> 
> tty_set_termios_ldisc and tty_reset_termios are currently
> the only functions that always get termios_mutex while
> already holding the BTM.
> 
> tty_throttle and tty_unthrottle are called from
> receive_buf which in turn is called from a lot
> of places. It needs more investigation to prove
> that we never hold the BTM while calling these
> two.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Update: I have verified that this one is not needed
at all, because we never take the BTM/BKL while holding
termios_mutex. This is very helpful and will significantly
simplify things towards the end.

With this patch removed, my patch 13 (ldisc_mutex cleanup)
can potentially be applied again, I still need to check
some corner cases with line disciplines calling
tty_driver_flush_buffer and with v253_open calling tty->ops-write
under BTM+ldisc_mutex.

If no tty driver ever takes or releases the BTM/BKL in
their flush_buffer or write functions, things should be
fine.

	Arnd
