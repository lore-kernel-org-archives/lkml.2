Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2BPS6C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:58:02 -0500
Received: from mail.betterlinux.com ([199.58.199.50]:37220 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2BPS56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:57:58 -0500
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 51A698232F
Date: Thu, 16 Feb 2012 19:57:53 +0100
From: Andrea Righi <andrea@betterlinux.com>
To: Arun Sharma <asharma@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
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
Subject: Re: [PATCH v5 3/3] fadvise: implement POSIX_FADV_NOREUSE
Message-ID: <20120216185753.GD13354@thinkpad>
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
 <1329006098-5454-4-git-send-email-andrea@betterlinux.com>
 <20120215233537.GA20724@dev3310.snc6.facebook.com>
 <20120215234724.GA21685@thinkpad>
 <4F3C467B.1@fb.com>
 <20120216005608.GC21685@thinkpad>
 <4F3C6594.3030709@fb.com>
 <20120216103944.GA1440@thinkpad>
 <4F3D4E34.9060105@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3D4E34.9060105@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 10:43:00AM -0800, Arun Sharma wrote:
> On 2/16/12 2:39 AM, Andrea Righi wrote:
> 
> >Arun, thank you very much for your review and testing. Probably we'll
> >move to a different, memcg-based solution, so I don't think I'll post
> >another version of this patch set as is. In case, I'll apply one of
> >the workarounds for the rb_root attribute.
> 
> I'm not sure if the proposed memory.file.limit_in_bytes is the right
> interface. Two problems:
> 
> * The user is now required to figure out what is the right amount of
> page cache for the app (may change over time)

Right.

> 
> * If the app touches two sets of files, one with streaming access
> and the other which benefits from page cache (eg: a mapper task in a
> map reduce), memcg doesn't allow the user to specify the access
> pattern per-fd.

Yes, of course the memcg approach is probably too coarse-grained for
certain apps.

If we want to provide the per-fd granularity the fadvise() solution is
a way better. However, the memcg solution could be enough to resolve
most of the common data streaming issues (like "the backup is trashing
the page cache" problem) and it doesn't require modification of the
application source code. This is an important advantage that we
shouldn't ignore IMHO, because it means that the new feature will be
available _immediately_ for any application.

Maybe we should try to push ...something... in the memcg code for the
short-term future, make it as much generic as possible, and for the
long-term try to reuse the same feature (totally or in part) in the
per-fd approach via fadvise().

Thanks,
-Andrea
