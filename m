Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab2BNW7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 17:59:32 -0500
Received: from mail.betterlinux.com ([199.58.199.50]:51000 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2BNW72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 17:59:28 -0500
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 2CA4782A77
Date: Tue, 14 Feb 2012 23:59:22 +0100
From: Andrea Righi <andrea@betterlinux.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        John Stultz <john.stultz@linaro.org>,
        Jerry James <jamesjer@betterlinux.com>,
        Julius Plenz <julius@plenz.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH v5 0/3] fadvise: support POSIX_FADV_NOREUSE
Message-ID: <20120214225922.GA12394@thinkpad>
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
 <20120214133337.9de7835b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214133337.9de7835b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 01:33:37PM -0800, Andrew Morton wrote:
> On Sun, 12 Feb 2012 01:21:35 +0100
> Andrea Righi <andrea@betterlinux.com> wrote:
> 
> > The new proposal is to implement POSIX_FADV_NOREUSE as a way to perform a real
> > drop-behind policy where applications can mark certain intervals of a file as
> > FADV_NOREUSE before accessing the data.
> 
> I think you and John need to talk to each other, please.  The amount of
> duplication here is extraordinary.

Yes, definitely. I'm currently reviewing and testing the John's patch
set. I was even considering to apply my patch set on top of the John's
patch, or at least propose my tree-based approach to manage the list of
the POSIX_FADV_VOLATILE ranges.

> 
> Both patchsets add fields to the address_space (and hence inode), which
> is significant - we should convince ourselves that we're getting really
> good returns from a feature which does this.
> 
> 
> 
> Regarding the use of fadvise(): I suppose it's a reasonable thing to do
> in the long term - if the feature works well, popular data streaming
> applications will eventually switch over.  But I do think we should
> explore interfaces which don't require modification of userspace source
> code.  Because there will always be unconverted applications, and the
> feature becomes available immediately.
> 
> One such interface would be to toss the offending application into a
> container which has a modified drop-behind policy.  And here we need to
> drag out the crystal ball: what *is* the best way of tuning application
> pagecache behaviour?  Will we gravitate towards containerization, or
> will we gravitate towards finer-tuned fadvise/sync_page_range/etc
> behaviour?  Thus far it has been the latter, and I don't think that has
> been a great success.
> 
> Finally, are the problems which prompted these patchsets already
> solved?  What happens if you take the offending streaming application
> and toss it into a 16MB memcg?  That *should* avoid perturbing other
> things running on that machine.

Moving the streaming application into a 16MB memcg can be dangerous in
some cases... the application might start to do "bad" things, like
swapping (if the memcg can swap) or just fail due to OOMs.

> 
> And yes, a container-based approach is pretty crude, and one can
> envision applications which only want modified reclaim policy for one
> particualr file.  But I suspect an application-wide reclaim policy
> solves 90% of the problems.

I really like the container-based approach. But for this we need a
better file cache control in the memory cgroup; now we have the
accounting of file pages, but there's no way to limit them.

Thanks for your comments, Andrew.

-Andrea
