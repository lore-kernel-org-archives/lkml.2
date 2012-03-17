Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946101Ab2CQATA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 20:19:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49994 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031820Ab2CQAS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 20:18:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper is not yet available
Date: Sat, 17 Mar 2012 01:23:10 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203162357.10770.rjw@sisk.pl> <CA+55aFwTZjLHvZLBuNG-aO-+ex_yTYfaqOGqQ+6Krx9Z7EUNQQ@mail.gmail.com>
In-Reply-To: <CA+55aFwTZjLHvZLBuNG-aO-+ex_yTYfaqOGqQ+6Krx9Z7EUNQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203170123.10599.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 17, 2012, Linus Torvalds wrote:
> On Fri, Mar 16, 2012 at 3:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > +       if (nowait) {
> > +               int limit = loading_timeout * MSEC_PER_SEC;
> > +               int timeout = 10;  /* in msec */
> > +
> > +               while (usermodehelper_is_disabled()) {
> > +                       read_unlock_usermodehelper();
> > +
> > +                       msleep(timeout);
> 
> Ugh, this is disgusting.
> 
> The whole point of nowait was that it's not synchronous - so it should
> just be driven by timers, not some kind of random "while sleep" loop.
> 
> And that fw thing already does have a timeout associated with it, and
> quite frankly, the *sane* approach is to do all this not in
> _request_firmware(), but in request_firmware_work_func() - never even
> call _request_firmware() in the first place if the system isn't ready,
> just reset the timeout to retry it again later.
> 
> Seriously. The rule should be really simple: nothing should *ever*
> call "request_firmware()" (or the _request_firmware() helper function)
> while the system is not up. That WARN_ON() should remain totally and
> utterly unconditional, and it should *not* be conditional on "nowait"
> or any idiotic crappy hack like that.
> 
> If there is an asynchronous thread - and there is, for the _nowait()
> case - that asynchronous thread should set up the timer and retry in
> ten seconds or whatever. It should *not* call 'request_firmware()" and
> expect that to do something special.

OK, but that asynchronous thread needs to know whether or not the system is up.

It can use the usermodehelper_is_disabled() check, but that needs to be done
under read_lock_usermodehelper() and it can't release the lock before
calling _request_firmware(), or all that thing would be racy.  If it doesn't
release the lock, then _request_firmware() will take it again, reentrantly,
which isn't nice.  So, it looks like it has to use a different check.

I was pondering a suspend/resume notifier that would block either
request_firmware_work_func() (possibly with a timeout), if system suspend is
in progress, or system suspend, if _request_firmware() is in progress,
but that wouldn't cover the initialization case.

Thanks,
Rafael
