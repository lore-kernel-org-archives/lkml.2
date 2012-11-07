Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2KGVj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 16:39:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab2KGVj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 16:39:56 -0500
Date: Wed, 7 Nov 2012 19:39:30 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v11 1/7] mm: adjust
 address_space_operations.migratepage() return code
Message-ID: <20121107213929.GB10444@optiplex.redhat.com>
References: <cover.1352256081.git.aquini@redhat.com>
 <74bc30697313206e1225f6fc658bc5952b588dcc.1352256085.git.aquini@redhat.com>
 <20121107115610.c0cb650c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107115610.c0cb650c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 11:56:10AM -0800, Andrew Morton wrote:
> On Wed,  7 Nov 2012 01:05:48 -0200
> Rafael Aquini <aquini@redhat.com> wrote:
> 
> > This patch introduces MIGRATEPAGE_SUCCESS as the default return code
> > for address_space_operations.migratepage() method and documents the
> > expected return code for the same method in failure cases.
> 
> I hit a large number of rejects applying this against linux-next.  Due
> to the increasingly irritating sched/numa code in there.
> 
> I attempted to fix it up and also converted some (but not all) of the
> implicit tests of `rc' against zero.
> 
> Please check the result very carefully - more changes will be needed.
> 
> All those
> 
> -	if (rc)
> +	if (rc != MIGRATEPAGE_SUCCESS)
> 
> changes are a pain.  Perhaps we shouldn't bother.

Thanks for doing that.

This hunk at migrate_pages(), however, is not necessary:

@@ -1001,7 +1001,7 @@ out:
        if (!swapwrite)
               	current->flags &= ~PF_SWAPWRITE;

-	if (rc)
+       if (rc != MIGRATEPAGE_SUCCESS)
                return rc;

Here, migrate_pages() is not testing rc for the migration success, but it's just trying to
devise the flow if it has to return -ENOMEM, actually.

I guess, a change to make that snippet more clear could be:

diff --git a/mm/migrate.c b/mm/migrate.c
index 77ed2d7..6562aee 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -987,7 +987,7 @@ int migrate_pages(struct list_head *from,
                        case -EAGAIN:
                                retry++;
                                break;
-                       case 0:
+                       case MIGRATEPAGE_SUCCESS:
                                break;
                        default:
                                /* Permanent failure */
@@ -996,15 +996,12 @@ int migrate_pages(struct list_head *from,
                        }
                }
        }
-       rc = 0;
+       rc = nr_failed + retry;
 out:
        if (!swapwrite)
                current->flags &= ~PF_SWAPWRITE;
 
-       if (rc)
-               return rc;
-
-       return nr_failed + retry;
+       return rc;
 }


I can rebase this patch and resubmit if you prefer
