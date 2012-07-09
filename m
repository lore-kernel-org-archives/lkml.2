Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2GIU0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:26:20 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:44992 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2GIU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:26:18 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=JEuiD7Cub7f0PKA7e3kw0FHtzOiaySfEVxtmhG5DkCi/XnUjZBoTAr/MsWO/
	rt8/UHhCxFnZzp8TEx8qtF99uWDRVEGuyAUAPahzYptgsI/SF1MSGzq/Z
	gwPmmDkODgEjSuPURXzi3YhX+COi3BcHKJYFLc+aEygLnakPzpY2o0=;
X-Spam-Processed: mail.digidescorp.com, Mon, 09 Jul 2012 15:26:15 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1537d3712a=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341865572.31078.2.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted
 inodes/dentries
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 15:26:12 -0500
In-Reply-To: <87bojooinr.fsf@devron.myhome.or.jp>
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	 <1341342576-15394-3-git-send-email-steve@digidescorp.com>
	 <87pq8bokcp.fsf@devron.myhome.or.jp>
	 <1341606824.2214.14.camel@iscandar.digidescorp.com>
	 <871ukobntl.fsf@devron.myhome.or.jp> <1341623782.2021.9.camel@iscandar>
	 <87wr2g9kh3.fsf@devron.myhome.or.jp> <1341679286.2435.12.camel@iscandar>
	 <87zk7bo6aq.fsf@devron.myhome.or.jp>
	 <1341835422.2215.6.camel@iscandar.digidescorp.com>
	 <87sjd1nj7s.fsf@devron.myhome.or.jp>
	 <1341845277.2215.10.camel@iscandar.digidescorp.com>
	 <87obnooqz7.fsf@devron.myhome.or.jp>
	 <1341851223.2215.22.camel@iscandar.digidescorp.com>
	 <1341853758.2215.34.camel@iscandar.digidescorp.com>
	 <87bojooinr.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 04:10 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> >> > >> > Interesting idea. I think this, and reformulating the FAT NFS file
> >> > >> > handle to include the parent's i_ino, will greatly simplify (and speed
> >> > >> > up) the code.
> >> > >> 
> >> > >> Does it work even if the inode was rename()'ed?
> >> > >
> >> > > AFAICT. I don't see why it wouldn't; on a rename, the inode's i_pos
> >> > > changes but its i_ino stays the same, right?
> >> > 
> >> > If the inode is not on cache anymore, is there the possibility that
> >> > selects the wrong parent? IIRC, NFS Server can be rebooted at any time
> >> > while the client using the same file handle.
> >> 
> >> True, but it's looking like we can just use the default handle
> >> constructed by export_encode_fh(), namely (i_ino, i_generation,
> >> parent->i_ino, parent->i_generation). None of those components should
> >> change in a server reboot.
> >
> > I think I misunderstood you when I wrote this. I assumed we were talking
> > about a restart of nfsd, not the entire machine it was running on. If
> > there is a danger of mismapping on a reboot isn't that present in the
> > existing mainline code, i.e. fat_fh_to_dentry()? Ideally, the (i_ino,
> > i_generation) signature would be different on a reboot, although with
> > only 2-second granularity in i_generation I suppose that's less likely
> > than we would prefer. Also I would think that many inodes simply
> > wouldn't exist in the cache, in which case we would fail the operation
> > with ESTALE.
> 
> Ah, i_ino. I was talking about i_pos. Well, so, what happens if the
> child was renamed to other parent on NFS server machine (not via nfs
> client)? The file handle would be including the old i_ino, and the old
> i_ino on file handle is still vaild as old parent. So, it returns the
> wrong parent?

Yes, but I believe exportfs_decode_fh() handles that case:

  /*
   * Now that we've got both a well-connected parent and a
   * dentry for the inode we're after, make sure that our
   * inode is actually connected to the parent.
   */


Really, the FAT NFS code will pretty much parallel that of ext2.
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>



