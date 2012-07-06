Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab2GFUaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:30:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49140 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2GFUaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120706203825.20ce3e47@pyramind.ukuu.org.uk>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
 <20120706203825.20ce3e47@pyramind.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jul 2012 13:30:01 -0700
X-Google-Sender-Auth: vJCMw-b934ffUDcUQ1N8ejOpruE
Message-ID: <CA+55aFy7RncR_z9M+DRzSXJY7cWxY9zG0ioLdiefhxkH__Z7Yw@mail.gmail.com>
Subject: Re: Regression - /proc/kmsg does not (always) block for 1-byte reads
To: Kay Sievers <kay@vrfy.org>, Greg Kroah-Hartman <greg@kroah.com>
Cc: Jukka Ollila <jiiksteri@gmail.com>, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay, this needs to be fixed.

Suggested fix: just use the 'seq_printf()' interfaces, which do the
proper buffering, and allow any size reads of various packetized data.

Of course, I'd also suggest that whoever was the genius who thought it
was a good idea to read things ONE F*CKING BYTE AT A TIME with system
calls for each byte should be retroactively aborted. Who the f*ck does
idiotic things like that? How did they noty die as babies, considering
that they were likely too stupid to find a tit to suck on?

                 Linus

On Fri, Jul 6, 2012 at 12:38 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 6 Jul 2012 20:45:44 +0300
> Jukka Ollila <jiiksteri@gmail.com> wrote:
>
>> Hello,
>>
>> A few days ago I filed a kernel regression report concerning a change
>> in /proc/kmsg behaviour with short reads:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=44211
>>
>> The comments suggest that this is probably intentional, but that it
>> would be best make sure that the current semantics wrt short reads are
>> as intended.
>>
>> The problem appears on a Debian (unstable) system that drains
>> /proc/kmsg into a separate fifo read by klogd(8):
>>
>> /bin/dd bs=1 if=/proc/kmsg  of=/var/run/klogd/kmsg
>>
>> With the recent kernel logging changes this /bin/dd exits immediately,
>> as 1-byte reads are shorter than any log message could possibly be and
>> read() returns 0. No dd feeding the fifo results in no logging and a
>> rather unhappy klogd on the reading end of /var/run/klogd/kmsg.
>>
>> I suppose a safe solution is to only do reads that are big enough for
>> any single kernel message, but this is still a change that affects
>> user space being shipped, so some might find it surprising.
>>
>> I don't know what other distros do. Is it just Debian being the odd one out?
>
> If this is observed on an actual standard distro userspace and breaks it
> then its a regression and it needs fixing or reverting.
>
> Cc'ing Linus
