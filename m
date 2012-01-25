Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab2AYSGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 13:06:20 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59151 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885Ab2AYSGS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 13:06:18 -0500
References: <CADDb1s2w9ZwMXn38n8TcxhFNrUsXN1Gnxq-suAP2-M+R7YhFsg@mail.gmail.com> <4F202F2E.9000608@redhat.com>
In-Reply-To: <4F202F2E.9000608@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=utf-8
Message-Id: <D5446EEA-D3AF-43BB-B862-6C9A741B0DC9@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ChristophHellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
X-Mailer: iPhone Mail (9A405)
From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: Does Ext4 support parallel write similar to XFS?
Date: Wed, 25 Jan 2012 11:06:29 -0700
To: Eric Sandeen <sandeen@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-25, at 9:34, Eric Sandeen <sandeen@redhat.com> wrote:
> On 1/24/12 11:19 PM, Amit Sahrawat wrote:
>> In XFS we can write parallel (i.,e we can make use of allocation
>> groups for writing process). If the files are kept in individual
>> directories, there is a possibility that first the blocks for that
>> files be used from individual allocation groups. If I start ‘4’
>> writing process(cp 100MB_file /<dirnum>/) – after writing is finished
>> – if I check the bmap – it does shows that initial allocation was from
>> individual allocation groups.
>> Even though in Ext4 also we do have groups – but I am not able to get
>> behavior similar to XFS.
>> If I check the file extents – the extents are in mixed form, the
>> allocation pattern is also very fragmented.
>> 
>> Please share more on this. Also, if there is a possible exact test
>> case to check for parallel writes support.
> 
> It seems that you are asking more about allocation policy than parallelism
> in general?  With either filesystem, you could use preallocation to wind
> up with more contiguous files when you write them in parallel, though
> that requires some idea of the file size ahead of time.
> 
> ext4 doesn't have that exact dir::group heuristic that xfs uses,
> but it does have other mechanisms and heuristics to try to get good
> file and directory layout.
> 
> In general, ext4 tries to put new root directories into new groups, see
> comments above find_group_orlov().  Other directories tend to stay near
> their parent directory.  So it's really the roots of dir trees that
> get spread across the disk in general.  New non-dir inodes also tend to
> stay close to their parent.  (I think I have that all right ...)

Note that this policy of new subdirectory placement (and indirectly the placement of files created therein) can be tuned by userspace by setting the "topdir" flag via setattr on the parent directory. 

This will push new subdirs created in that dir to a new group, which would In turn allow the files to allocate from that group. It is intended to be set on directories like /home where files within the subdirs are unrelated.

Whether that is enough for your usage is unclear. 

> The test you describe above does result in more contiguous allocation on
> xfs than on ext4, though - a quick check on kernel 3.2 yielded 2-3
> extents per file on ext4, 1 extent per file for xfs.
> 
> -Eric
> 
>> Thanks & Regards,
>> Amit Sahrawat
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
