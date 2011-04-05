Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1DENEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:04:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab1DENEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:04:36 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=6MGA-aeKMwUA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=iNHYrj3rPUzBwki-vXEA:9 a=QEXdDO2ut3YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: locks inside receive_buf
From: Steven Rostedt <rostedt@goodmis.org>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTik5MGz9YgU0oh30ZUesv+c3QEB+rA@mail.gmail.com>
References: <AANLkTi=FrmB=u09wvLoXzQstnV3h-U58R728t3k6_-B-@mail.gmail.com>
	 <20110331112559.090948a7@lxorguk.ukuu.org.uk>
	 <AANLkTimyVsoRYqoXWYMQz_AN3Uo31NBifmiwDUijWnvS@mail.gmail.com>
	 <20110331143329.GA14441@home.goodmis.org>
	 <AANLkTi=orUZrXHQSYXdrOWTJ35vd+41BKD5Crx16n4B1@mail.gmail.com>
	 <1301665592.2160.19.camel@gandalf.stny.rr.com>
	 <BANLkTik5MGz9YgU0oh30ZUesv+c3QEB+rA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 09:04:31 -0400
Message-ID: <1302008671.17430.10.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 16:43 +0530, Pavan Savoy wrote:

> > The program counter is at st_int_recv+0x2a0 when this happened, so that
> > function is probably where you accessed some structure that was not
> > initialized.
> >
> >        foo->bar
> >
> > if foo is NULL, you'll get that error.
> >
> >> LR is at schedule+0x414/0x4e8
> >
> > LR is Link Register, or where this function was called from.
> >
> > Now why is the scheduler calling your function, I have no idea.
> 
> Well this is exactly the problem I have and hence the question
> regarding sleep in tty's receive_buf function.
> 
> the function called st_recv or st_int_recv() is basically my line
> discipline's receive_buf function - which happens like zillions of
> times properly with tty->disc_data being populated with what I
> need....
> 
> However on a corner case - when I perform some operation - which has
> absolutely NO relation to TTY (at most may be console is using 1 uart)
> - Everything breaks loose...

Well, if this corner case that you perform causes the corruption, I
think they are related. What corner case do you do?

> 
> If I bump into a NULL pointer it is because the tty->disc_data is NULL ....
> However my check for tty->disc_data being NULL also is fine - i.e when
> I do get this error - my disc_data is NOT null ... But not sure what
> (which data) is NULL ??

How are you checking for NULL?

	if (data == NULL)

may not work as the error shows:

"Unable to handle kernel NULL pointer dereference at virtual address 0000001a"

Where data (or what ever it was using) was 0x1a not 0. We consider NULL
anything less that a page size. Because of something just like this. You
have a structure pointer that is NULL, accessing the element may not be
NULL.

> 
> So now back to the question - What cannot I do inside tty's receive_buf ?

I don't know, but it may not be the issue. Something else may be broken.

Perhaps you can't schedule, which means you can't use something like a
mutex. But if that was the issue, the scheduler itself would give you a
nasty warning that you are scheduling in non-schedulable context.

-- Steve


