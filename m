Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148Ab0FJR0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:26:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498Ab0FJR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:26:14 -0400
MIME-Version: 1.0
Date: Thu, 10 Jun 2010 10:25:36 -0700
Message-ID: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
Subject: Slow pty's (was Re: libdivecomputer interfaces?)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Alan, Hirofumi-san,

 I thought we long since (ie back last fall) fixed the latency
problems with pty's, but there does seem to be something very fishy
going on there still.

On Thu, Jun 10, 2010 at 8:01 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>On Sat, May 29, 2010 at 12:53 PM, Jef Driesen <jefdriesen@telenet.be> wrote
>> BTW, now that I have your attention, could you maybe help me with a linux
>> kernel problem I'm experiencing in this area? I reported the problem on LKML
>> but got no response:
>>
>> http://www.divesoftware.org/libdc/simulator.html
>> http://groups.google.com/group/linux.kernel/browse_thread/thread/5a2b00e35b0864a7
>
> [ Hmm.. Testing.. ]
>
> Yeah, it's slow. Your test thing takes one and a quarter minutes for
> me. That's ridiculous.
>
> And no, we shouldn't need the low-latency flag, we're supposed to do
> this all automatically correctly. I'll talk to the tty people.

This is clearly not a regression (it's been going on forever, I
suspect), but taking over a minute to transfer just over half a MB of
data over a pty seems crazy.

Maybe it's not a kernel problem, and it's something done wrong by
rx/sx/socat, I haven't looked at what they do. But since setting
low_latency apparently helps (I didn't test that part, but I did test
"ridiculously slow"), it sounds very much like something is still
wrong in the kernel unless there is some really subtle timing issue in
user space.

>From Jef's original lkml report linked to above:

> You can reproduce the problem by running these commands in three
> different terminals:
>
> # Terminal 1: Setup the pty's.
> socat PTY,link=/tmp/ttyS0 PTY,link=/tmp/ttyS1
> # Terminal 2: Send some data.
> dd if=/dev/urandom of=input.bin bs=538368 count=1
> sx input.bin >>/tmp/ttyS0 </tmp/ttyS0
> # Terminal 2: Receive the data data.
> time rx output.bin >/tmp/ttyS1 </tmp/ttyS1

and yeah, it's pretty clear to see. A "perf report" on that receiving
side just shows queue_delayed_work_on(), but that doesn't mean much.
It's clearly just sleeping all the time...

Any ideas?

                     Linus
