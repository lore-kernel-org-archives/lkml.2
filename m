Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab2CIT3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:29:17 -0500
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:55679
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752537Ab2CIT3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:29:16 -0500
Date: Fri, 9 Mar 2012 20:29:12 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Adding Secure Deletion to UBIFS
In-Reply-To: <1331278562.22872.18.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1203091959570.25737@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>  <1330536308.3545.158.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1203011434220.2462@eristoteles.iwoars.net> <1331278562.22872.18.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> I wonder also if it is wise to enable secure deletion globally. Yes, we
> pay the cost of maintaining the keys anyways, but we could avoid paying
> the costs at deletion time when deleting non-securely.
>
> Isn't it wiser to have a special interface for secure deletion which
> would be slower than normal deletion? I believe this is the right
> approach. And I believe block-based file-systems would go this way. Just
> think about MMC which has secure erase trim which is so slow - I do not
> think anyone would use it for everything by default - people would have
> a separate interface.

Here there is a wide space of solutions. One approach used in block-based
systems is to use a +s attribute, and then progate this whenever files are
copied etc. However, it presents the major useability problem in that a
user must remember to set this attribute for this files. And no
application can be reliably expected to set this value correctly since it
is not a standard action. Sensitive data not marked as such will thus not
be securely deleted. It suffers the same way as requiring users to use srm
when appropriate---after the first time they forget they'll probably never
again remember.

In this solution, keys are marked to be deleted when the data node
encrypted with that key is removed from the TNC. So a really simple
change:
1. node is added - key marked as used;
2. node is removed - key marked as deleted;
3. node is modified to a new value; old key marked deleted, new key marked
as used.

The keys themselves are not immediately removed, this occurs during
UBIFS commit (although it can also happen independently, but also as a
periodic background action). Thus, deletion has a low cost, just erasing
the small set of key storing blocks in the background, and the cost will
likely be
the same regardless if the entire partition is purged instead of
just some data marked as sensitive: it only takes one key on an
LEB to warrant erasure of the LEB, and there are (LEB_SIZE >> 16)
keys per LEB.

However, without caching the keys in the TNC, then deletion takes as long
as reading a file. Thankfully, it will be nowhere near as bad as MMC
secure erase trim, which (I presume) actually GCs and erases all the EBs that
store file data. In this solution, it only needs to read the data node's
header to get the key position, and mark it as deleted. Deletion happens
in the backgroun.

To me, being able to set secure erase or not as a partition level setting
makes alot of sense. The OS partition does not need it, but the user file data
partition will have it, and UBI makes sense that wear levelling is done
among all the partitions properly. Then taint status for files'
sensitivity doesn't need to be maintained. The deployer simply chooses for
this part of the FS, do they want secure deletion over the data or not,
one time at the beginning. (Compare this to the decision on whether or
not to encrypt their entire partition or later encrypting each file they
make.)


>
> Did you explore, by the way, if something like this is being worked on
> for other FSes in Linux?
>

In my related works research I found nothing like this. Some advocated
putting a key in the inode for a file then securely deleting things at a
file-level granularity by GC and erasing the inode. Another suggestion
multiple overwrites with zeros but that doesn't seem like it works with
modern denser flash memories.

I'll remove the change to tree branch, and repost correctly the
version change where only data node is effected. Btw, when I was
developing it I used the last 8 bytes from the key as the key position,
because the key was 16 bytes but only 8 were used. Could you comment on
the last 8 bytes of ubifs keys?


Joel
