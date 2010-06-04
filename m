Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0FDPTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:19:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55989 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0FDPTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cQOegh+1co1ZWBTiWH5BuHZjjC32b4fC2Qy4bgup4KgJkvIXLXuOT7tt9SOnzV+9Yk
         qLSNvehCfG98HEoBQeu9toFCYRx1qCCx028LfljM1dPiXPnpiEVDP3VoFzVynU4fsU/z
         hFhjHUCpJqXl3/XNxVQqcx+KT726ABZE40jqo=
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.1006041052570.1794-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1006041052570.1794-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 18:19:38 +0300
Message-ID: <1275664778.4596.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 10:59 -0400, Alan Stern wrote: 
> On Fri, 4 Jun 2010, Maxim Levitsky wrote:
> 
> > On Thu, 2010-03-04 at 14:53 +0100, Pavel Machek wrote: 
> > > Hi!
> > > 
> > > > > journalling assumptions broken: commit block is there, but previous
> > > > > blocks are not intact. Data loss.
> > > > > 
> > > > > ...and that was the first I could think about. Lets not do
> > > > >  this. Barriers were invented for a reason.
> > > > 
> > > > Very well.  Then we still need a solution to the original problem:  
> > > > Devices sometimes need to be unregistered during resume, but
> > > > del_gendisk() blocks on the writeback thread, which is frozen until
> > > > after the resume finishes.  How do you suggest this be fixed?
> > > 
> > > Avoid unregistering device during resume. Instead, return errors until
> > > resume is done and you can call del_gendisk? 
> > 
> > This won't help ether. The same driver needs to unregister perfectly
> > working device on suspend, because the user might replace the card
> > during suspend and fool the os.
> > There is a setting, CONFIG_MMC_UNSAFE_RESUME and I use it, but it isn't
> > default.
> 
> People have generally agreed that the best answer is to have 
> del_gendisk always thaw the writeback thread.
Now the question is how to do that? :-)

Best regards,
Maxim Levitsky

> 
> > Anyway to revive that old thread, how about introducing new
> > del_gendisk_no_sync?
> > 
> > A less safe version of del_gendisk, but which won't sync the filesystem.
> > Since driver knows that card is gone, there is no point of syncing it.
> > 
> > (the sync is done by invalidate_partition, so some flag should be
> > propagated to it).
> 
> That might work for mmc, but it wouldn't help other drivers subject to
> the same problem.
> 
> Besides, it's subject to races.  What if the card _isn't_ gone, but for 
> some other reason the driver wants to unregister the device at a time 
> when the writeback thread is frozen?
> 
> Alan Stern
> 


