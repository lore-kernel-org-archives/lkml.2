Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab2GHMh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 08:37:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47726 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2GHMhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 08:37:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120706175501.GA11908@kroah.com>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
 <20120706175501.GA11908@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 8 Jul 2012 14:37:03 +0200
Message-ID: <CAPXgP11Om4T-U6e-uZVYsV0FcJtkgnMfa+v94R46v=xdbhm77w@mail.gmail.com>
Subject: Re: Bug 44211 - /proc/kmsg does not (always) block for 1-byte reads
To: Greg KH <greg@kroah.com>
Cc: Jukka Ollila <jiiksteri@gmail.com>, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 7:55 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Jul 06, 2012 at 08:45:44PM +0300, Jukka Ollila wrote:
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
> I think we just fixed this, what kernel version are you seeing this
> problem on?
>
> Kay did your other patches that I just accepted resolve this?

No, it's not fixed. We avoided the delivery of partial messages to
userspace, which obviously does not got too well with 1-byte reads. :)

I posted a patch in the other thread:
  https://lkml.org/lkml/2012/7/7/118

Side note:
The patch will not fix the underlying problem, but just make it behave
more like it was and allow partial message reads. This is a years old
problem, the net is full of bugreports of stuff going wrong with
running dd bs=1 on /proc/kmsg. It is a really stupid idea, and can not
work for many other reasons too. The interface can not safely be used
that way, it does not have the usual semantics, it always returned 0
for read() whenever it needed to.

Thanks,
Kay
