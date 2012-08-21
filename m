Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab2HUMJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:09:16 -0400
Received: from fieldses.org ([174.143.236.118]:59878 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab2HUMJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:09:14 -0400
Date: Tue, 21 Aug 2012 08:09:09 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120821120908.GB9483@fieldses.org>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.591460800@openvz.org>
 <87fw7habo4.fsf@skywalker.in.ibm.com>
 <20120820163338.GN23596@moon>
 <20120820183225.GB4911@fieldses.org>
 <20120820190606.GE27443@moon>
 <20120820193204.GD5779@fieldses.org>
 <50335261.5090504@parallels.com>
 <87wr0sle4v.fsf@skywalker.in.ibm.com>
 <503367CB.9080609@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503367CB.9080609@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 02:49:47PM +0400, Pavel Emelyanov wrote:
> On 08/21/2012 02:42 PM, Aneesh Kumar K.V wrote:
> > Pavel Emelyanov <xemul@parallels.com> writes:
> > 
> >> On 08/20/2012 11:32 PM, J. Bruce Fields wrote:
> >>> On Mon, Aug 20, 2012 at 11:06:06PM +0400, Cyrill Gorcunov wrote:
> >>>> On Mon, Aug 20, 2012 at 02:32:25PM -0400, J. Bruce Fields wrote:
> >>>>> On Mon, Aug 20, 2012 at 08:33:38PM +0400, Cyrill Gorcunov wrote:
> >>>>>> On Mon, Aug 20, 2012 at 07:49:23PM +0530, Aneesh Kumar K.V wrote:
> >>>>>>> Cyrill Gorcunov <gorcunov@openvz.org> writes:
> >>>>>>>
> >>>>>>>> To provide fsnotify object inodes being watched without
> >>>>>>>> binding to alphabetical path we need to encode them with
> >>>>>>>> exportfs help. This patch adds a helper which operates
> >>>>>>>> with plain inodes directly.
> >>>>>>>
> >>>>>>> doesn't name_to_handle_at()  work for you ? It also allows to get a file
> >>>>>>> handle using file descriptor.
> >>>>>>
> >>>>>> Hi, sorry for dealy. Well, the last idea is to get rid of this helper,
> >>>>>> I've sent out an updated version where ino+dev is only printed.
> >>>>>
> >>>>> I don't understand how ino and dev are useful to you, though, if you're
> >>>>> still hoping to be able to look up inodes using this information later
> >>>>> on.
> >>>>
> >>>> Hi Bruce, I believe having ino+dev is better than nothing. Otherwise we
> >>>> simply have no clue which targets are bound to inotify mark. Sometime
> >>>> (!) we can try to generate fhandle in userspace from this ino+dev bundle
> >>>> and then open the target file.
> >>>
> >>> That's insufficient to generate a filehandle in general.
> >>
> >> Yes, sure, but for live migration having inode and device is enough and that's why.
> >> We can use two ways of having a filesystem on the target machine in the same
> >> state (from paths points of view) as it was on destination one:
> >>
> >> 1. copy file tree in a rsync manner
> >> 2. copy a virtual disk image file
> >>
> >> In the 1st case we can map inode number to path easily, since we iterate over a filesystem

OK.  Then you don't care about unlinked files?

If the filesystem's frozen by the time you get here, I suppose you could
also just use paths?

> >> anyway. I agree, that rsync is not perfect for migration but still.
> >>
> >> In the 2nd case we can generate filehandle out of an inode number only since we _do_ know
> >> that inode will not get reused.
> > 
> > If you are going to to use open_by_handle, then that handle is not
> > sufficient right ? Or do you have open_by_inode ? as part of c/r ?
> 
> Why? For e.g. ext4 you can construct a handle in userspace and open by it.

If it's a real filehandle you want, in general you don't want to
construct it in userspace--depending on the filesystem it may require
filesystem-specific knowledge.

--b.

> 
> >>
> >> However, if you have some better ideas on what information about inode should be exported
> >> to the userspace please share.
> >>
> > 
> > Why not use name_to_handle(fd,...) and open_by_handle(handle,..) ?
> 
> Because we don't have an fd at hands by the time we need to know the handle.
> 
> > 
> >>> (Also: there's the usual inode-number aliasing problem: the inode number
> >>> could get reused by another file.  Unless you know the file is being
> >>> held open the whole time.)
> >>>
> > 
> > -aneesh
> > 
> > .
> > 
> 
> Thanks,
> Pavel
