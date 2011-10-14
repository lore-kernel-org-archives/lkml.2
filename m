Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab1JNU7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:59:52 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59252 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1JNU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:59:50 -0400
Date: Fri, 14 Oct 2011 13:59:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Barry <abarry@cray.com>, linux-mm <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Hastings <abh@cray.com>
Subject: Re: [PATCH v2 1/1] hugepages: Fix race between hugetlbfs umount and
 quota update.
Message-Id: <20111014135948.a45a8ac1.akpm@linux-foundation.org>
In-Reply-To: <20111012044317.GA31436@drongo>
References: <4E4EB603.8090305@cray.com>
	<20110819145109.dcd5dac6.akpm@linux-foundation.org>
	<20111012044317.GA31436@drongo>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011 15:43:17 +1100
Paul Mackerras <paulus@samba.org> wrote:

> In the meantime we have a user-triggerable kernel crash.  As far as I
> can see, if we did what you suggest, we would end up with a situation
> where we could run out of huge pages even though everyone was within
> quota.  Which is arguably better than a kernel crash, but still less
> than ideal.  What do you suggest?

My issue with the patch is that it's rather horrible.  We have a layer
of separation between core hugetlb pages and hugetlbfs.  That layering
has already been mucked up in various places and this patch mucks it up
further, and quite severely.

So I believe we should rethink the patch.  Either a) get the layering
correct by not poking into hugetlbfs internals from within hugetlb core
via one of the usual techniques or b) make a deliberate decision to
just give up on that layering: state that hugetlb and hugetlbfs are now
part of the same subsystem.  Make the necessaary Kconfig changes,
remove ifdefs, move code around, etc.

If we go ahead with the proposed patch-n-run bugfix, the bad code will
be there permanently - nobody will go in and clean this mess up and the
kernel is permanently worsened.
