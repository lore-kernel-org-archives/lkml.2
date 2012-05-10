Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab2EJUii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:38:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65248 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2EJUig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:38:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120510201409.GA6467@thunk.org>
References: <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
 <20120509070710.GA29981@gmail.com> <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
 <1336611278.728.9.camel@mop> <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
 <1336667984.947.24.camel@mop> <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
 <1336676986.947.47.camel@mop> <20120510201409.GA6467@thunk.org>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 10 May 2012 22:38:14 +0200
Message-ID: <CAPXgP10heqP-=F1VBzoWpWXDLZmavTAD7t0XRTZi=ez+pPvDKg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: "Ted Ts'o" <tytso@mit.edu>, Kay Sievers <kay@vrfy.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:14 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, May 10, 2012 at 09:09:46PM +0200, Kay Sievers wrote:
>> We fully isolate continuation users from non-continuation users. If a
>> continuation user gets interrupted by an ordinary non-continuation
>> user, we will not touch the continuation buffer, we just emit the
>> ordinary message. When the same thread comes back and continues its
>> printing, we still append to the earlier buffer we stored.
>
> It's not necessarily a matter of "thread comes back", although that
> situation can happen too.  You can get this situation quite simply if
> you have two processes in foreground kernel mode on two different
> CPU's sending continuation printk's at the same time.

The access to printk is fully serialized. If only one thread does
continuation (needs buffering), it will still own the continuation
buffer. We record the "owner" (pointer to the task) of the data.

>> We will also never wrongly merge two racing continuation users into one
>> line.
>
> I'm not sure how you guarantee this?  The only way you *could*
> guarantee this is if you used a continuation buffer in the task_struct
> for foreground kernel code, and a per-CPU continuation buffer for
> interrupt code.

Yeah adding it to struct task would reliably work. :) But as we record
the "owner" of the continuation buffer, we should be able to flush the
content of the earlier buffer, instead of wrongly merging it. The same
struct task and interrupts could go wrong, that's true.

>> Buffered line will be joined, when the same thread emits a printk()
>> without any KERN_* or with KERN_CONT.
>
> Is there any difference in any of the cases in terms of how printk's
> that are prefixed with KERN_CONT versus a printk that does not have
> any KERN_* prefix?  If so, is there value in keeping KERN_CONT?

Yeah, it is. It will instruct to merge with the buffer, but also tell
not the parse the prefix, in case you want to log stuff like "<7>" as
real data and not as a prefix.

Kay
