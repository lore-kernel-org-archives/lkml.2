Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab2AYQfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:35:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab2AYQfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:35:09 -0500
Message-ID: <4F202F2E.9000608@redhat.com>
Date: Wed, 25 Jan 2012 10:34:54 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
CC: xfs@oss.sgi.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: Does Ext4 support parallel write similar to XFS?
References: <CADDb1s2w9ZwMXn38n8TcxhFNrUsXN1Gnxq-suAP2-M+R7YhFsg@mail.gmail.com>
In-Reply-To: <CADDb1s2w9ZwMXn38n8TcxhFNrUsXN1Gnxq-suAP2-M+R7YhFsg@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/12 11:19 PM, Amit Sahrawat wrote:
> In XFS we can write parallel (i.,e we can make use of allocation
> groups for writing process). If the files are kept in individual
> directories, there is a possibility that first the blocks for that
> files be used from individual allocation groups. If I start ‘4’
> writing process(cp 100MB_file /<dirnum>/) – after writing is finished
> – if I check the bmap – it does shows that initial allocation was from
> individual allocation groups.
> Even though in Ext4 also we do have groups – but I am not able to get
> behavior similar to XFS.
> If I check the file extents – the extents are in mixed form, the
> allocation pattern is also very fragmented.
> 
> Please share more on this. Also, if there is a possible exact test
> case to check for parallel writes support.

It seems that you are asking more about allocation policy than parallelism
in general?  With either filesystem, you could use preallocation to wind
up with more contiguous files when you write them in parallel, though
that requires some idea of the file size ahead of time.

ext4 doesn't have that exact dir::group heuristic that xfs uses,
but it does have other mechanisms and heuristics to try to get good
file and directory layout.

In general, ext4 tries to put new root directories into new groups, see
comments above find_group_orlov().  Other directories tend to stay near
their parent directory.  So it's really the roots of dir trees that
get spread across the disk in general.  New non-dir inodes also tend to
stay close to their parent.  (I think I have that all right ...)

The test you describe above does result in more contiguous allocation on
xfs than on ext4, though - a quick check on kernel 3.2 yielded 2-3
extents per file on ext4, 1 extent per file for xfs.

-Eric

> Thanks & Regards,
> Amit Sahrawat
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

