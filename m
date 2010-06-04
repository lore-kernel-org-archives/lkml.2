Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab0FDLUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:20:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49976 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0FDLUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vAiK0wVQZXhu0z/AyrM9t5UojUMHJYV645j4BTi5zMppMS7a67tAkXcov5y8irJx0D
         OGQF7UseYGbNdbCOBPM1aaUfU+sM+rqJSIdosZvZogv5znK6+5ZMCIGrKmn1TfqCCe3S
         yU5r0VfablSkOr78KaTOIjLd3oCQxjKP5G8DU=
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <jens.axboe@oracle.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100304135337.GC12191@atrey.karlin.mff.cuni.cz>
References: <20100303215056.GB2579@ucw.cz>
	 <Pine.LNX.4.44L0.1003031720530.1380-100000@iolanthe.rowland.org>
	 <20100304135337.GC12191@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 14:20:16 +0300
Message-ID: <1275650416.3403.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 14:53 +0100, Pavel Machek wrote: 
> Hi!
> 
> > > journalling assumptions broken: commit block is there, but previous
> > > blocks are not intact. Data loss.
> > > 
> > > ...and that was the first I could think about. Lets not do
> > >  this. Barriers were invented for a reason.
> > 
> > Very well.  Then we still need a solution to the original problem:  
> > Devices sometimes need to be unregistered during resume, but
> > del_gendisk() blocks on the writeback thread, which is frozen until
> > after the resume finishes.  How do you suggest this be fixed?
> 
> Avoid unregistering device during resume. Instead, return errors until
> resume is done and you can call del_gendisk? 

This won't help ether. The same driver needs to unregister perfectly
working device on suspend, because the user might replace the card
during suspend and fool the os.
There is a setting, CONFIG_MMC_UNSAFE_RESUME and I use it, but it isn't
default.

Anyway to revive that old thread, how about introducing new
del_gendisk_no_sync?

A less safe version of del_gendisk, but which won't sync the filesystem.
Since driver knows that card is gone, there is no point of syncing it.

(the sync is done by invalidate_partition, so some flag should be
propagated to it).



Best regards,
Maxim Levitsky

