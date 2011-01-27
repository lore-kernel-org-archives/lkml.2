Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1A0Bns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:43:48 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:20529 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754317Ab1A0Bnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:43:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAHNcQE1Ld/sX/2dsb2JhbAAMhAbNQJBpgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,383,1291611600"; 
   d="scan'208";a="89371136"
Message-ID: <4D40CDCF.4010301@teksavvy.com>
Date: Wed, 26 Jan 2011 20:43:43 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com>
In-Reply-To: <4D40C8D1.8090202@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-26 08:22 PM, Mark Lord wrote:
> Alex / Christoph,
> 
> My mythtv box here uses XFS on a 2TB drive for storing recordings and videos.
> It is behaving rather strangely though, and has gotten worse recently.
> Here is what I see happening:
> 
> The drive mounts fine at boot, but the very first attempt to write a new file
> to the filesystem suffers from a very very long pause, 30-60 seconds, during which
> time the disk activity light is fully "on".
> 
> This happens only on the first new file write after mounting.
>>From then on, the filesystem is fast and responsive as expected.
> If I umount the filesystem, and then mount it again,
> the exact same behaviour can be observed.
> 
> This of course screws up mythtv, as it causes me to lose the first 30-60
> seconds of the first recording it attempts after booting.  So as a workaround
> I now have a startup script to create, sync, and delete a 64MB file before
> starting mythtv.  This still takes 30-60 seconds, but it all happens and
> finishes before mythtv has a real-time need to write to the filesystem.
> 
> The 2TB drive is fine -- zero errors, no events in the SMART logs,
> and I've disabled the silly WD head-unload logic on it.
> 
> What's happening here?  Why the big long burst of activity?
> I've only just noticed this behaviour in the past few weeks,
> running 2.6.35 and more recently 2.6.37.
> 
> * * *
> 
> The other issue is something I notice at umount time.
> I have a second big drive used as a backup device for the drive discussed above.
> I use "mirrordir" (similar to rsync) to clone directories/files from the main
> drive to the backup drive.  After mirrordir finishes, I then "umount /backup".
> The umount promptly hangs, disk light on solid, for 30-60 seconds, then finishes.
> 
> If I type "sync" just before doing the umount, sync takes about 1 second,
> and the umount finishes instantly.
> 
> Huh? What's happening there?
> 
> System is running 2.6.37 from kernel.org, but similar behaviour
> has been there under 2.6.35 and 2.6.34.  Dunno about earlier.
> 
> I can query any info you need from the filesystem.


Thinking about it some more:  the first problem very much appears as if
it is due to a filesystem check happening on the already-mounted filesystem,
if that makes any kind of sense (?).

Because.. running xfs_check on the umounted drive takes about the same 30-60
seconds,
with the disk activity light fully "on".

The other thought that came to mind:  this behaviour has only been noticed recently,
probably because I have recently added about 1000 new files (hundreds of MB each)
to the videos/ directory on that filesystem.  Whereas before, it had fewer
than 500 (multi-GB) files in total.

So if it really is doing some kind of internal filesystem check, then the time
required has only recently become 3X larger than before.. so the behaviour may
not be new/recent, but now is very noticeable.

I wonder what is really happening?

Cheers
