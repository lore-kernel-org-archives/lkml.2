Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab2CIHda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:33:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:56043 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab2CIHd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:33:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="119331428"
Message-ID: <1331278562.22872.18.camel@sauron.fi.intel.com>
Subject: Re: [patch] Adding Secure Deletion to UBIFS
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 09 Mar 2012 09:36:02 +0200
In-Reply-To: <alpine.DEB.2.00.1203011434220.2462@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	 <1330536308.3545.158.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203011434220.2462@eristoteles.iwoars.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-01 at 14:41 +0100, Joel Reardon wrote:
> This is true. The reason its done is as an optimization for the 
> following reason.
> 
> When deleting a data node, the key position is marked as deleted.

Would you please explain again how the key position is being marked as
deleted please. Would be nice to have a wiki or a public document with
design reference somewhere, so you could just point "see page 5" as an
answer, and update it if needed.

>  The key 
> positions then requires a datanode read to find.

Sorry, would you please provide a bit more detailed information. I am
sure you explained it before, but the explanation is buried somewhere.

I am ready to create an ubifs branch for you and keep a text file with
design/FAQ there, and update the branch as UBIFS moves forward, and
apply your small incremental patches - as soon as we have an
applicable / nice patch.

>  By keeping it in memory (thus the TNC), 
> marking a key pos as deleted doesn't require a flash read.


Well, I'd say that this should be solved with another layer of caching.
E.g., we have so called "LNC" (Leaf node cache) - we keep direntries at
the leaf level to avoid extra reads. You could extend LNC and keep keys
there.

Consider this approach:

1. You throw out this optimization so far
2. Keep working on your stuff - you have enough issues to deal with.
You'll have less compatibility issues when you throw that out. The
design will be simpler as well.
3. When / if other things are done, you try to extend LNC to always
cache the keys.

>  This improves 
> e.g., truncations and full file deletion speed, which would otherwise read 
> each data node from flash to get the positions. If it is not stored in 
> ubifs_branch (but still stored in the tree), then it would have to be 
> loaded once 'on-demand' after mounting. This is also an option, of course. 
> Currently, deleting a file performs a walk on all the TNC's data nodes 
> that are removed, so the extra mark-delete incurs no observable cost.

I wonder also if it is wise to enable secure deletion globally. Yes, we
pay the cost of maintaining the keys anyways, but we could avoid paying
the costs at deletion time when deleting non-securely.

Isn't it wiser to have a special interface for secure deletion which
would be slower than normal deletion? I believe this is the right
approach. And I believe block-based file-systems would go this way. Just
think about MMC which has secure erase trim which is so slow - I do not
think anyone would use it for everything by default - people would have
a separate interface.

Did you explore, by the way, if something like this is being worked on
for other FSes in Linux?


-- 
Best Regards,
Artem Bityutskiy

