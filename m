Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0HKNKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:10:04 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:40085 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751871Ab0HKNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:10:03 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 30J5qpQVM1nMIZDDh9Gmzms677H5evNh.U49fai7Ulnskqv
 gaajspDPFeurO2LvfEaIGZhxFgsWdq_LD2uPhD5XO21VYpsMY.2QCVqRMJYo
 KsUs0ft33M3.QHTo8GFSd07UWcvewHllNnDq6NyxdxsA9AV66vbOUg.6agWa
 XrdHuwAdN4IWY37zNCTg3DcTHbGfLmSWbzv1.0f4zLebJ5t2oOgkMtnWMvCy
 _
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 11 Aug 2010 08:09:59 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] Hugepage migration (v2)
In-Reply-To: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.00.1008110806070.673@router.home>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010, Naoya Horiguchi wrote:

> There were two points of issue.
>
> * Dividing hugepage migration functions from original migration code.
>   This is to avoid complexity.
>   In present version, some high level migration routines are defined to handle
>   hugepage, but some low level routines (such as migrate_copy_page() etc.)
>   are shared with original migration code in order not to increase duplication.

I hoped that we can avoid the branching for taking stuff off the lru and
put pages back later to the lru. Seems that we still do that. Can be
refactor the code in such a way that the lru handling cleanly isolates?
There are now multiple use cases for migration that could avoid LRU
handling even for PAGE_SIZE pages.

> * Locking problem between direct I/O and hugepage migration
>   As a result of digging the race between hugepage I/O and hugepage migration,
>   (where hugepage I/O can be seen only in direct I/O,)
>   I noticed that without additional locking we can avoid this race condition
>   because in direct I/O we can get whether some subpages are under I/O or not
>   from reference count of the head page and hugepage migration safely fails
>   if some references remain.  So no data lost should occurs on the migration
>   concurrent with direct I/O.

Can you also avoid refcounts being increased during migration? The page
lock is taken for the PAGE_SIZEd migration case. Can direct I/O be stopped
by taking the page lock on the head page? If not then races can still
occur.

