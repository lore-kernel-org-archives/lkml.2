Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab2EAO05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 10:26:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64781 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2EAO04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 10:26:56 -0400
MIME-Version: 1.0
In-Reply-To: <x49lilcm1tb.fsf@segfault.boston.devel.redhat.com>
References: <x49pqaom2u4.fsf@segfault.boston.devel.redhat.com>
	<CAPa8GCAgDU8FYdMuWsn2PuUW0GQxdKWJV6K0SmQEzb3s1GHxwA@mail.gmail.com>
	<x49lilcm1tb.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 2 May 2012 00:26:55 +1000
Message-ID: <CAPa8GCChTmXTmjY5GvsFsvXpP_WSuiiWMRDu7Lvb71G9tW1PTw@mail.gmail.com>
Subject: Re: [patch|rfc] block: don't mark buffers beyond end of disk as mapped
From: Nick Piggin <npiggin@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jaxboe@fusionio.com, Kyle McMartin <kmcmarti@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 00:08, Jeff Moyer <jmoyer@redhat.com> wrote:
> Nick Piggin <npiggin@gmail.com> writes:
>
>> Not a bad fix. But it's kind of sad to have i_size checking logic also in
>> block_read_full_page, that does not cope with this.
>>
>> I have found there are parts of the kernel (readahead) that try to read
>> beyond EOF and seem to get angry if we return an error (by not
>> marking uptodate in readpage) in that case though :(
>>
>> But, either way, I think it's very reasonable to not mark buffers beyond
>> end of device as mapped. So I think your patch is fine.
>>
>> I guess for ext[234], it does not read metadata close to the end of the
>> device or you were using 4K sized blocks?
>
> Well, the test case just reads directly from the loop device, bypassing
> the file system, and I did use 1KB blocks when making the file system, so
> it is quite puzzling.

It's because buffer_head creation does not go through the same paths
for bdev file access versus getblk APIs.

blkdev_get_block does the right thing there

In fact, it's probably good to unify the checks here, i.e., use max_blocks()

Thanks,
Nick
