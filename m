Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0KJOeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:34:10 -0500
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:42221 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755025Ab0KJOeI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:34:08 -0500
X-AuditID: 12074425-b7c98ae000000a04-da-4cdaad5f103a
Subject: Re: 2.6.36 io bring the system to its knees
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20101110013255.GR2715@dastard>
Date: Wed, 10 Nov 2010 09:33:29 -0500
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, dave b <db.pub.mail@gmail.com>,
        Sanjoy Mahajan <sanjoy@olin.edu>, Jesper Juhl <jj@chaosbits.net>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C70A546B-6BC5-49CA-9E34-E69F494A71A0@mit.edu>
References: <20101105014334.GF13830@dastard> <E1PELiI-0001Pj-8g@approx.mit.edu> <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com> <4CD696B4.6070002@kernel.dk> <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com> <20101110013255.GR2715@dastard>
To: Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAARagEl4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 9, 2010, at 8:32 PM, Dave Chinner wrote:

> Don't forget to mention data=writeback is not the default because if
> your system crashes or you lose power running in this mode it will
> *CORRUPT YOUR FILESYSTEM* and you *WILL LOSE DATA*. Not to mention
> the significant security issues (e.g stale data exposure) that also
> occur even if the filesystem is not corrupted by the crash. IOWs,
> data=writeback is the "fast but I'll eat your data" option for ext3.

This is strictly speaking not true.  Using data=writeback will not cause you to lose any data --- at least, not any more than you would without the feature.   If you have applications that write files in an unsafe way, that data is going to be lost, one way or another.  (i.e., with XFS in a similar situation you'll get a zero-length file)   The difference is that in the case of a system crash, there may be unwritten data revealed if you use data=writeback.  This could be a security exposure, especially if you are using your system in as time-sharing system, and where you see the contents of deleted files belonging to another user.

So it is not an "eat your data" situation,  but rather, a "possibly expose old data".   Whether or not you care on a single-user workstation situation, is an individual judgement call.   There's been a lot of controversy about this.

The chance that this occurs using data=writeback in ext4 is much less, BTW, because with delayed allocation we delay updating the inode until right before we write the block.  I have a plan for changing things so that we write the data blocks *first* and then update the metadata blocks second, which will mean that ext4 data=ordered will go away entirely, and we'll get both the safety and as well as avoiding the forced data page writeouts during journal commits.

-- Ted

