Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab1AMUTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:19:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:41561 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933727Ab1AMUTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:19:11 -0500
Date: Fri, 14 Jan 2011 07:18:58 +1100
From: NeilBrown <neilb@suse.de>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Tejun Heo <tj@kernel.org>, Milan Broz <mbroz@redhat.com>,
        Karel Zak <kzak@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Message-ID: <20110114071858.7eee145c@notabene.brown>
In-Reply-To: <656A2F9B-4E1C-44AA-80CB-9E3428E26CDE@mit.edu>
References: <16069.1294853673@localhost>
	<4D2E4611.90002@redhat.com>
	<4D2E6129.8000700@ce.jp.nec.com>
	<20110113110640.GC30719@htj.dyndns.org>
	<4D2EE156.1050006@redhat.com>
	<20110113122701.GG16523@nb.net.home>
	<20110113131216.GF30719@htj.dyndns.org>
	<20110113132637.GH16523@nb.net.home>
	<20110113133722.GG30719@htj.dyndns.org>
	<4D2F04FF.1070309@redhat.com>
	<20110113141107.GI30719@htj.dyndns.org>
	<4D2F0B6A.6010201@redhat.com>
	<AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
	<656A2F9B-4E1C-44AA-80CB-9E3428E26CDE@mit.edu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011 09:45:54 -0500 Theodore Tso <tytso@MIT.EDU> wrote:

> 
> On Jan 13, 2011, at 9:30 AM, Tejun Heo wrote:
> >> 
> > 
> > Yeah, that's the most bothering part for me.  The biggest customers of
> > bd_claim are filesystems and all these custom symlinkeries don't do
> > nothing for them.  It just doesn't make a whole lot of sense to me.
> > 
> 
> Well, if there's better way to do things, we can send patches to libblkid to switch away from using sysfs, assuming it's using a new enough kernel.
> 
> The primary problem that we're trying to solve is to know whether a particular device contains a file system that should potentially mounted (or fsck'ed, or used as a external journal device, etc.)
> 
> If the file system is located on a raid 0 device created using devicemapper, the first physical block device could look like a file system.  So what we want is a very easy way of determining, "is this device being used by the device mapper layer"?   If it is, then it's probably not the droids we are looking for.   We'll keep looking at the rest of the block devices in the system, and when we find the dm-concatenated devices, we can properly identify it.
> 
> Can you suggest a better way doing what it is we need to do?

open(O_EXCL) will fail on a block device if it is being used by anything else
- a filesystem or a dm target or an md array or ....

So if the *only* thing you want is "is this currently an active part of
something else", then O_EXCL works since 2.6.0 (I think).

NeilBrown

