Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966052Ab2JZSrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:47:01 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57833 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2JZSq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:46:58 -0400
Date: Fri, 26 Oct 2012 14:46:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Akira Fujita <a-fujita@rs.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/3] ext4: introduce ext4_error_remove_page
Message-ID: <20121026184649.GA8614@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Luck, Tony" <tony.luck@intel.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	"Kleen, Andi" <andi.kleen@intel.com>,
	"Wu, Fengguang" <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <1351177969-893-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1351177969-893-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20121026061206.GA31139@thunk.org>
 <3908561D78D1C84285E8C5FCA982C28F19D5A13B@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D5A13B@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 04:55:01PM +0000, Luck, Tony wrote:
> 
> I think that we know that the file *is* corrupted, not just "potentially".
> We probably know the location of the corruption to cache-line granularity.
> Perhaps better on systems where we have access to ecc syndrome bits,
> perhaps worse ... we do have some errors where the low bits of the address
> are not known.

Well, it's at least *possible* that it was only the ECC bits that got
flipped.  :-) Not likely, I'll grant!  (Or does the motherboard zero
out the entire cache-line on a hard ECC failure?)

> I'm in total agreement that forcing a reboot or fsck is unhelpful here.
> 
> But what should we do?  We don't want to let the error be propagated. That
> could cause a cascade of more failures as applications make bad decisions
> based on the corrupted data.
> 
> Perhaps we could ask the filesystem to move the file to a top-level
> "corrupted" directory (analogous to "lost+found") with some attached
> metadata to help recovery tools know where the file came from, and the
> range of corrupted bytes in the file? We'd also need to invalidate existing
> open file descriptors (or less damaging - flag them to avoid the corrupted
> area??). Whatever we do, it needs to be persistent across a reboot ... the
> lost bits are not going to magically heal themselves.

Well, we could set a new attribute bit on the file which indicates
that the file has been corrupted, and this could cause any attempts to
open the file to return some error until the bit has been cleared.
This would persist across reboots.  The only problem is that system
administrators might get very confused (at least at first, when they
first run a kernel or a distribution which has this feature enabled).
Application programs could also get very confused when any attempt to
open or read from a file suddenly returned some new error code (EIO,
or should we designate a new errno code for this purpose, so there is
a better indication of what the heck was going on?)

Also, if we just log the message in dmesg, if the system administrator
doesn't find the "this file is corrupted" bit right away, they might
not be able to determine which part of the file was corrupted.  How
important is this?  If the file system supports extended attributes,
should we attempt to attach a new extended attribute with information
about the ECC failure?

I'm not sure it's worth it to go to these extents, but I could imagine
some customers wanting to have this sort of information.  Do we know
what their "nice to have" / "must have" requirements might be?

     	       	       	       	    	 - Ted
