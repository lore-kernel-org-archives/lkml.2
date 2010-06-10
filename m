Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607Ab0FJSHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:07:16 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:45925 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab0FJSHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:07:14 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org
Subject: Re: Slow pty's (was Re: libdivecomputer interfaces?)
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
Date: Fri, 11 Jun 2010 03:07:05 +0900
In-Reply-To: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 10 Jun 2010 10:25:36 -0700")
Message-ID: <87typan4mu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>>From Jef's original lkml report linked to above:
>
>> You can reproduce the problem by running these commands in three
>> different terminals:
>>
>> # Terminal 1: Setup the pty's.
>> socat PTY,link=/tmp/ttyS0 PTY,link=/tmp/ttyS1
>> # Terminal 2: Send some data.
>> dd if=/dev/urandom of=input.bin bs=538368 count=1
>> sx input.bin >>/tmp/ttyS0 </tmp/ttyS0
>> # Terminal 2: Receive the data data.
>> time rx output.bin >/tmp/ttyS1 </tmp/ttyS1
>
> and yeah, it's pretty clear to see. A "perf report" on that receiving
> side just shows queue_delayed_work_on(), but that doesn't mean much.
> It's clearly just sleeping all the time...

I'm not reading all of this thread yet, so sorry if I'm missing the
point of this thread.

FWIW, I remember there was the unnecessary waiting related to background
flusher.  It was in input_available_p().  I'm not sure at all whether
this is related to the problem, and totally untested patch (this patch
calls tty_flush_to_ldisc() only when data is unavailable). Someone can
test the following or something (is there any change)?

Well, anyway, I'll read this thread at this weekend, and will see if
someone didn't already fix it.


I.e. the following or something,

static inline int input_available_p(struct tty_struct *tty, int amt)
{
	int try = 0;

retry:
	if (tty->icanon) {
		if (tty->canon_data)
			return 1;
	} else if (tty->read_cnt >= (amt ? amt : 1))
		return 1;

	if (!checked) {
		tty_flush_to_ldisc(tty);
		try = 1;
		goto retry;
	}

	return 0;
}

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
