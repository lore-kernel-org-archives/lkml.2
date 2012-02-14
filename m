Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260Ab2BNVdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:33:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab2BNVdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:33:38 -0500
Date: Tue, 14 Feb 2012 13:33:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        John Stultz <john.stultz@linaro.org>,
        Jerry James <jamesjer@betterlinux.com>,
        Julius Plenz <julius@plenz.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH v5 0/3] fadvise: support POSIX_FADV_NOREUSE
Message-Id: <20120214133337.9de7835b.akpm@linux-foundation.org>
In-Reply-To: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Feb 2012 01:21:35 +0100
Andrea Righi <andrea@betterlinux.com> wrote:

> The new proposal is to implement POSIX_FADV_NOREUSE as a way to perform a real
> drop-behind policy where applications can mark certain intervals of a file as
> FADV_NOREUSE before accessing the data.

I think you and John need to talk to each other, please.  The amount of
duplication here is extraordinary.

Both patchsets add fields to the address_space (and hence inode), which
is significant - we should convince ourselves that we're getting really
good returns from a feature which does this.



Regarding the use of fadvise(): I suppose it's a reasonable thing to do
in the long term - if the feature works well, popular data streaming
applications will eventually switch over.  But I do think we should
explore interfaces which don't require modification of userspace source
code.  Because there will always be unconverted applications, and the
feature becomes available immediately.

One such interface would be to toss the offending application into a
container which has a modified drop-behind policy.  And here we need to
drag out the crystal ball: what *is* the best way of tuning application
pagecache behaviour?  Will we gravitate towards containerization, or
will we gravitate towards finer-tuned fadvise/sync_page_range/etc
behaviour?  Thus far it has been the latter, and I don't think that has
been a great success.

Finally, are the problems which prompted these patchsets already
solved?  What happens if you take the offending streaming application
and toss it into a 16MB memcg?  That *should* avoid perturbing other
things running on that machine.

And yes, a container-based approach is pretty crude, and one can
envision applications which only want modified reclaim policy for one
particualr file.  But I suspect an application-wide reclaim policy
solves 90% of the problems.

