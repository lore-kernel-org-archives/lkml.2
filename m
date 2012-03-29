Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385Ab2C2XZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:25:54 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53019 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760329Ab2C2XZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:25:49 -0400
Date: Thu, 29 Mar 2012 16:25:43 -0700
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockups shortly after booting in current git.
Message-ID: <20120329232543.GF13970@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
 <20120329195354.GA11790@redhat.com>
 <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
 <20120329202619.GA14001@redhat.com>
 <20120329203926.GA13970@thunk.org>
 <CA+55aFwJkN2BmZJmWfB6FU0TuVKfmh4um8pMKYVUk3aG7JkNwQ@mail.gmail.com>
 <20120329211244.GA18684@redhat.com>
 <20120329214510.GD13970@thunk.org>
 <20120329214959.GA20783@redhat.com>
 <CA+55aFz5Di6K4TzrFrGdyrPQkadt1pkGrWv_9GyaVgUjx_4cwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz5Di6K4TzrFrGdyrPQkadt1pkGrWv_9GyaVgUjx_4cwg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 02:52:40PM -0700, Linus Torvalds wrote:
> >
> > up 30 minutes with that reverted, no problems so far..
> 
> Goodie. Let it run for a while more, and really pound on it.
> 
> Ted, are there any downsides to just reverting that commit (ie any
> subtle interactions) for now?  That's assuming that Dave's testing
> continues to confirm that it is that one commit.

That commit fixes a race which is seen when you write into fallocated
(and hence uninitialized) disk blocks under *very* heavy memory
pressure.  Furthermore, although theoretically it could trigger under
normal direct I/O writes, it only seems to trigger if you are issuing
a huge number of AIO writes, such that a just-written page can get
evicted from memory, and then read back into memory, before the
workqueue has a chance to update the extent tree.

This race has been around for a little over a year, and no one noticed
until two months ago; it only happens under fairly exotic conditions,
and in fact even after trying very hard to create a simple repro under
lab conditions, we could only reproduce the problem and confirm the
fix on production servers running MySQL on very fast PCIe-attached
flash devices.

Given that Dave was able to hit this problem pretty quickly, if we
confirm that this commit is at fault, the only reasonable thing to do
is to revert it IMO.

    	      	      	   	       	  - Ted
