Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab2K1Ndj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:33:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54413 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab2K1Ndg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:33:36 -0500
MIME-Version: 1.0
In-Reply-To: <1336004953.4240.9.camel@mop>
References: <1336004953.4240.9.camel@mop>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 28 Nov 2012 14:33:14 +0100
X-Google-Sender-Auth: UErhEWhGAvZ5JRKaFM1qjh7Mva8
Message-ID: <CAHO5Pa2_D_L6wKPWccaYH2BYWYFc=4Khe0Om5GWU3D-tcAH0OQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

On Thu, May 3, 2012 at 2:29 AM, Kay Sievers <kay@vrfy.org> wrote:
> From: Kay Sievers <kay@vrfy.org>
[...]
>         case SYSLOG_ACTION_SIZE_UNREAD:
> -               error = log_end - log_start;
> +               raw_spin_lock_irq(&logbuf_lock);
> +               if (syslog_seq < log_first_seq) {
> +                       /* messages are gone, move to first one */
> +                       syslog_seq = log_first_seq;
> +                       syslog_idx = log_first_idx;
> +               }
> +               if (from_file) {
> +                       /*
> +                        * Short-cut for poll(/"proc/kmsg") which simply checks
> +                        * for pending data, not the size; return the count of
> +                        * records, not the length.
> +                        */
> +                       error = log_next_idx - syslog_idx;
> +               } else {
> +                       u64 seq;
> +                       u32 idx;
> +
> +                       error = 0;
> +                       seq = syslog_seq;
> +                       idx = syslog_idx;
> +                       while (seq < log_next_seq) {
> +                               error += syslog_print_line(idx, NULL, 0);
> +                               idx = log_next(idx);
> +                               seq++;
> +                       }
> +               }
> +               raw_spin_unlock_irq(&logbuf_lock);
>                 break;
[...]

It looks as though the changes here have broken SYSLOG_ACTION_SIZE_UNREAD.

On a 2.6.31 system, immediately after SYSLOG_ACTION_READ_CLEAR, a
SYSLOG_ACTION_SIZE_UNREAD returns 0.

On 3.5, immediately after SYSLOG_ACTION_READ_CLEAR, the value returned
by SYSLOG_ACTION_SIZE_UNREAD is unchanged (i.e., assuming that the
value returned was non-zero before SYSLOG_ACTION_SIZE_UNREAD, it is
still nonzero afterward), even though a subsequent
SYSLOG_ACTION_READ_CLEAR indicates that there are zero bytes to read.

(All tests conducted with (r)syslogd stopped.)

Cheers,

Michael


-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
