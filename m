Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962Ab2C2VpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:45:19 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43788 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933361Ab2C2VpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:45:15 -0400
Date: Thu, 29 Mar 2012 14:45:10 -0700
From: "Ted Ts'o" <tytso@mit.edu>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockups shortly after booting in current git.
Message-ID: <20120329214510.GD13970@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20120329155542.GA31285@redhat.com>
 <CA+55aFxOcMt_mcr+ZYwc-SpKbROnh4Gn7jqrFY_SZcBy1Ev7Qw@mail.gmail.com>
 <20120329182632.GA6891@redhat.com>
 <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
 <20120329195354.GA11790@redhat.com>
 <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
 <20120329202619.GA14001@redhat.com>
 <20120329203926.GA13970@thunk.org>
 <CA+55aFwJkN2BmZJmWfB6FU0TuVKfmh4um8pMKYVUk3aG7JkNwQ@mail.gmail.com>
 <20120329211244.GA18684@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329211244.GA18684@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 05:12:44PM -0400, Dave Jones wrote:
> 
> I'll try a build with just that reverted, given the bisect build is taking a while.
> 

Something else you could try doing without even have to do a rebuild
is to just mount the filesystem with the mount option
nomblk_io_submit, which avoids using any of the code in
fs/ext4/page_io.c.  (This option causes ext4 will send blocks to the
block layer old fashioned way, on 4k block at a time, and rely on the
elevator code to coaslece the write requests.)

> Any thoughts on any printk's I could add to verify a situation occurred or not ?
> The problem with bisecting a bug like this is that it's hard to tell if
> the bug has been fixed, or if I've just not hit it yet.

If it really is about the PageWriteback bit not getting cleared, not
really.  If you're willing to expand the struct page to include a
timestamp, we could use that to note pages which have been in
writeback for a long time, but that's obviously quite expensive.

But actually, normally when it's a PageWriteback stall, usually you
get a soft lockup warning, assuming that was compiled into the system.
And I didn't see that in your trace, which is surprising given the
symptoms you described.  Was it perhaps not included in your log file
snippet?  Or was soft lockup detection not enabled?

	     	      	     	       	   - Ted


