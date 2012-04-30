Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab2D3GzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 02:55:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53753 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab2D3GzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 02:55:11 -0400
X-Sasl-enc: TVtUTYitdAkCCdk+cvFAqnG98o5/rHnqAgI9JsLHhtAtA1cNNTn43Z5Eqg 1335768910
Message-ID: <1335768906.2281.16.camel@perseus.themaw.net>
Subject: Re: autofs: make the autofsv5 packet file descriptor use a
 packetized pipe
From: Ian Kent <raven@themaw.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Meyer <thomas@m3y3r.de>,
        autofs@vger.kernel.org
Date: Mon, 30 Apr 2012 14:55:06 +0800
In-Reply-To: <4F9E3474.2050405@msgid.tls.msk.ru>
References: <20120429205429.63CCD7C0064@ra.kernel.org>
	 <4F9DD994.70202@zytor.com> <4F9E30BF.4030704@msgid.tls.msk.ru>
	 <4F9E3474.2050405@msgid.tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-30 at 10:43 +0400, Michael Tokarev wrote:
> On 30.04.2012 10:27, Michael Tokarev wrote:
> >> On 04/29/2012 01:54 PM, Linux Kernel Mailing List wrote:
> >>>     However, a prettier solution exists now thanks to the packetized pipe
> >>>     mode.  By marking the communication pipe as being packetized (by simply
> >>>     setting the O_DIRECT flag), we can always just write the bigger packet
> >>>     size, and if user-space does a smaller read, it will just get that
> >>>     partial end result and the extra alignment padding will simply be thrown
> >>>     away.
> > 
> >> +static inline int autofs_prepare_pipe(struct file *pipe)
> >> +{
> >> +	if (!pipe->f_op || !pipe->f_op->write)
> >> +		return -EINVAL;
> >> +	if (!S_ISFIFO(pipe->f_dentry->d_inode->i_mode))
> >> +		return -EINVAL;
> >> +	/* We want a packet pipe */
> >> +	pipe->f_flags |= O_DIRECT;
> >> +	return 0;
> >> +}
> >> +
> > 
> > @@ -376,7 +376,7 @@ static int autofs_dev_ioctl_setpipefd(st
> >  			err = -EBADF;
> >  			goto out;
> >  		}
> > -		if (!pipe->f_op || !pipe->f_op->write) {
> > +		if (autofs_prepare_pipe(pipe) < 0) {
> >  			err = -EPIPE;
> >  			fput(pipe);
> >  			goto out;
> > 
> > I've one more concern.  I'm not sure but I think there's some
> > risk still.  This packetizing gets applied to all VERSIONS of
> > the autofs PROTOCOL.  Which means it will be applied to the
> > lowest supported version (3) TOO, but did that version read
> > whole packets too?
> 
> I think this is a false alarm.  I checked autofs v3 and v4
> userspace code (found on  http://www.kernel.org/pub/linux/daemons/autofs )
> and they both read whole packet at once, not piece-wise.
> 
> I didn't test if any of these actually work with any current
> kernel, however ;)

Yep, all the autofs releases use a sizeof() the relevant structure when
reading the kernel pipe, so that should be ok.

Ian


