Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab1LNOwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:52:46 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:42186 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754380Ab1LNOwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:52:44 -0500
Message-ID: <4EE8B810.8040405@tao.ma>
Date: Wed, 14 Dec 2011 22:52:00 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Li Shaohua <shaohua.li@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: ext4 data=writeback performs worse than data=ordered now
References: <20111214133400.GA18565@localhost> <20111214143014.GB18080@thunk.org>
In-Reply-To: <20111214143014.GB18080@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.40.102 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted/Fengguang,
On 12/14/2011 10:30 PM, Ted Ts'o wrote:
> On Wed, Dec 14, 2011 at 09:34:00PM +0800, Wu Fengguang wrote:
>> Hi,
>>
>> Shaohua recently found that ext4 writeback mode could perform worse
>> than ordered mode in some cases. It may not be a big problem, however
>> we'd like to share some information on our findings.
>>
>> I tested both 3.2 and 3.1 kernels on normal SATA disks and USB key.
>> The interesting thing is, data=writeback used to run a bit faster
>> than data=ordered, however situation get inverted presumably by the
>> IO-less dirty throttling.
> 
> Interesting.  What sort of workloads are you using to do these
> measurements?  How many writer threads; I assume you are doing
> sequential writes which are extending one or more files, etc?
> 
> I suspect it's due to the throttling meaning that each thread is
> getting to send less data to the disk, and so there is more seeking
> going on with data=writeback, where as with data=ordered, at each
> journal commit we are forcing all of the dirty pages out to disk, one
> inode at a time, and this is resulting in a more efficient writeback
> compared to when the writeback code is getting to make its own choices
> about how much each inode gets to write out at at time.
> 
> It would be interesting to see what would happen if in
> ext4_da_writepages(), we completely ignore how many pages are
> requested to be written back by the writeback code, and just simply
> write back all of the dirty pages, and see if that brings the
> performance back.
I guess fengguang's test is a buffer write dd test. Here we have found
some performance regression from 18 because of the delayed allocation.
In case of delayed allocation, we will create the extent tree during
writepages which would delay the write because ext4_da_write_begin would
down_read the i_data_sem to map the block while writepages would
down_write it so we have seen some severe delay in ext4_da_write_begin
(around 3s). And instead of increasing the page numbers of every
writepages, some tests shows that the decrease makes the performance
increase. I will dive into it soon to see what's going on there.

So Fengguang, would you please keep the page number in
ext4_da_writepages passed by writeback(instead of the bumping) and check
the result?

Thanks
Tao
