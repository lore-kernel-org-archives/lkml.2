Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576Ab0FKVDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:03:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47077 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760526Ab0FKVDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rqA1KnVByeac0ugjhoKRl3YL1Zgf+lGMgF7IHLxBmORGuiuyCOmtWi2VZNTHt4J9Nt
         3kAe9TtPSHE2YKIZBb5meAuJXgOygaYXTea+MZ4KWLo9s9tqMvhGUuB0GQZLxMYO3KQo
         ZtOuCHdUPnQ09mibwCi6ciOtQPTP01ZGKgE54=
Subject: Re: [linux-pm] [PATCH] Fix the outstanding issue with hangs on
 insert/removal of mmc cards
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>
In-Reply-To: <Pine.LNX.4.44L0.1006111648590.19894-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1006111648590.19894-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Jun 2010 00:03:31 +0300
Message-ID: <1276290211.2651.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 17:00 -0400, Alan Stern wrote: 
> On Fri, 11 Jun 2010, Maxim Levitsky wrote:
> 
> > Hi,
> > 
> > After thinking a lot about how to fix properly the hangs caused by
> > insert/removal of mmc card during suspend/resume, and default behavior
> > of not trusting the card persistence over suspend, I finally come to
> > conclusion that changing the del_gendisk is wrong.
> > 
> > First of all there are 2 types of removal possible. First one happens
> > when system detects that some device is gone. At that point there is
> > really no point in syncing it.
> > 
> > The other type of removal is controlled removal, usually on user
> > request. Surly we must sync the device of this request.
> > This type of removal _shouldn't_ happen during suspend/resume
> > transaction. The only case when it does is today to protect against user
> > carelessness of switching the cards during suspend.
> 
> There are other pathological cases which can cause it to happen, but 
> they are pretty unlikely.
> 
> > I think that it is just wrong to sync the device in suspend/resume time.
> > At that time userspace is frozen, but also its not known which drivers
> > are still running. They might even suspend asynchronously...
> > So, such cases should be moved to pm-notifier, thing that my patch does
> > for mmc.
> > Other users should be fixed as well.
> > 
> > We can, in addition to that, add a temporary hack to del_gendisk with
> > loud WARN_ON though.
> > 
> > If card is really removed during suspend, then we can just introduce
> > del_gendisk_dead or something like that which will be safe to call
> > during suspend.
> > 
> > I didn't do that but rather I made the card detection thread freezeable,
> > thus eliminated the whole problem.
> > If you remove the card during suspend, system will notice at end of
> > resume.
> 
> I don't know why the mmc subsystem works differently from USB.  In USB,
> the equivalent of UNSAFE_RESUME is a per-device flag that can be
> controlled via sysfs (see Documentation/usb/persist.txt).  And it
> almost always defaults to ON, i.e., the kernel assumes that if a device
> is present before suspend and after resume it is the same device --
> although some checking is done to try to verify this (the descriptors
> have to remain the same).  We started out being more cautious (the
> default was OFF), but Linus complained about it being _too_ cautious.
I will be very happy to see the description and default value of 
MMC_UNSAFE_RESUME changed.

This patch fixes both cases.

> 
> And like you have done here, in USB the kernel thread that handles
> registering and unregistering devices is freezable, so things never get
> added or removed at an unsafe time.
Very nice!

Best regards,
Maxim Levitsky

