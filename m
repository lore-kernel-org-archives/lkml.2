Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2K1QXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:23:04 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38633 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2K1QXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:23:02 -0500
MIME-Version: 1.0
In-Reply-To: <CAHO5Pa2_D_L6wKPWccaYH2BYWYFc=4Khe0Om5GWU3D-tcAH0OQ@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CAHO5Pa2_D_L6wKPWccaYH2BYWYFc=4Khe0Om5GWU3D-tcAH0OQ@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 28 Nov 2012 17:22:39 +0100
Message-ID: <CAPXgP12jXOJzTTgwQkm7XK_ig2iEKAbhgNkF+MRR6_S49Tqx_A@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 2:33 PM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
> On Thu, May 3, 2012 at 2:29 AM, Kay Sievers <kay@vrfy.org> wrote:
>> From: Kay Sievers <kay@vrfy.org>
> [...]
>>         case SYSLOG_ACTION_SIZE_UNREAD:
>> -               error = log_end - log_start;
>> +               raw_spin_lock_irq(&logbuf_lock);
>> +               if (syslog_seq < log_first_seq) {
>> +                       /* messages are gone, move to first one */
>> +                       syslog_seq = log_first_seq;
>> +                       syslog_idx = log_first_idx;
>> +               }
>> +               if (from_file) {
>> +                       /*
>> +                        * Short-cut for poll(/"proc/kmsg") which simply checks
>> +                        * for pending data, not the size; return the count of
>> +                        * records, not the length.
>> +                        */
>> +                       error = log_next_idx - syslog_idx;
>> +               } else {
>> +                       u64 seq;
>> +                       u32 idx;
>> +
>> +                       error = 0;
>> +                       seq = syslog_seq;
>> +                       idx = syslog_idx;
>> +                       while (seq < log_next_seq) {
>> +                               error += syslog_print_line(idx, NULL, 0);
>> +                               idx = log_next(idx);
>> +                               seq++;
>> +                       }
>> +               }
>> +               raw_spin_unlock_irq(&logbuf_lock);
>>                 break;
> [...]
>
> It looks as though the changes here have broken SYSLOG_ACTION_SIZE_UNREAD.

Any specifics that it causes actual problems we need to address?

> On a 2.6.31 system, immediately after SYSLOG_ACTION_READ_CLEAR, a
> SYSLOG_ACTION_SIZE_UNREAD returns 0.

Hmm, sounds like the right thing to do.

We have read everything, even cleared the buffer for later queries. So
there is nothing to read anymore for later calls, and they will
actually never return anything if they are called, so returning 0 here
sounds like the right thing. The current SYSLOG_ACTION_SIZE_UNREAD
seems to match properly the expectations one can make for
SYSLOG_ACTION_READ_ALL.

> On 3.5, immediately after SYSLOG_ACTION_READ_CLEAR, the value returned
> by SYSLOG_ACTION_SIZE_UNREAD is unchanged
>
> (i.e., assuming that the
> value returned was non-zero before SYSLOG_ACTION_SIZE_UNREAD, it is
> still nonzero afterward), even though a subsequent
> SYSLOG_ACTION_READ_CLEAR indicates that there are zero bytes to read.

Which sounds at least like weird behaviour, if not "broken".

Any indication that we need to restore the old behaviour to fix some
weird assumptions? To me the current one sounds like the better and
more correct option, and what one would expect from it. But maybe we
cannot get away with it ...

(I hope I understood what you explained correctly, I'm a bit confused
by the issue.)


Thanks,
Kay
