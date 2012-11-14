Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161150Ab2KNLNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:13:18 -0500
Received: from claranet-outbound-smtp03.uk.clara.net ([195.8.89.36]:59843 "EHLO
	claranet-outbound-smtp03.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390Ab2KNLNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:13:16 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into inotify_inode_mark
Date: Wed, 14 Nov 2012 11:12:59 +0000
Message-ID: <5758501.NTghZx9OdD@deuteros>
User-Agent: KMail/4.8.4 (Linux/3.4.6-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <50A378C0.70406@parallels.com>
References: <20121112101440.665694060@openvz.org> <1491483.8kFV7tRC1p@deuteros> <50A378C0.70406@parallels.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2012 14:56:00 Pavel Emelyanov wrote:
> >>> How much space does a typical file system need to encode a handle? Am I
> >>> right that for must it is just a few bytes? (I just glanced at the code
> >>> so I might be wrong.) In which case, could the handle buffer be
> >>> allocated
> >>> dynamically depending on the underlying filesystem? Perhaps adding a
> >>> facility to query a filesystem about its maximum handle buffer needs? Do
> >>> you think the saving would justify this extra work?
> >> 
> >> Well, the MAX_HANDLE_SZ is taken from NFSv4 and is 128 bytes which is
> >> quite
> >> big for inotify extension indeed. The good news is that this amount of
> >> bytes seem to be required for the most descriptive fhandle -- with info
> >> about parent, etc. We don't need such, we can live with shorter handle,
> >> people said that 40 bytes was enough for that.
> >> 
> >> However, your idea about determining the handle size dynamically seems
> >> promising. As far as I can see from the code we can call for encode_fh
> >> with
> >> size equals zero and filesystem would report back the amount of bytes it
> >> requires for a handle.
> >> 
> >> We can try going this route, what do you think?
> > 
> > Sounds much better since that would only add one pointer to the watch
> > structure in the normal case.
> > 
> > Also at checkpoint time it will use only a few bytes (compared to 64) for
> > the encode buffer for most filesystems. This part is probably not that
> > important but still a win.
> 
> No, the thing is -- we need to know the handle _before_ we start checkpoint.
> More exactly -- at the time the inotify_add_watch is called. So the memory
> save would be not that big.

Ah yes, I forgot about that. But the saving is quite solid as Cyrill already 
wrote.

It is still a bit unfortunate you have to have handles allocated all the time 
just because C&R is compiled in. There is no way you could ask the filesystem 
to create you one on demand. What would you need? Just the superblock and 
inode, or more?

Regards,

Tvrtko

