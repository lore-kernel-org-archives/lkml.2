Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0FEHoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 03:44:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64003 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab0FEHoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 03:44:18 -0400
Message-ID: <4C0A005A.10607@vflare.org>
Date: Sat, 05 Jun 2010 13:14:26 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Minchan Kim <minchan.kim@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Support generic I/O requests
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>	<1275379286-10453-2-git-send-email-ngupta@vflare.org> <20100604121041.1b88b0af.akpm@linux-foundation.org>
In-Reply-To: <20100604121041.1b88b0af.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2010 12:40 AM, Andrew Morton wrote:
> On Tue,  1 Jun 2010 13:31:23 +0530
> Nitin Gupta <ngupta@vflare.org> wrote:
> 

>> Usage/Examples:
>>  1) Use as /tmp storage
>>  - mkfs.ext4 /dev/zram0
>>  - mount /dev/zram0 /tmp
> 
> hm, how does that work?  The "device" will only handle page-sized and
> page-aligned requests, won't it?  Can you walk us through what happens
> when the fs does a 512-byte I/O?
> 

Yes, it still handles page-size aligned, n*page_size sized I/O requests.

Unfortunately, I don't know much of vfs/filesystem details, so I could not
trace out the exact path. But, given that we set logical and physical sector
size to PAGE_SIZE, the block layer (and filesytem) should make sure that we
get correctly aligned, correctly sized I/O requests. I just discovered this
fact through experimentation and didn't know making it a generic device is
actually this easy.

Given that I lack detailed knowledge in this area, there may be some corner
cases where we may get unaligned I/O requests (in which case we simply return
I/O error) but successful run of 'dd' and 'iozone' tests (links in patch 0/4)
increased my confidence in this :)

The only change that was needed to make it generic device was to
iterate over all bio segments (earlier it was hard-coded to handle
just the first one).

>>  - Double caching: We can potentially waste memory by having
>> two copies of a page -- one in page cache (uncompress) and
>> second in the device memory (compressed). However, during
>> reclaim, clean page cache pages are quickly freed, so this
>> does not seem to be a big problem.
> 
> Yes, clean pagecache is cheap.  But what happens when the pagecache
> copy of the page gets modified?
> 

Dirty pages are periodically flushed to disk (zram in this case) and
then it becomes clean again.

> Or is it the case that once a compressed page gets copied out to
> pagecache, the compressed version is never used again?  If so, the
> memory could be synchronously freed, so I guess I don't understand what
> you mean here.

We cannot free a page as soon as it is decompressed and added to page cache.
When a clean page is reclaimed, it is simply freed and not written out to
disk and thus, we will end up losing this data.

The only opportunity to free a (compressed) disk page is when filesystem
issues a block discard request or, when used as a swap disk, we get a swap
slot free notification (a callback for this was recently added to
struct block_device_operations).

> 
>>  - Stale data: Not all filesystems support issuing 'discard'
>> requests to underlying block devices. So, if such filesystems
>> are used over zram devices, we can accumulate lot of stale
>> data in memory. Even for filesystems to do support discard
>> (example, ext4), we need to see how effective it is.
> 
> Can you walk us through how zram uses discard requests?
> 

I could not get discard working (yet), so support for this was
removed from these patches. I hope to include it soon.

Thanks for your feedback.
Nitin

