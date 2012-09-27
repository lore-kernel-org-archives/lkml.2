Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2I0PMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:12:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab2I0PMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:12:35 -0400
Date: Thu, 27 Sep 2012 17:12:32 +0200
From: Jan Kara <jack@suse.cz>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
Message-ID: <20120927151232.GA12210@quack.suse.cz>
References: <50531629.9020107@ahsoftware.de>
 <20120925110206.GD28937@mwanda>
 <50643C4A.9010202@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50643C4A.9010202@ahsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-09-12 13:45:14, Alexander Holler wrote:
> Am 25.09.2012 13:02, schrieb Dan Carpenter:
> >Did any of the old kernels work?  Have you ruled out bad hardware?
> 
> Older kernels worked and I could make full backups without any
> problems. I'm using that hardware since several years, and never had
> a problem with that, at least when I've used only one external usb
> hard disk (see https://bugzilla.kernel.org/show_bug.cgi?id=14785 for
> problems I had (and still have) when using multiple usb2 disks
> attached to this box.
> 
> But what now happend is a bit worrying. I needed about two days to
> build a full backup which didn't failed when I've compared the
> backup (either by checksum or by bzip2 -t). Worrying here is that
> many of those tries to build a sane backup didn't indicated any
> error while doing the backup. Only afterwards, either by a wrong
> checksum, by a broken tar.bz2 archive , or even by different content
> of the (compressed) tar archive (checked with tar djf ...) the
> errors where visible. I first thought the problem might be the (new)
> usb3 card, but I'm also had problems by using the usb3-disk at an
> usb2 port. The external disk (new too) doesn't seem to be the
> problem, because I don't have any problems when using it on another
> box (a laptop with 3.5.3 and now 3.5.4 too).
> 
> The problem is that I do full backups only seldom (I'm using git
> push to do regular backups), so I can't say when this started (I'm
> usually using the latest stable kernel). Userland hasn't changed too
> (still was F15, I did the full backup to upgrade to F17 afterwards).
> 
> Another problem is that I don't know if the problem occured by using
> tar or just by using dd. Target was in all cases an ext4-partition
> on the external disk.
> 
> >If the answers to both questions are yes then it makes your email
> >harder to ignore.  In which case, we'd probably want the complete
> >dmesg.
> 
> I don't think the problem is usb related because I had the problem
> when attaching the disk to an usb2-port as well as when attaching
> the disk to an usb3-port (different adapter). I guess I'm getting
> hit by some race-condition caused by the high io-throughput (as said
> tar or dd | mbuffer | bzip2smp) in combination with the 7
> compressing threads. In the last days I even got an error using
> 3.5.4 when I've copied a file with a size of about 3gb from nfs to
> tmpfs and afterwards to an usb-disk attached to an usb2-port. The
> file was broken (checksum didn't match), but I haven't had an oops
> or another error during that operation. So the oops might be just an
> indication of something else which goes wrong here.
> 
> I've attached a full dmesg when such an oops occured. It's full with
> thermal events, caused through the high pressure happening when
> using bzip2smp (which starts 7 or threads by default on this
> ht-enabled cpu). But those are normal, the fan is working as
> expected and it is the original one which I got in conjunction with
> the processor, room temperatur was around 25°C, so nothing
> exceptional and I usually just ignore those messages because I never
> had a problem.
> 
> And I have to mention that I haven't experienced a problem, when
> I've used tar cp | mbuffer | tar xp to copy a 50gb ext4-partion from
> one sata-attached ssd to another (in the same box). Comparing the
> result didn't indicate any error (of course, memory pressure was
> less as no bzip2smp was involved).
> 
> Reading my experiences above by myself, it looks a bit more like a
> problem in the usb-stack (in contrast to what I've written above)
> because I usually don't get any throttling events while copying just
> a file (regardless how large it is). But, it's just a guess. It
> might be hw-problem, I've never trusted this cpu and/or chipset when
> usb is involved and had the hope usb might become usable on that box
> when using an external usb3-adapter. But ...
> 
> So to conclude the whole story, I don't have much hope that it might
> be possible to find the problem without me doing a lot of tries and
> because I'm using this box regulary, I'm not sure if can accomplish
> that. The oops might be an indication, but I'm not sure. It's time
> consuming for me to read through the involved code and guessing
> whats happening there. I like to do so, but ... ;)
> Maybe I just should throw this machine out of the window and get
> some other hw. ;)
> 
> I wouldn't have posted that problem, if I wouldn't have that oops (I
> got it 2 times) which might be of interest for someone. ;)
> 
> I've attached the log and my kernel config.
  Just some thoughts about your oops:
The assertion which fails is:
BUG_ON(!list_empty(&bh->b_assoc_buffers));

Now b_assoc_buffers isn't used very much. In particular ext4 which you seem
to be using doesn't use this list at all (except when mounted in nojournal
mode but that doesn't seem to be your case). That would point rather
strongly at a memory corruption issue.

So if you can reproduce the oops, it might be interesting to print
bh->b_assoc_buffers.next and &bh->b_assoc_buffers.next if the list is found
to be non-empty.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
