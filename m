Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2JEL6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:58:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334Ab2JEL6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:58:03 -0400
Message-ID: <506ECB8F.80509@redhat.com>
Date: Fri, 05 Oct 2012 07:59:11 -0400
From: Brian Foster <bfoster@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Theodore Tso <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 110/180] ext4: dont let i_reserved_meta_blocks go negative
References: <6a854f579a99b4fe2efaca1057e8ae22@local> <20121001225202.266707400@1wt.eu> <20121004215528.GK13292@decadent.org.uk>
In-Reply-To: <20121004215528.GK13292@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 05:55 PM, Ben Hutchings wrote:
> On Tue, Oct 02, 2012 at 12:53:47AM +0200, Willy Tarreau wrote:
>> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Brian Foster <bfoster@redhat.com>
>>
>> commit 97795d2a5b8d3c8dc4365d4bd3404191840453ba upstream.
>>
>> If we hit a condition where we have allocated metadata blocks that
>> were not appropriately reserved, we risk underflow of
>> ei->i_reserved_meta_blocks.  In turn, this can throw
>> sbi->s_dirtyclusters_counter significantly out of whack and undermine
>> the nondelalloc fallback logic in ext4_nonda_switch().  Warn if this
>> occurs and set i_allocated_meta_blocks to avoid this problem.
>>
>> This condition is reproduced by xfstests 270 against ext2 with
>> delalloc enabled:
>>
>> Mar 28 08:58:02 localhost kernel: [  171.526344] EXT4-fs (loop1): delayed block allocation failed for inode 14 at logical offset 64486 with max blocks 64 with error -28
>> Mar 28 08:58:02 localhost kernel: [  171.526346] EXT4-fs (loop1): This should not happen!! Data will be lost
>>
>> 270 ultimately fails with an inconsistent filesystem and requires an
>> fsck to repair.  The cause of the error is an underflow in
>> ext4_da_update_reserve_space() due to an unreserved meta block
>> allocation.
> [...]
>> +	if (unlikely(ei->i_allocated_meta_blocks > ei->i_reserved_meta_blocks)) {
>> +		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, allocated %d "
>> +			 "with only %d reserved metadata blocks\n", __func__,
>> +			 inode->i_ino, ei->i_allocated_meta_blocks,
>> +			 ei->i_reserved_meta_blocks);
>> +		WARN_ON(1);
>> +		ei->i_allocated_meta_blocks = ei->i_reserved_meta_blocks;
>> +	}
> [...]
>  
> This seems to be working around a bug elsewhere.  Has the underlying
> bug been fixed in mainline yet?
> 

Yes, the bug was fixed in:

03179fe92318e7934c180d96f12eff2cb36ef7b6
ext4: undo ext4_calc_metadata_amount if we fail to claim space

Brian

> Ben.
> 

