Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934436Ab2C3UBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:01:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42345 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759578Ab2C3UBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:01:16 -0400
Date: Fri, 30 Mar 2012 16:01:12 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs fixes and features
Message-ID: <20120330200112.GK755@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120330175106.GB755@shiny>
 <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F76110B.00BB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 12:50:26PM -0700, Linus Torvalds wrote:
> On Fri, Mar 30, 2012 at 10:51 AM, Chris Mason <chris.mason@oracle.com> wrote:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> 
> This causes a new warning for me:
> 
>   fs/btrfs/extent_io.c: In function ‘repair_eb_io_failure’:
>   fs/btrfs/extent_io.c:1940:6: warning: ‘ret’ may be used
> uninitialized in this function

Interesting that my gcc doesn't warn here.  Strictly speaking, gcc isn't
wrong, but num_extent_pages() will always be at least 1.  This function
is new in this pull, so it can't be a conflict.

Do you want a new pull with the ret = 0 patch?

int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer
*eb,
			 int mirror_num)
{
	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
	u64 start = eb->start;
	unsigned long i, num_pages = num_extent_pages(eb->start, eb->len);
	int ret;

	for (i = 0; i < num_pages; i++) {
		struct page *p = extent_buffer_page(eb, i);
		ret = repair_io_failure(map_tree, start, PAGE_CACHE_SIZE,
					start, p, mirror_num);
		if (ret)
			break;
		start += PAGE_CACHE_SIZE;
	}

	return ret;
}

-chris
