Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2IXOOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:14:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57570 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2IXOOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:14:46 -0400
Date: Mon, 24 Sep 2012 18:14:41 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120924141441.GD16532@moon>
References: <20120913135131.5b251797@pyramind.ukuu.org.uk>
 <20120913125401.GK19956@moon>
 <20120913172507.5039e3c6@pyramind.ukuu.org.uk>
 <20120922180639.GC11610@moon>
 <20120922200731.GD14004@kroah.com>
 <20120922201144.GD11610@moon>
 <20120922215232.GA25778@moon>
 <20120923010953.GA17663@kroah.com>
 <20120923064007.GA2994@moon>
 <34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2012 at 07:46:24AM -0700, H. Peter Anvin wrote:
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> >On Sat, Sep 22, 2012 at 06:09:53PM -0700, Greg Kroah-Hartman wrote:
> >> On Sun, Sep 23, 2012 at 01:52:32AM +0400, Cyrill Gorcunov wrote:
> >> > On Sun, Sep 23, 2012 at 12:11:44AM +0400, Cyrill Gorcunov wrote:
> >> > >
> >> > > > Sysfs is one value per file, you have three values here, please
> >make 3
> >> > > > files.
> >> > > > 
> >> > > > And document them in Documentation/ABI/.
> >> > > 
> >> > > Hmm, sure Greg, I'll update. Thanks!
> >> > 
> >> > Something like below I suppose? Look, if there will be no complains
> >> > on tech aspects on the patch (locking and tty refs) -- I'll update
> >> > Documentation. Just want be sure I've made no mistakes here.
> >> > 
> >> > Another question -- would not it be worth to wrap code with
> >> > CONFIG_CHECKPOINT_RESTORE?
> >> 
> >> Alan's point stands, what's the use of this if it can instantly
> >> change after you read the value?
> >
> >We use it when we do a checkpoint, ie when tasks are stopped. I think
> >it's close to data obtained from procfs (ie valid once you read it but can
> >be changed right after that operation). Maybe I should put everything to
> >procfs, or stick back with ioctl calls?
> 
> The problem as I see it is that you don't know if your process is the lock holder.

Guys, after being trying sysfs approach I think ioctls is a bit better, because
it requires only local changes not propagated to devpts, also this calls are
allowed via file descriptor owner only.

Actually I thought what if extend existing set-(lock,packet-mode,exclusive)
calls to return previous state of appropriate variable, but this will break
abi so i had to refuse this idea.

As to Alan's point on "what's the use of this if it can instantly change
after you read the value" I guess it's the same as what we have when we
simply set the value. Imagine we have two tasks fork'ed, first task do
lock the pty while another task does unlock it immediately after that,
as far as I see there is nothing preventing user space to do that, thus
first task will think it has locked the peer while in real the peer remains
unlocked. Same here with reading this value -- it's valid once read but
can be changed right after. Isn't it?
