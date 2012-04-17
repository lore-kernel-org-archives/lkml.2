Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2DQSnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:43:13 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:50116 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab2DQSnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:43:11 -0400
Date: Tue, 17 Apr 2012 14:43:06 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Message-ID: <20120417184306.GA5916@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Ric Wheeler <rwheeler@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
 <4F8DAF89.5070805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8DAF89.5070805@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 01:59:37PM -0400, Ric Wheeler wrote:
> 
> You could get both security and avoid the run time hit by fully
> writing the file or by having a variation that relied on "discard"
> (i.e., no need to zero data if we can discard or track it as
> unwritten).

It's certainly the case that if the device supports persistent
discard, something which we definitely *should* do is to send the
discard at fallocate time and then mark the space as initialized.

Unfortunately, not all devices, and in particular no HDD's for which I
aware support persistent discard.  And, writing all zero's to the file
is in fact what a number of programs for which I am aware (including
an enterprise database) are doing, precisely because they tend to
write into the fallocated space in a somewhat random order, and the
extent conversion costs is in fact quite significant.  But writing all
zero's to the file before you can use it is quite costly; at the very
least it burns disk bandwidth --- one of the main motivations of
fallocate was to avoid needing to do a "write all zero pass", and
while it does solve the problem for some use cases (such as DVR's),
it's not a complete solution.

Whether or not it is a security issue is debateable.  If using the
fallocate flag requires CAP_SYS_RAWIO, and the process has to
explicitly ask for the privilege, a process with those privileges can
directly access memory and I/O ports directly, via the ioperm(2) and
iopl(2) system calls.  So I think it's possible to be a bit nuanced
over whether or not this is as horrible as you might think.

Ultimately, if there are application programmers who are really
desperate for that the last bit of performance, they can always use
FIBMAP/FIEMAP and then read/write directly to the block device.  (And
no, that's not a theoretical example.)  I think it is a worthwhile
goal to provide file system interfaces that allow a trusted process
which has the appropriate security capabilities to do things in a
safer way than that.

Regards,

						- Ted
