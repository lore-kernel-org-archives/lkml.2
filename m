Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab2KNKyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:54:24 -0500
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:44236 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932870Ab2KNKyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:54:21 -0500
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
Date: Wed, 14 Nov 2012 10:54 +0000
Message-ID: <1491483.8kFV7tRC1p@deuteros>
User-Agent: KMail/4.8.4 (Linux/3.4.6-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <50A37692.1010500@parallels.com>
References: <20121112101440.665694060@openvz.org> <2092535.8S9EcgmZCZ@deuteros> <50A37692.1010500@parallels.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2012 14:46:42 Pavel Emelyanov wrote:
> On 11/14/2012 02:38 PM, Tvrtko Ursulin wrote:
> > On Wednesday 14 November 2012 14:13:41 Pavel Emelyanov wrote:
> >> On 11/14/2012 02:08 PM, Tvrtko Ursulin wrote:
> >>> On Wednesday 14 November 2012 13:58:12 Cyrill Gorcunov wrote:
> >>>> On Wed, Nov 14, 2012 at 09:50:55AM +0000, Tvrtko Ursulin wrote:
> >>>>>>> You could not use a pointer and then allocate your buffers on the
> >>>>>>> check
> >>>>>>> point operation, freeing on restore?
> >>>>>> 
> >>>>>> The problem is not allocating the memory itself but rather the time
> >>>>>> when
> >>>>>> the information needed (ie the dentry) is available. The only moment
> >>>>>> when we can use dentry of the target file/directory is at
> >>>>>> inotify_new_watch, that's why i need to compose fhandle that early.
> >>>>>> At
> >>>>>> any later point we simply have no dentry to use.
> >>>>> 
> >>>>> But you do not fundamentally need the dentry to restore a watch,
> >>>>> right?
> >>>> 
> >>>> dentry only needed to encode the file handle.
> >>>> 
> >>>>> Couldn't you restore, creating a new restore path if needed, using the
> >>>>> inode which is pinned anyway while the watch exists?
> >>>> 
> >>>> plain inode is not enough as far as i can tell, iow i don't see the way
> >>>> to restore path from inode solely. or there something i miss?
> >>> 
> >>> I don't know, as I said I was not following this at all until now. Just
> >>> throwing in ideas.
> >>> 
> >>> I thought, since inotify does not use the path or dentry outside the
> >>> system
> >>> call at all, perhaps you need a different entry point allowing you to
> >>> restore the watch using the inode or something. Assuming life time of
> >>> objects and stuff in C&R world would allow you that. Since you don't
> >>> need
> >>> the full path, just something 64 bytes long, I assumed that could be the
> >>> case.
> >> 
> >> Well, the kernel already has all the API we need but one -- it shows us
> >> _nothing_ about the inode being watched. And we'd appreciate any
> >> information about it. Even the ino:dev pair would work. We propose to
> >> show
> >> the handle because we believe, that such API is better that ino:dev. You
> >> can get the handle, call the open_by_handle_at right at once and get much
> >> much more information about the inode with any other API (e.g. calling
> >> fstat() will give you the ino:dev pair). Having just ino:dev pair at
> >> hands
> >> is not that flexible.
> > 
> > How much space does a typical file system need to encode a handle? Am I
> > right that for must it is just a few bytes? (I just glanced at the code
> > so I might be wrong.) In which case, could the handle buffer be allocated
> > dynamically depending on the underlying filesystem? Perhaps adding a
> > facility to query a filesystem about its maximum handle buffer needs? Do
> > you think the saving would justify this extra work?
> 
> Well, the MAX_HANDLE_SZ is taken from NFSv4 and is 128 bytes which is quite
> big for inotify extension indeed. The good news is that this amount of bytes
> seem to be required for the most descriptive fhandle -- with info about
> parent, etc. We don't need such, we can live with shorter handle, people
> said that 40 bytes was enough for that.
> 
> However, your idea about determining the handle size dynamically seems
> promising. As far as I can see from the code we can call for encode_fh with
> size equals zero and filesystem would report back the amount of bytes it
> requires for a handle.
> 
> We can try going this route, what do you think?

Sounds much better since that would only add one pointer to the watch 
structure in the normal case.

Also at checkpoint time it will use only a few bytes (compared to 64) for the 
encode buffer for most filesystems. This part is probably not that important 
but still a win.

Regards,

Tvrtko

