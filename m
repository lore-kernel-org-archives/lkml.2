Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab2LDA6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 19:58:52 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39057 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2LDA6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 19:58:51 -0500
Message-ID: <50BD4A70.9060506@linaro.org>
Date: Mon, 03 Dec 2012 16:57:20 -0800
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
References: <1351560594-18366-1-git-send-email-minchan@kernel.org> <50AD739A.30804@linaro.org> <50B6E1F9.5010301@linaro.org> <20121204000042.GB20395@bbox>
In-Reply-To: <20121204000042.GB20395@bbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120400-7282-0000-0000-00000FA505BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 04:00 PM, Minchan Kim wrote:
> On Wed, Nov 28, 2012 at 08:18:01PM -0800, John Stultz wrote:
>> On 11/21/2012 04:36 PM, John Stultz wrote:
>>> 2) Being able to use this with tmpfs files. I'm currently trying
>>> to better understand the rmap code, looking to see if there's a
>>> way to have try_to_unmap_file() work similarly to
>>> try_to_unmap_anon(), to allow allow users to madvise() on mmapped
>>> tmpfs files. This would provide a very similar interface as to
>>> what I've been proposing with fadvise/fallocate, but just using
>>> process virtual addresses instead of (fd, offset) pairs.   The
>>> benefit with (fd,offset) pairs for Android is that its easier to
>>> manage shared volatile ranges between two processes that are
>>> sharing data via an mmapped tmpfs file (although this actual use
>>> case may be fairly rare).  I believe we should still be able to
>>> rework the ashmem internals to use madvise (which would provide
>>> legacy support for existing android apps), so then its just a
>>> question of if we could then eventually convince Android apps to
>>> use the madvise interface directly, rather then the ashmem unpin
>>> ioctl.
>> Hey Minchan,
>>      I've been playing around with your patch trying to better
>> understand your approach and to extend it to support tmpfs files. In
>> doing so I've found a few bugs, and have some rough fixes I wanted
>> to share. There's still a few edge cases I need to deal with (the
>> vma-purged flag isn't being properly handled through vma merge/split
>> operations), but its starting to come along.
> Hmm, my patch doesn't allow to merge volatile with another one by
> inserting VM_VOLATILE into VM_SPECIAL so I guess merge isn't problem.
> In case of split, __split_vma copy old vma to new vma like this
>
>          *new = *vma;
>
> So the problem shouldn't happen, I guess.
> Did you see the real problem about that?
Yes, depending on the pattern that MADV_VOLATILE and MADV_NOVOLATILE is 
applied, we can get a result where data is purged, but we aren't 
notified of it.  Also, since madvise returns early if it encounters an 
error, in the case where you have checkerboard volatile regions (say 
every other page is volatile), which you mark non-volatile with one 
large MADV_NOVOLATILE call, the first volatile vma will be marked 
non-volatile, but since it returns purged, the madvise loop will stop 
and the following volatile regions will be left volatile.

The patches in the git tree below which handle the perged state better 
seem to work for my tests, as far as resolving any overlapping calls. Of 
course there may yet still be problems I've not found.

>> Anyway, take a look at the tree here and let me know what you think.
>> http://git.linaro.org/gitweb?p=people/jstultz/android-dev.git;a=shortlog;h=refs/heads/dev/minchan-anonvol

Eager to hear what you think!

Thanks again!
-john

