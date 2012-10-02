Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2JBWXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:23:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56340 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754230Ab2JBWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:23:35 -0400
X-Sasl-enc: txmd2b0zkyCzRAV8SBv9MIsB6tiYFaKwWE9lc/hTQwGo 1349216614
Date: Tue, 2 Oct 2012 15:23:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay@vrfy.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-ID: <20121002222333.GA32207@kroah.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com>
 <4FE8B8BC.3020702@iki.fi>
 <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com>
 <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com>
 <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002221239.GA30990@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 03:12:39PM -0700, Greg KH wrote:
> On Tue, Oct 02, 2012 at 09:33:03AM -0700, Linus Torvalds wrote:
> > I don't know where the problem started in udev, but the report I saw
> > was that udev175 was fine, and udev182 was broken, and would deadlock
> > if module_init() did a request_firmware(). That kind of nested
> > behavior is absolutely *required* to work, in order to not cause
> > idiotic problems for the kernel for no good reason.
> > 
> > What kind of insane udev maintainership do we have? And can we fix it?
> > 
> > Greg, I think you need to step up here too. You were the one who let
> > udev go. If the new maintainers are causing problems, they need to be
> > fixed some way.
> 
> I've talked about this with Kay in the past (Plumbers conference I
> think) and I thought he said it was all fixed in the latest version of
> udev so there shouldn't be any problems anymore with this.
> 
> Mauro, what version of udev are you using that is still showing this
> issue?
> 
> Kay, didn't you resolve this already?  If not, what was the reason why?

Hm, in digging through the udev tree, the only change I found was this
one:

commit 39177382a4f92a834b568d6ae5d750eb2a5a86f9
Author: Kay Sievers <kay@vrfy.org>
Date:   Thu Jul 19 12:32:24 2012 +0200

    udev: firmware - do not cancel requests in the initrd

diff --git a/src/udev/udev-builtin-firmware.c b/src/udev/udev-builtin-firmware.c
index 56dc8fc..de93d7b 100644
--- a/src/udev/udev-builtin-firmware.c
+++ b/src/udev/udev-builtin-firmware.c
@@ -129,7 +129,13 @@ static int builtin_firmware(struct udev_device *dev, int argc, char *argv[], boo
                                 err = -errno;
                 } while (err == -ENOENT);
                 rc = EXIT_FAILURE;
-                set_loading(udev, loadpath, "-1");
+                /*
+                 * Do not cancel the request in the initrd, the real root might have
+                 * the firmware file and the 'coldplug' run in the real root will find
+                 * this pending request and fulfill or cancel it.
+                 * */
+                if (!in_initrd())
+                        set_loading(udev, loadpath, "-1");
                 goto exit;
         }
 

which went into udev release 187 which I think corresponds to the place
when people started having problems, right Mauro?

If so, Mauro, is the solution just putting the firmware into the initrd?
No wait, it looks like this change was trying to fix the problem where
firmware files were not in the initrd, so it would stick around for the
real root to show up so that they could be loaded.  So this looks like
it was fixing firmware loading problems for people?

Kay, am I just looking at the totally wrong place here, and this file in
udev didn't have anything to do with the breakage?

thanks,

greg k-h
