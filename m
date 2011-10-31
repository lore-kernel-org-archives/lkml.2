Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab1JaVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:09:56 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37108 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab1JaVJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:09:55 -0400
Date: Mon, 31 Oct 2011 17:09:51 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Vincent Pelletier <plr.vincent@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext4 bug ? "Intel 320 SSD =?utf-8?Q?wr?=
	=?utf-8?Q?ite_performance_=E2=80=93?= contd."
Message-ID: <20111031210951.GK16825@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Vincent Pelletier <plr.vincent@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CAF78GY1_HwP2QZsMLqHeJechjps44Jq2o1VDSFC0TriXB1riPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF78GY1_HwP2QZsMLqHeJechjps44Jq2o1VDSFC0TriXB1riPQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 09:38:37PM +0100, Vincent Pelletier wrote:
> 
> Reading this blog post[1], I thought the "2nd iteration" results could be
> considered a bug in mkfs.ext4 (and possibly any mkfs implementation):
> shouldn't mkfs run [FI]TRIM on its target before creating filesystem
> structure ?

It's not enabled by default, because there are crappy SSD's out there
where use of the TRIM command will turn them into bricks.  (No, it's
not the Intel X-25 drives that I'm worried about.)

So I (and the distributions) don't want to make it the default, since
if you buy crap drives and then mke2fs turns them into bricks, who are
you likely to blame?  The crap SSD manufacturer?  Yourself for trying
to buy SSD's on the cheap?  Or the program that issued the TRIM
command?

You can enable the trim behaviour by default by adding to your
/etc/mke2fs.conf file:

[defaults]
	discard = true

But then it's on your head if anything bad happens.  :-/

        	      	      	      - Ted

P.S.  For a similar reason we don't enable TRIM commands in the
kernel, where we have three possible ways of issuing TRIM.  One is
continuously, as files get unlinked (and the file system transaction
is committed).  Another way is via a userspace progam run out of cron
which calls the FITRIM ioctl; and the third way is at e2fsck time,
after a full e2fsck run without any file system errors detected.
Depending how the SSD implemented TRIM, (and of course your workload),
some of these methods can be performance disasters, and have resulted
in SSD's getting bricked, which is again why none of these are turned
on by default.

