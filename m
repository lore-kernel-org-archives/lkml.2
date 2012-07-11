Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab2GKOzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:55:17 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34288 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab2GKOzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:55:15 -0400
Date: Wed, 11 Jul 2012 22:54:12 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: "Purdila, Octavian" <octavian.purdila@intel.com>
Cc: Ram Pai <linuxram@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] resource: make sure requested range intersects root range
Message-ID: <20120711145412.GA2430@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1341057657-7823-1-git-send-email-octavian.purdila@intel.com>
 <20120710143348.d977da44.akpm@linux-foundation.org>
 <20120711020902.GC13885@ram-ThinkPad-T61>
 <CAE1zotK=2nK_pRsg8C6MuGqOKZut96MgWy-ru2dkPOQQF--U3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotK=2nK_pRsg8C6MuGqOKZut96MgWy-ru2dkPOQQF--U3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071114-2398-0000-0000-00000865A5C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 02:06:10PM +0300, Purdila, Octavian wrote:
> On Wed, Jul 11, 2012 at 5:09 AM, Ram Pai <linuxram@us.ibm.com> wrote:
> 
> >
> > Wait.. I am not sure this will fix the problem entirely. The above check
> > will handle the case where the range requested is entirey out of the
> > root's range.  But if the requested range overlapps that of the root
> > range, we will still call __reserve_region_with_split() and end up with
> > a recursion if there is a overflow. Wont we?
> >
> 
> Good catch. I will fix this as well as address Andrew's and Joe's
> comments in a new patch. The only question is how to handle the
> overlap case:
> 
> (a) abort the whole request or
> 
> (b) try to reserve the part that overlaps (and adjust the request to
> avoid the overflow)
> 
> I think (b) is more in line with the current implementation for reservations.


I prefer (b).  following patch should handle that.

diff --git a/kernel/resource.c b/kernel/resource.c
index e1d2b8e..dd87fde 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -780,6 +780,10 @@ static void __init __reserve_region_with_split(struct resource *root,
 
 	if (conflict->start > start)
 		__reserve_region_with_split(root, start, conflict->start-1, name);
+
+	if (conflict->end == parent->end )
+		return;
+
 	if (conflict->end < end)
 		__reserve_region_with_split(root, conflict->end+1, end, name);
 }

RP

