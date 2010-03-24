Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab0CXSDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:03:35 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:56024 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674Ab0CXSCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:02:52 -0400
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4BAA5035.1060906@panasas.com>
References: <4BAA3493.1030802@panasas.com>
	 <20100324160037.GP30031@ZenIV.linux.org.uk>	<4BAA3828.2070506@panasas.com>
	 <20100324160754.GQ30031@ZenIV.linux.org.uk>	<4BAA398C.5050901@panasas.com>
	 <20100324163948.GR30031@ZenIV.linux.org.uk>	<4BAA48A3.1030801@panasas.com>
	 <4BAA4CAC.6060104@panasas.com>  <4BAA5035.1060906@panasas.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 14:02:36 -0400
Message-ID: <1269453756.5982.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 7 sum msgs/h 1 total rcpts 2605 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 23F97611CB1009430C3ADEE1D6117A5688766EC8
X-UiO-SPAM-Test: remote_host: 130.129.30.233 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 5 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 19:47 +0200, Boaz Harrosh wrote: 
> On 03/24/2010 07:32 PM, Boaz Harrosh wrote:
> > On 03/24/2010 07:15 PM, Boaz Harrosh wrote:
> >> On 03/24/2010 06:39 PM, Al Viro wrote:
> >>> On Wed, Mar 24, 2010 at 06:10:52PM +0200, Boaz Harrosh wrote:
> >>>> On 03/24/2010 06:07 PM, Al Viro wrote:
> >>>>> On Wed, Mar 24, 2010 at 06:04:56PM +0200, Boaz Harrosh wrote:
> >>>>>>> Bloody impressive...  Does that happen to underlying fs or to what you
> >>>>>>> are seeing via NFS?
> >>>>>>
> >>>>>> Only via NFS. All local access is fine.
> >>>>>>
> >>>>>> After the corruption above I can cd to the local mount cp a fresh copy
> >>>>>> of .git/index file and play around just fine.
> >>>>>> Once I return to the NFS mounted directory, a git status will do it.
> >>>>>> It does not matter if caches are cold (Takes a long time) or hot it happens
> >>>>>> every time.
> >>>>>>
> >>>>>> Weird I know, I'm playing some more with it as we speak
> >>>>>
> >>>>> What happens if you export to box running older kernel *or* from box
> >>>>> running older kernel?  IOW, is that nfsd or nfs client getting unhappy?
> >>>>> I'd suspect the latter, but...
> >>>>
> >>>>
> >>>> Good question, I'm just getting to that because currently it's all
> >>>> over localhost (same kernel, BTW inside a UML)
> >>>>
> >>>> I will try what you said. Please through any other tests on me, if needed.
> >>>
> >>
> >> As you suspected old-server+new-client fails. any-thing+old-client is
> >> fine. (two separate machines this time)
> >>
> >>> Very interesting...  Just to see which path we are hitting: add
> >>> 	if (IS_ERR(nd->intent.open.file))
> >>> 		printk("foo: %s", pathname);
> >>> right after
> >>>                 error = do_lookup(nd, &nd->last, path);
> >>>                 if (error)
> >>>                         goto exit;
> >>> in fs/namei.c:do_last() and see whether we are hitting it or not on objects
> >>> that get corrupted.
> >>
> >> Sorry was busy shifting setups, didn't see your mail, will do that next ...
> >>
> >> Thanks
> >> Boaz
> > 
> > 
> > Below is what I changed. (I hope its what you meant)
> > It does not get hit, just that git corruption as before but I don't see the prints.
> > I'll try running with nfs dbg-prints on see what it does around the time gits complains
> > 
> > Boaz
> > 
> 
> Attached is an output of when I:
> $ echo $((0x7fff)) > /proc/sys/sunrpc/nfs_debug
> and then run git status. (On a new client)
> 
> We can see the complains after things got broken but what broke it
> that's hard for me to see.
> 
> (If the file is too big I'll put it on the web somewhere, see if it arrives)
> 
> Boaz

Something weird is going on in your trace:

NFS: open file(5b/46ff70a61cf4e159a0339df0e02113bf35f805)
NFS: permission(0:12/323044), mask=0x24, res=0
NFS: revalidating (0:12/323044)
--> nfs4_setup_sequence clp 00000000791f3000 session (null) sr_slotid
128
<-- nfs4_setup_sequence status=0
encode_compound: tag=
decode_attr_type: type=00
decode_attr_change: change attribute=10077553255782547456
decode_attr_size: file size=921
decode_attr_fsid: fsid=(0x0/0x0)
decode_attr_fileid: fileid=0
decode_attr_fs_locations: fs_locations done, error = 0
decode_attr_mode: file mode=00
decode_attr_nlink: nlink=1
decode_attr_owner: uid=-2
decode_attr_group: gid=-2
decode_attr_rdev: rdev=(0x0:0x0)
decode_attr_space_used: space used=0
decode_attr_time_access: atime=0
decode_attr_time_metadata: ctime=1269422731
decode_attr_time_modify: mtime=1269422731
decode_attr_mounted_on_fileid: fileid=0
decode_getfattr: xdr returned 0

A file type of '0' in the above trace is just wrong, and probably
indicates that the server didn't even return that attribute.

I'd say you have a corruption issue either on the server side or on your
client.

Trond

