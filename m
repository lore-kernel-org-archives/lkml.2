Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab1CWPas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:30:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61088 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab1CWPaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LQenxvtvQybK3DgZKI2LTBd/wA9uxcKtdARyB+uUeqExMS8JSwKtXFpBPfCQiCMoF1
         Z7shK5qBFK1t24F0FYKP6GzMXUNSuz8t0841ogPd2yOnNr/A3p4AbHI64uKGPuHRVTgB
         c9X7RSCJ/etXSsp6yppdXmLgRf/qziNulRXxM=
Subject: Re: [PATH 0/4] Memstick patches for 2.6.39
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com
In-Reply-To: <20110323034202.GC11329@kroah.com>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
	 <1299947013.17988.0.camel@maxim-laptop> <1300219210.13493.0.camel@MAIN>
	 <20110315140402.334cc55c.akpm@linux-foundation.org>
	 <1300590545.15453.3.camel@maxim-laptop>
	 <20110319234701.0eab3744.akpm@linux-foundation.org>
	 <1300621371.15768.11.camel@maxim-laptop>
	 <20110322162108.a4b70291.akpm@linux-foundation.org>
	 <1300841974.3588.4.camel@maxim-laptop>  <20110323034202.GC11329@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 17:30:39 +0200
Message-ID: <1300894239.5791.15.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:42 -0700, Greg KH wrote:
> On Wed, Mar 23, 2011 at 02:59:34AM +0200, Maxim Levitsky wrote:
> > On Tue, 2011-03-22 at 16:21 -0700, Andrew Morton wrote:
> > > On Sun, 20 Mar 2011 13:42:51 +0200
> > > Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > 
> > > > On Sat, 2011-03-19 at 23:47 -0700, Andrew Morton wrote:
> > > > > On Sun, 20 Mar 2011 05:09:05 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > > > 
> > > > 
> > > > ...
> > > >
> > > > Also, I don't have much time now to improve the ms_block driver till
> > > > this summer (studying).
> > > > The driver works. Yes it has a flaw in regard to scatterlist processing,
> > > > because I didn't find a better way to deal with this monster, but I will
> > > > fix that later. I am not the kind of guy that runs away after a merge.
> > > > It would be nice to just see my code in kernel, code I wrote more that a
> > > > year ago.
> > > > 
> > > > This flaw is purely theoretical. Driver does work.
> > > 
> > > Lots of code is "flawed but works".  The place for such code is
> > > drivers/staging/ - it gets put in there so the code is available for
> > > those who need the driver and the code is later moved over into
> > > drivers/ once the flaws have been addressed.
> > > 
> > > So a path forward here would be for us to put the driver and the
> > > sglist extensions into a directory under drivers/staging/.
> > Ok, I won't be fighting with you over this one.
> > 
> > However, I ask for this:
> > 
> > 
> > 1. Please merge r592.c, it doesn't depend on anything.
> 
> What type of driver is that?
A driver for card reader that reads Memstick cards.
Two such drivers from Alex Dubov were already merged.


> 
> > 2. Please review ms_block.c for other problems that might prevent merge.
> > For example when I published the sg list helpers, nobody told me that I
> > am not allowed to add them. Actually the opposite, I was told to put
> > them in scatterlist.c.
> > When I did so, again I was told that I didn't do the kerneldoc comments
> > right, and also was told to improve few of the functions.
> > Now I did all that, and I am told that scatterlist usage in my driver is
> > no-go. OK. But what else is there that you don't like?
> 
> Ick, that's not nice, but formatting issues are usually the easiest to
> pick on, sorry for that happening.

Folk, could you actually review the driver once again, and really tell
me what is wrong with it?
I did another review of it now, and it looks nice and clean.

Let me explain exactly the controversial point:

I get a request from block core to read or write a specific amount of
512 blocks.
I turn that request into scatterlist.

For reads (look at msb_do_read_request), I read one page into first 512
bytes of pages that are pointed by that scatterlist, and then modify it
such as it now shorter and points to next 512 bytes.

For writes, I choose for 2 cases.
If I was told to write whole erase block or more, I create new scatter
list that covers the 'erase block size' bytes of original one and just
write it.

For smaller writes, I have a eraseblock sized cache buffer that I write
to until I ased to write to different erase block. Then I flush current
eraseblock doing copyonwrite.

Basicly the controversy is around my usage of scatterlist.
I just added ability to create a copy of a scatterlistby which will
cover n bytes, and ability to truncate a scatterlist  by removing n
bytes from its head.



> 
> So the result is to use the block layer functions instead, right?  How
> much work do you imagine that would take to do?
I could just stop using scatterlists at all, and just do all
writes/reads 512 bytes a time (using the copy on write cache for writes
of course).
I did that successfully in my sm_ftl.c



> 
> If it's a bunch, care to put the code in drivers/staging/ now?  I'll
> gladly take the patches to queue them up for .40.
> 
> thanks,
> 
> greg k-h

-- 
Best regards,
        Maxim Levitsky

Visit my blog: http://maximlevitsky.wordpress.com
Warning: Above blog contains rants.

