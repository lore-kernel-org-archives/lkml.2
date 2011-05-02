Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1EBMkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 08:40:14 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:20188 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250Ab1EBMkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 08:40:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJCkvk15LBza/2dsb2JhbACmG3jABg6FcgSdLQ
Date: Mon, 2 May 2011 22:40:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110502124007.GC2978@dastard>
References: <20110423224403.5fd1136a@neptune.home>
 <20110427050850.GG12436@dastard>
 <20110427182622.05a068a2@neptune.home>
 <20110428194528.GA1627@x4.trippels.de>
 <20110429011929.GA13542@dastard>
 <20110429151841.GA893@x4.trippels.de>
 <20110429213524.449e003b@neptune.home>
 <20110430161810.6ccd2c99@neptune.home>
 <20110502061528.GA22538@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110502061528.GA22538@x4.trippels.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 08:15:28AM +0200, Markus Trippelsdorf wrote:
> On 2011.04.30 at 16:18 +0200, Bruno Prémont wrote:
> > On Fri, 29 April 2011 Bruno Prémont wrote:
> > > On Fri, 29 April 2011 Markus Trippelsdorf wrote:
> > > > On 2011.04.29 at 11:19 +1000, Dave Chinner wrote:
> > > > > OK, so the common elements here appears to be root filesystems
> > > > > with small log sizes, which means they are tail pushing all the
> > > > > time metadata operations are in progress. Definitely seems like a
> > > > > race in the AIL workqueue trigger mechanism. I'll see if I can
> > > > > reproduce this and cook up a patch to fix it.
> > > > 
> > > > Hmm, I'm wondering if this issue is somehow related to the hrtimer bug,
> > > > that Thomas Gleixner fixed yesterday:
> > > > http://git.us.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=ce31332d3c77532d6ea97ddcb475a2b02dd358b4
> > > > http://thread.gmane.org/gmane.linux.kernel.mm/61909/
> > > > 
> > > > It also looks similar to the issue that James Bottomley reported
> > > > earlier: http://thread.gmane.org/gmane.linux.kernel.mm/62185/ 
> > > 
> > > I'm going to see, I've applied Thomas' fix on the box seeing XFS freeze (without
> > > other changes to kernel).
> > > Going to run that kernel for the week-end and beyond if it survives to see what
> > > happens.
> > 
> > Happened again (after a few hours of uptime), so it definitely is not
> > caused by hrtimer bug that Thomas Gleixner fixed.
> 
> I've enabled lock debugging and this is what happened after a few hours
> uptime. (I can't tell if this is a false positive):
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.39-rc5-00130-g3fd9952 #10
> -------------------------------------------------------
> kio_file/7364 is trying to acquire lock:
>  (&sb->s_type->i_mutex_key#5/2){+.+...}, at: [<ffffffff81151e4e>] generic_file_splice_write+0xce/0x180
> 
> but task is already holding lock:
>  (xfs_iolock_active){++++++}, at: [<ffffffff811d7d05>] xfs_ilock+0x125/0x1f0
> 
> which lock already depends on the new lock.

Known problem. Been broken for ages, yet I only first saw a lockdep
report for this about a week ago on a 2.6.32 kernel....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
