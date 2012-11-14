Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab2KNLDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:03:42 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:48794 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2KNLDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:03:40 -0500
Date: Wed, 14 Nov 2012 15:03:31 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
Message-ID: <20121114110331.GI16685@moon>
References: <20121112101440.665694060@openvz.org>
 <2092535.8S9EcgmZCZ@deuteros>
 <50A37692.1010500@parallels.com>
 <1491483.8kFV7tRC1p@deuteros>
 <50A378C0.70406@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A378C0.70406@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 02:56:00PM +0400, Pavel Emelyanov wrote:
> >>> How much space does a typical file system need to encode a handle? Am I
> >>> right that for must it is just a few bytes? (I just glanced at the code
> >>> so I might be wrong.) In which case, could the handle buffer be allocated
> >>> dynamically depending on the underlying filesystem? Perhaps adding a
> >>> facility to query a filesystem about its maximum handle buffer needs? Do
> >>> you think the saving would justify this extra work?
> >>
> >> Well, the MAX_HANDLE_SZ is taken from NFSv4 and is 128 bytes which is quite
> >> big for inotify extension indeed. The good news is that this amount of bytes
> >> seem to be required for the most descriptive fhandle -- with info about
> >> parent, etc. We don't need such, we can live with shorter handle, people
> >> said that 40 bytes was enough for that.
> >>
> >> However, your idea about determining the handle size dynamically seems
> >> promising. As far as I can see from the code we can call for encode_fh with
> >> size equals zero and filesystem would report back the amount of bytes it
> >> requires for a handle.
> >>
> >> We can try going this route, what do you think?
> > 
> > Sounds much better since that would only add one pointer to the watch 
> > structure in the normal case.
> > 
> > Also at checkpoint time it will use only a few bytes (compared to 64) for the 
> > encode buffer for most filesystems. This part is probably not that important 
> > but still a win.
> 
> No, the thing is -- we need to know the handle _before_ we start checkpoint.
> More exactly -- at the time the inotify_add_watch is called. So the memory save
> would be not that big.

for the worst case (NFSv4) it'll be 128 bytes + 8|4 byte pointer, but for
more common cases such as extXfs it'll be shrinked down to 8 byte handle +
8|4 byte pointer, which is a pretty good i think.
