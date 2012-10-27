Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab2J0WkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 18:40:15 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58020 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759559Ab2J0WkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 18:40:13 -0400
Date: Sat, 27 Oct 2012 18:16:26 -0400
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
Message-ID: <20121027221626.GA9161@thunk.org>
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
 <20121026184649.GA8614@thunk.org>
 <3908561D78D1C84285E8C5FCA982C28F19D5A388@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D5A388@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 10:24:23PM +0000, Luck, Tony wrote:
> > Well, we could set a new attribute bit on the file which indicates
> > that the file has been corrupted, and this could cause any attempts to
> > open the file to return some error until the bit has been cleared.
> 
> That sounds a lot better than renaming/moving the file.

What I would recommend is adding a 

#define FS_CORRUPTED_FL		0x01000000 /* File is corrupted */

... and which could be accessed and cleared via the lsattr and chattr
programs.

> > Application programs could also get very confused when any attempt to
> > open or read from a file suddenly returned some new error code (EIO,
> > or should we designate a new errno code for this purpose, so there is
> > a better indication of what the heck was going on?)
> 
> EIO sounds wrong ... but it is perhaps the best of the existing codes. Adding
> a new one is also challenging too.

I think we really need a different error code from EIO; it's already
horribly overloaded already, and if this is new behavior when the
customers get confused and call up the distribution help desk, they
won't thank us if we further overload EIO.  This is abusing one of the
System V stream errno's, but no one else is using it:

#define EADV		 68  /* Advertise error */

I note that we've already added a new error code:

#define EHWPOISON 133	  /* Memory page has hardware error */

... although the glibc shipping with Debian testing hasn't been taught
what it is, so strerror(EHWPOISON) returns "Unknown error 133".  We
could simply allow open(2) and stat(2) return this error, although I
wonder if we're just better off defining a new error code.

> 18 years ago Intel rather famously attempted to sell users on the
> idea that a rare divide error that sometimes gave the wrong answer
> could be ignored. Before my time at Intel, but it is still burned
> into the corporate psyche that customers really don't like to get
> the wrong answers from their computers.

... and yet, people are generally not willing to pay the few extra
dollars for ECC memory, such that even if I want ECC for a laptop or a
desktop machine, it's generally not available without paying $$$$ for
a server-class motherboard.  :-(

The lesson I'd take from that incident is that customers really hate
it when it's trivial to reproduce the error, especially using the
something as simple and universal as the Windows Calculator
application.

Anyway, that's neither here nor there.  Perhaps it's enough to simply
log an error with a sufficient level of severity that it gets saved in
log files, at least for now.

					- Ted
