Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0IHAiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:38:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab0IHAhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:37:55 -0400
Date: Tue, 7 Sep 2010 17:35:02 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, Karsten Keil <isdn@linux-pingi.de>,
        linux-kernel@vger.kernel.org
Subject: Re: known vboxgetty/isdn issue in 2.6.35.3?
Message-ID: <20100908003502.GB27719@suse.de>
References: <4C864143.5090803@xs4all.nl> <201009072145.10946.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009072145.10946.arnd@arndb.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 09:45:10PM +0200, Arnd Bergmann wrote:
> On Tuesday 07 September 2010 15:42:27 Udo van den Heuvel wrote:
> > Sep  2 15:00:22 epia klogd: INFO: task vboxgetty:25662 blocked for more
> > than 120 seconds.
> >
> > Sep  2 15:00:22 epia klogd: Call Trace:
> > Sep  2 15:00:22 epia klogd:  [<c1157e3a>] ? tty_unthrottle+0x13/0x3a
> > Sep  2 15:00:22 epia klogd:  [<c1294879>] mutex_lock_nested+0x13e/0x23f
> > Sep  2 15:00:22 epia klogd:  [<c1157e3a>] tty_unthrottle+0x13/0x3a
> 
> It appears that the process deadlocks on tty->termios_mutex.
> 
> > Sep  2 15:00:22 epia klogd:  [<c1294879>] mutex_lock_nested+0x13e/0x23f
> > Sep  2 15:00:22 epia klogd:  [<c1157e3a>] tty_unthrottle+0x13/0x3a
> > Sep  2 15:00:22 epia klogd:  [<c1156a6e>] reset_buffer_flags+0xd4/0xd9
> > Sep  2 15:00:22 epia klogd:  [<c1156a80>] n_tty_flush_buffer+0xd/0x63
> > Sep  2 15:00:22 epia klogd:  [<c11593c7>] tty_ldisc_flush+0x1f/0x34
> > Sep  2 15:00:22 epia klogd:  [<c11d6e28>] isdn_tty_modem_result+0x342/0x37c
> > Sep  2 15:00:22 epia klogd:  [<c1153ff3>] ? tty_wakeup+0x46/0x4e
> > Sep  2 15:00:22 epia klogd:  [<c11d910a>] isdn_tty_modem_hup+0x76/0x176
> > Sep  2 15:00:22 epia klogd:  [<c115824b>] ? set_termios+0x1a8/0x397
> > Sep  2 15:00:22 epia klogd:  [<c129476a>] ? mutex_lock_nested+0x2f/0x23f
> > Sep  2 15:00:22 epia klogd:  [<c11d9b17>] isdn_tty_change_speed+0xa2/0xd4
> > Sep  2 15:00:22 epia klogd:  [<c11d9b86>] isdn_tty_set_termios+0x3d/0x5a
> > Sep  2 15:00:22 epia klogd:  [<c11583bb>] set_termios+0x318/0x397
> > Sep  2 15:00:22 epia klogd:  [<c1158661>] tty_mode_ioctl+0x178/0x2db
> > Sep  2 15:00:22 epia klogd:  [<c1158a06>] ? tty_ldisc_try+0x11/0x38
> > Sep  2 15:00:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
> > Sep  2 15:00:22 epia klogd:  [<c1158908>] n_tty_ioctl_helper+0x144/0x154
> > Sep  2 15:00:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
> > Sep  2 15:00:22 epia klogd:  [<c1155ff9>] n_tty_ioctl+0x97/0xa0
> > Sep  2 15:00:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
> > Sep  2 15:00:22 epia klogd:  [<c11547ed>] tty_ioctl+0x699/0x6d3
> > Sep  2 15:00:22 epia klogd:  [<c1083788>] vfs_ioctl+0x27/0x91
> > Sep  2 15:00:22 epia klogd:  [<c1154154>] ? tty_ioctl+0x0/0x6d3
> > Sep  2 15:00:22 epia klogd:  [<c1083d06>] do_vfs_ioctl+0x467/0x4a5
> > Sep  2 15:00:22 epia klogd:  [<c1205478>] ? __kfree_skb+0x68/0x6b
> > Sep  2 15:00:22 epia klogd:  [<c1205478>] ? __kfree_skb+0x68/0x6b
> > Sep  2 15:00:22 epia klogd:  [<c1209c83>] ? net_tx_action+0x47/0xcc
> > Sep  2 15:00:22 epia klogd:  [<c102262a>] ? __do_softirq+0xc3/0xd2
> > Sep  2 15:00:22 epia klogd:  [<c1083d85>] sys_ioctl+0x41/0x61
> > Sep  2 15:00:22 epia klogd:  [<c1003cb9>] ? do_IRQ+0x74/0x87
> > Sep  2 15:00:22 epia klogd:  [<c1002813>] sysenter_do_call+0x12/0x2d
> 
> This happened when vboxgetty was doing an ioctl on an ISDN tty, apparently
> while the TTY was getting hung up.
> 
> > Sep  2 15:00:22 epia klogd: INFO: lockdep is turned off.
> 
> Enabling CONFIG_LOCKDEP in your .config should provide better
> information if you can reproduce it.
> 
> > Load went to 1.0 and up even while the box was 90%+ idle.
> > Why did this happen?
> 
> When waiting uninterruptible for a mutex, we treat the process as busy,
> even though it is not doing anything. The question is why it is waiting
> for a mutex that should never be held for an extended time.
> 
> > How to debug?
> 
> One thing to check is if there are other processes blocked as well
> that may be holding the mutex.
> 
> Can you send the output of "head -n 20 /proc/*/stack"? If
> CONFIG_LOCKDEP gives you more data, that would be even better.
> 
> Another thing to try is to run 2.6.36-rc3. We just did a major change
> to the locking in the tty subsystem, so if the behavior is different
> there, that may be an explanation.
> 
> I also took Greg and Karten on Cc, they maintain the TTY and ISDN code
> that is involved in the code path in question. Maybe one of them already
> knows the answer.

Hm, nope, I haven't heard of this one.

Can it be tracked down to the specific patch by running 'git bisect'?

thanks,

greg k-h
