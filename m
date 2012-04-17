Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab2DQTFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:05:05 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57156 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab2DQTFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:05:02 -0400
Date: Tue, 17 Apr 2012 15:04:59 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Zheng Liu <gnehzuil.liu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Message-ID: <20120417190459.GB5916@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
 <4F8DAF89.5070805@redhat.com>
 <20120417184306.GA5916@thunk.org>
 <4F8DBC20.5010401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8DBC20.5010401@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 01:53:20PM -0500, Eric Sandeen wrote:
> 
> In my (admittedly quick, hacky) test, xfs suffed about a 1% perf
> degradation, ext4 about 8%.  Until we at least know why ext4 is so
> much worse, I'll signal a strong NAK for this change, for whatever
> may or may not be worth.  :)

Was this on a HDD?  Try it on a PCIe attached flash device that
doesn't support persistent discard.  :-)  I suspect in that case even
with XFS you will see a bigger performance penalty than that.

That being said, I agree that it would be good to see if we can
improve ext4's performance without the big hammer, regardless of
whether or not we can bring the uninit->init overhead down to zero.
Some of the overhead I suspect is due the fact that ext4 is doing
physical block journalling, which we won't be able to work around, but
it may be there is room for improvement in the extent manipulation
codepaths and and how they get called from the I/O completion handler.

(Oh, and that's assuming you were using DIO or AIO; if you were using
buffered writes, you were probably getting hit by the ordered mode
flush requirements, since in buffered mode we do the uninit->init
conversion before we write out the data block, so we have to do an
implicit fsync in the commit transaction.  Fixing that is something
we've talked about before, and that's certainly worth doing; it
requires the I/O tree work that we talked about at the ext4 workshop
as a prerequisite, though.)

						- Ted
