Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab0KVXAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 18:00:15 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58686 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932166Ab0KVXAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 18:00:13 -0500
Subject: Re: What should poll() return when a device is unregistered ? (was
 "media: Media device node support")
From: Andy Walls <awalls@md.metrocast.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Jonathan Corbet <corbet@lwn.net>,
        linux-media@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <201011221719.38369.laurent.pinchart@ideasonboard.com>
References: <1285241696-16826-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <201011221236.40194.hverkuil@xs4all.nl>
	 <1290430297.2092.16.camel@morgan.silverblock.net>
	 <201011221719.38369.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 18:00:42 -0500
Message-ID: <1290466842.7620.38.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-11-22_10:2010-11-22,2010-11-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1011220177
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 17:19 +0100, Laurent Pinchart wrote:
> Hi Andy,
> 
> On Monday 22 November 2010 13:51:37 Andy Walls wrote:
> > On Mon, 2010-11-22 at 12:36 +0100, Hans Verkuil wrote:
> > > On Monday, November 22, 2010 11:41:27 Laurent Pinchart wrote:
> > > > Hi Hans,
> > > > 
> > > > On Monday 22 November 2010 10:08:06 Hans Verkuil wrote:
> > > > > On Monday, November 22, 2010 00:35:54 Laurent Pinchart wrote:
> > > > > > Hi Jonathan,
> > > > > 
> > > > > This doesn't really seem to be standardized :-(
> > > > 
> > > > CC'ing LKML with the question.
> > > > 
> > > > POLLERR | POLLHUP and POLLERR won't make a difference to select(), but
> > > > we should still standardize on a poll() return code when devices are
> > > > unregistered and/or - for hot-pluggable devices - disconnected (for
> > > > V4L devices unregistered usually means disconnected) ?
> > > 
> > > Drivers return POLLERR, POLLERR|POLLHUP or POLLHUP in case of a
> > > disconnect. I'm leaning towards POLLHUP as the most appropriate poll
> > > return value for a USB disconnect.
> > 
> > +1 POLLHUP
> > 
> > http://www.opengroup.org/onlinepubs/009695399/functions/poll.html
> > 
> > "POLLHUP
> >         The device has been disconnected. [...]"
> > 
> > 
> > My $0.02 below:
> > The communication link with the device is closed due to circumstances
> > that the OS considers normal operation.  The OS has, at some level, shut
> > down its side of the communication link gracefully as well.
> > 
> > Just because the application or the OS cannot always predict when a USB
> > disconnect may happen, doesn't mean it is an error.
> 
> POLLHUP seems to be the best option standard-wise, but it could be a problem 
> for output devices. Applications use the write file descriptors set with 
> select() to wait for a buffer to be ready. Unlike POLLERR, POLLHUP only 
> reports an event on the read file descriptors set.

After looking at the OpenGroup IEEE Std 1003.1-2004 spec for both
select() and poll(), I can say that select() not indicating an fd (with
POLLHUP status set) is ready for writing is

a. in compliance with the standard

b. likely inspired by the behavior specified for poll() in the standard

c. is overly restrictive given the language in the standard for
select().  select() could return that the fd is writeable, and be in
standards compliance, so long as the next call to an output function on
the fd does not block:

        "A descriptor shall be considered ready for writing when a call
        to an output function with O_NONBLOCK clear would not block,
        whether or not the function would transfer data successfully."
        
d. select() could also indicate an exceptional condition on an fd (with
POLLHUP status set) and still be in standards compliance:

        "[except for sockets], what constitutes an exceptional condition
        is file type-specific."


Despite that research, I'm guessing that the likelihood of consensus for
changing the kernel select()'s behavior for POLLHUP is low.


So I guess one should do something that satisfies both poll() and
select() to induce applications to take the correct action.

POLLHUP|POLLERR, as you had suggested, will probably have the desired
effect:

1. applications that use poll() will be slightly misinformed with the
indication of an error.  However, I'll *speculate* that applications
that have different courses of action for POLLHUP vs. POLLERR, will
prioritize POLLHUP handling over POLLERR handling anyway.

2. applications that use select(), with the fd only in the write_fds
set, will wake up upon the exception condition of a device disconnect
without the fd being in the except_fds set (since that would be useless
anyway in Linux in this case).

For standards compliance -- in at least the case of select() -- the next
call to read(), write(), ioctl( , VIDIOC_DQBUF, ), and ( ,
VIDIOC_QBUF, ) should return EOF or an error with errno set properly.
(If I understand the standard correctly.)

The only trouble will come from applications that use select() and don't
check the return value from the next read(), write(), or ioctl().  I
would hope that such applications are not in widespread use.

Regards,
Andy

