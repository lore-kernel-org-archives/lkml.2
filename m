Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0JQCMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 22:12:09 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:58879 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757228Ab0JQCMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 22:12:07 -0400
Date: Sun, 17 Oct 2010 13:11:38 +1100
From: Dave Chinner <david@fromorbit.com>
To: "J.H." <warthog9@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        devel@lists.fedoraprojet.org
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
Message-ID: <20101017021138.GG32255@dastard>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
 <20101017003526.GA29677@dastard>
 <4CBA4933.1080108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBA4933.1080108@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 05:54:11PM -0700, J.H. wrote:
> There does seem to be a boot option to disable it, but it seems to be on
> by default if it's compiled in, and it's not like it's obvious that this
> is there and chewing up resources, is there a way to find out how much
> memory this is chewing up?

$ grep iint_cache /proc/slabinfo | awk '// { print $2 * ($4 + 560) / 1048576 "MiB" }'
1164.91MiB
$

$ while [ 1 ]; do
> grep iint_cache /proc/slabinfo | awk '// { print $2 * ($4 + 560) / 1048576 "MiB" }'
> sleep 5
> done
955.706MiB
937.438MiB
928.851MiB
920.912MiB
919.067MiB
919.086MiB
919.111MiB
.....

This is only with about 1.2M inodes cached - yesterday I saw the
inode cache grow to 3.5M inodes during an rsync run....

Also, it's doing a good job of fragmenting the radix tree node cache
- it's currently at 50% population - 3.8M entries, 1.9M in use. i.e.
wasting another ~1GB of RAM itself right now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
