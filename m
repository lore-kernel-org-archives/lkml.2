Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1ASHMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 02:12:17 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56193 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191Ab1ASHMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 02:12:16 -0500
X-Sasl-enc: O+49T4W506Oc8usCshAvkyHpTrdvWh0QC+X71d3KNugk 1295421028
Subject: Re: [PATCH 0/3] Fixes for vfs-scale and vfs-automount
From: Ian Kent <raven@themaw.net>
To: Nick Piggin <npiggin@suse.de>, David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
References: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 15:06:57 +0800
Message-ID: <1295420817.3076.24.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 12:05 +0800, Ian Kent wrote:
> I noticed a couple of problems which needed to be fixed before I can
> start testing.

Before I return to testing I thought I should let everyone know the
results so far, following the addition of the merged patches from this
thread.

I have two tests, the first is the autofs connectathon test suite.
It consists of a wide range of automount map constructs, and contains
both success and failure cases and results in about 260 mounts. I
usually run the test 3 times, and wait for the mounts to expire between
runs.

The connectathon test worked fine and I didn't observe any unexpected
log messages over the three runs.

The second test I run has been adapted from one of the connectathon
tests. This test uses autofs submounts which are the most problematic of
the autofs map constructs. The modified test is meant to introduce a
fairly high level of contention by using a number of processes accessing
the mounts at the same time (currently configured as 10 processes). I
also attempt to introduce expire to mount contention by adjusting the
expire timeout. In addition the test runs twice, one the the default
nobrowse option and one for the browse option (no need to worry about
what that means). All in all the test seems to be fairly good at
exposing problems and 150 iterations of each configuration seems to get
most problems within three consecutive runs.

The first run of this test returned a pass although there were some
unexpected log messages. I'm not sure yet what is causing these. Of
interest was a bunch of reported lstat() failures against directories
that corresponded to failure cases and should not have existed at all.

The second run went through to completion but triggered the BUG() at
line 941 in shrink_dcache_for_umount_subtree() when shutting down autofs
after the first (nobrowse) part of the test run.

So, there is still a ref count problem somewhere, at least.

> 
> Nick, David, can you check my changes please, particularly the cases
> for the do_lookup() change.
> 
> ---
> 
> Ian Kent (3):
>       autofs4 - fix debug print in autofs4_lookup()
>       vfs - fix dentry ref count in do_lookup()
>       autofs4 - fix get_next_positive_dentry()
> 
> 
>  fs/autofs4/expire.c |    4 ++--
>  fs/autofs4/root.c   |    3 ++-
>  fs/namei.c          |    5 ++++-
>  3 files changed, 8 insertions(+), 4 deletions(-)
> 


