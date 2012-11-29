Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2K2ESO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:18:14 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33056 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196Ab2K2ESM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:18:12 -0500
Message-ID: <50B6E1F9.5010301@linaro.org>
Date: Wed, 28 Nov 2012 20:18:01 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC v2] Support volatile range for anon vma
References: <1351560594-18366-1-git-send-email-minchan@kernel.org> <50AD739A.30804@linaro.org>
In-Reply-To: <50AD739A.30804@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112904-7182-0000-0000-0000036635ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 04:36 PM, John Stultz wrote:
> 2) Being able to use this with tmpfs files. I'm currently trying to 
> better understand the rmap code, looking to see if there's a way to 
> have try_to_unmap_file() work similarly to try_to_unmap_anon(), to 
> allow allow users to madvise() on mmapped tmpfs files. This would 
> provide a very similar interface as to what I've been proposing with 
> fadvise/fallocate, but just using process virtual addresses instead of 
> (fd, offset) pairs.   The benefit with (fd,offset) pairs for Android 
> is that its easier to manage shared volatile ranges between two 
> processes that are sharing data via an mmapped tmpfs file (although 
> this actual use case may be fairly rare).  I believe we should still 
> be able to rework the ashmem internals to use madvise (which would 
> provide legacy support for existing android apps), so then its just a 
> question of if we could then eventually convince Android apps to use 
> the madvise interface directly, rather then the ashmem unpin ioctl.

Hey Minchan,
     I've been playing around with your patch trying to better 
understand your approach and to extend it to support tmpfs files. In 
doing so I've found a few bugs, and have some rough fixes I wanted to 
share. There's still a few edge cases I need to deal with (the 
vma-purged flag isn't being properly handled through vma merge/split 
operations), but its starting to come along.

Anyway, take a look at the tree here and let me know what you think.
http://git.linaro.org/gitweb?p=people/jstultz/android-dev.git;a=shortlog;h=refs/heads/dev/minchan-anonvol

I'm sure much is wrong with the tree, but with it I can now mark tmpfs 
file pages as volatile/nonvolatile and see them purged under pressure. 
Unfortunately its not limited to tmpfs, so persistent files will also 
work, but the state of the underlying files on purge is undefined. 
Hopefully I can find a way to limit it to non-persistent filesystems for 
now, and if needed find a way to extend it to persistent filesystems in 
a sane way later.

thanks
-john

