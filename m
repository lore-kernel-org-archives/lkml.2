Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab2HPW0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:26:34 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45134 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab2HPW0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:26:33 -0400
Date: Thu, 16 Aug 2012 18:26:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Marti Raudsepp <marti@juffo.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        ext4 hackers <linux-ext4@vger.kernel.org>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Message-ID: <20120816222629.GG31346@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <CANP3RGdMfM0tZbaJS9dFetRhXoGtyS0Nx4hZER_Qv0a061X_dQ@mail.gmail.com>
 <20120816211948.GF31346@thunk.org>
 <CANP3RGd62=voh5T6NACyFE-NqX=Huk1hkewSakPs67vC+uuTuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANP3RGd62=voh5T6NACyFE-NqX=Huk1hkewSakPs67vC+uuTuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 02:40:53PM -0700, Maciej Żenczykowski wrote:
> 
> This happened twice to me while moving data off of a ~1TB ext4 partition.
> The data portion was on a stripe raid across 2 ~500GB drives, the
> journal was on a relatively large partition (500MB?) on an SSD.
> (crypto and lvm were also involved).
> ...
> Perhaps just untarring a bunch of kernels onto an empty partition,
> filling it up, then deleting those kernels should be sufficient to
> repro this (untried).

Thanks, that's really helpful.   I can say that using a 4MB journal and
running fsstress is _not_ enough to trigger the problem.

Looking more closely at what might be needed to trigger the bug, 'i'
gets left uninitialized when err is set to -EAGAIN, and that happens
when ext4_ext_truncate_extend_restart() is unable to extend the
journal transaction.  But that also means we need to be deleting a
sufficiently large enough file that the blocks span multiple block
groups (which is why we need to extend the transaction, so we can
modify more bitmap blocks) at the point when there is no more room in
the journal, so we have to close the current transaction, and then
retry it again with a new journal handle in a new transaction.

So that implies that untaring a bunch of kernels probably won't be
sufficient, since the files will be too small.  What we probably will
need to do is to fill a large file system with lots of large files,
use a small journal, and then try to do an rm -rf.

          	    	     	      	     - Ted
