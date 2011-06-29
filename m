Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1F2RLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:11:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50255 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1F2RK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:10:59 -0400
Message-ID: <4E0B5C6F.3060803@oracle.com>
Date: Wed, 29 Jun 2011 10:10:07 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>, Josef Bacik <josef@redhat.com>,
        linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110629065306.GC1026@dastard> <20110629074021.GA26086@infradead.org>
In-Reply-To: <20110629074021.GA26086@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E0B5C87.0066:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 12:40 AM, Christoph Hellwig wrote:
> On Wed, Jun 29, 2011 at 04:53:07PM +1000, Dave Chinner wrote:
>> On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
>>> This is a test to make sure seek_data/seek_hole is acting like it does on
>>> Solaris.  It will check to see if the fs supports finding a hole or not and will
>>> adjust as necessary.
>> So I just looked at this with an eye to validating an XFS
>> implementation, and I came up with this list of stuff that the test
>> does not cover that I'd need to test in some way:
>>
>> 	- files with clean unwritten extents. Are they a hole or
>> 	  data? What's SEEK_DATA supposed to return on layout like
>> 	  hole-unwritten-data? i.e. needs to add fallocate to the
>> 	  picture...
>>
>> 	- files with dirty unwritten extents (i.e. dirty in memory,
>> 	  not on disk). They are most definitely data, and most
>> 	  filesystems will need a separate lookup path to detect
>> 	  dirty unwritten ranges because the state is kept
>> 	  separately (page cache vs extent cache).  Plenty of scope
>> 	  for filesystem specific bugs here so needs a roubust test.
> The discussion leading up to the resurrection of SEEK_HOLE/SEEK_DATA
> was pretty much about that point.  The conclusion based on the Sun
> documentation and common sense was that SEEK_DATA may only consider
> unwritten extents as hole if the filesystem has a way to distinguish
> plain unwritten extents and those that have been dirtied.  Else it
> should be considered data.
>
> Testing for making sure dirty preallocated areas aren't wrongly
> reported sounds relatively easy, the rest falls into implementation
> details, which imho is fine.  Not reporting preallocated extents
> as holes just is a quality of implementation issue and not a bug.

I agree. And if I might add my 2 cents that it would be much easier
if we added another test that created files with all the worrisome boundary
conditions and used SEEK_DATA/HOLE to copy the files and compared
using md5sum. This would be far easier than one that expects a certain
pos for each operation.
