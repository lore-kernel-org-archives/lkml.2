Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2J2LHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:07:10 -0400
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:58468 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab2J2LHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:07:08 -0400
Message-ID: <508E630F.2080800@ce.jp.nec.com>
Date: Mon, 29 Oct 2012 20:05:51 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>,
        "Wu\, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Akira Fujita <a-fujita@rs.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/3] ext4: introduce ext4_error_remove_page
References: <1351177969-893-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1351177969-893-3-git-send-email-n-horiguchi@ah.jp.nec.com> <20121026061206.GA31139@thunk.org> <3908561D78D1C84285E8C5FCA982C28F19D5A13B@ORSMSX108.amr.corp.intel.com> <20121026184649.GA8614@thunk.org> <3908561D78D1C84285E8C5FCA982C28F19D5A388@ORSMSX108.amr.corp.intel.com> <20121027221626.GA9161@thunk.org> <20121029011632.GN29378@dastard> <20121029024024.GC9365@thunk.org> <m27gq9r2cu.fsf@firstfloor.org>
In-Reply-To: <m27gq9r2cu.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/12 19:37, Andi Kleen wrote:
> Theodore Ts'o <tytso@mit.edu> writes:
>> On Mon, Oct 29, 2012 at 12:16:32PM +1100, Dave Chinner wrote:
>>> Except that there are filesystems that cannot implement such flags,
>>> or require on-disk format changes to add more of those flags. This
>>> is most definitely not a filesystem specific behaviour, so any sort
>>> of VFS level per-file state needs to be kept in xattrs, not special
>>> flags. Filesystems are welcome to optimise the storage of such
>>> special xattrs (e.g. down to a single boolean flag in an inode), but
>>> using a flag for something that dould, in fact, storage the exactly
>>> offset and length of the corruption is far better than just storing
>>> a "something is corrupted in this file" bit....
>>
>> Agreed, if we're going to add an xattr, then we might as well store
> 
> I don't think an xattr makes sense for this. It's sufficient to keep
> this state in memory.
> 
> In general these error paths are hard to test and it's important
> to keep them as simple as possible. Doing IO and other complexities
> just doesn't make sense. Just have the simplest possible path
> that can do the job.

And since it's difficult to prove, I think it's nice to have an
option to panic if the memory error was on dirty page cache.

It's theoretically same as disk I/O error; dirty cache is marked invalid
and next read will go to disk.
Though in practice, the next read will likely to fail if disk was broken.
(Given that transient errors are usually recovered by retries and fail-overs
 in storage stack and not visible to applications which don't care.)
So it's "consistent" in some sense.
OTOH, the next read will likely succeed reading old data from disk
in case of the memory error.
I'm afraid the read-after-write inconsistency could cause silent data
corruption.

-- 
Jun'ichi Nomura, NEC Corporation
