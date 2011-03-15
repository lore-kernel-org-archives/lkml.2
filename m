Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1COFRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:17:30 -0400
Received: from mea1b5e42.tmodns.net ([66.94.27.234]:48661 "EHLO mail.tmail.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750839Ab1COFR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:17:29 -0400
X-Greylist: delayed 7770 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Mar 2011 01:17:29 EDT
Subject: Re: ext4 deep stack with mark_page_dirty reclaim
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20110314204627.GB8120@thunk.org>
Date: Mon, 14 Mar 2011 19:25:10 -0700
Cc: Hugh Dickins <hughd@google.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FE7209AC-C66C-4482-945E-58CF5AF8FEE7@dilger.ca>
References: <alpine.LSU.2.00.1103141156190.3220@sister.anvils> <20110314204627.GB8120@thunk.org>
To: "Ted Ts'o" <tytso@mit.edu>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-14, at 1:46 PM, Ted Ts'o wrote:
> On Mon, Mar 14, 2011 at 12:20:52PM -0700, Hugh Dickins wrote:
>> When testing something else on 2.6.38-rc8 last night,
>> I hit this x86_64 stack overflow.  I've never had one before,
>> it seems worth reporting.  kdb was in, I jotted it down by hand
>> (the notifier part of it will be notifying kdb of the fault).
>> CONFIG_DEBUG_STACK_OVERFLOW and DEBUG_STACK_USAGE were not set.
>> 
>> I should disclose that I have a hack in which may make my stack
>> frames slightly larger than they should be: check against yours.
>> So it may not be an overflow for anyone else, but still a trace
>> to worry about.
> 
> Here's the trace translated to the stack space used by each function.
> There are a few piggy ext4 functions that we can try to shrink, but
> the real problem is just how deep the whole stack is getting.
> 
> From the syscall to the lowest-level ext4 function is 3712 bytes, and
> everything from there to the schedule() which then triggered the GPF
> was another 3728 of stack space....

Is there a script which you used to generate this stack trace to function size mapping, or did you do it by hand?  I've always wanted such a script, but the tricky part is that there is so much garbage on the stack that any automated stack parsing is almost useless.  Alternately, it would seem trivial to have the stack dumper print the relative address of each symbol, and the delta from the previous symbol...

To be honest, I think the stack size limitation is becoming a serious problem in itself.  While some stack-size reduction effort is actually useful in removing inefficiency, I think there is a lot of crazy and inefficient things to try and minimize the stack usage (e.g. lots of kmalloc/kfree of temporary arrays instead of just putting them on the stack), which ends up consuming _more_ total memory.

This can be seen with deep storage stacks that are using the network on both ends, like NFS+{XFS, ext4}+LVM+DM+{fcoib,iSCSI}+driver+kmalloc or similar...  The below stack isn't even using something so convoluted.

> 240 schedule+0x25a
> 368 io_schedule+0x35
>  32 get_request_wait+0xc6
> 160 __make_request+0x36d
> 112 generic_make_request+0x2f2
> 208 submit_bio+0xe1
> 144 swap_writepage+0xa3
>  80 pageout+0x151
> 128 shrink_page_list+0x2db
> 176 shrink_inactive_list+0x2d3
> 256 shrink_zone+0x17d
> 224 shrink_zones+0x0xa3
> 128 do_try_to_free_pages+0x87
> 144 try_to_free_mem_cgroup_pages+0x8e
> 112 mem_cgroup_hierarchical_reclaim+0x220
> 176 mem_cgroup_do_charge+0xdc
> 128 __mem_cgroup_try_charge+0x19c
> 128 mem_cgroup_charge_common+0xa8
> 128 mem_cgroup_cache_charge+0x19a
> 128 add_to_page_cache_locked+0x57
>  96 add_to_page_cache_lru+0x3e
>  80 find_or_create_page+0x69
> 112 grow_dev_page+0x4a
>  96 grow_buffers+0x41
>  64 __getblk_slow+0xd7
>  80 __getblk+0x44
>  80 __ext4_get_inode_loc+0x12c
> 176 ext4_get_inode_loc+0x30
>  48 ext4_reserve_inode_write+0x21
>  80 ext4_mark_inode_dirty+0x3b
> 160 ext4_dirty_inode+0x3e
>  64 __mark_inode_dirty+0x32
>  80 linux/fs.h       mark_inode_dirty
>   0 linux/quotaops.h dquot_alloc_space
>   0 linux/quotaops.h dquot_alloc_block
>   0 ext4_mb_new_blocks+0xc2
> 144 ext4_alloc_blocks+0x189
> 208 ext4_alloc_branch+0x73
> 208 ext4_ind_map_blocks+0x148
> 272 ext4_map_blocks+0x148
> 112 ext4_getblk+0x5f
> 144 ext4_bread+0x36
>  96 ext4_append+0x52
>  96 do_split+0x5b
> 224 ext4_dx_add_entry+0x4b4
> 304 ext4_add_entry+0x7c
> 176 ext4_add_nondir+0x2e
>  80 ext4_create+0xf5
> 144 vfs_create+0x83
>  96 __open_namei_create+0x59
>  96 do_last+0x13b
> 112 do_filp_open+0x2ae
> 384 do_sys_open+0x72
> 128 sys_open+0x27
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





