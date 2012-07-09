Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2GIRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:09:26 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:31166 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2GIRJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:09:24 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=6Rd+21ztOLeW+ysSht9ZTcwNIgJeIXyegaP+1sS+qzDF4tPbZfz5TiGKU9iX
	tqVyA0hDxvIPZfGdz9CBVxjVCf6Z1DD2C85V5GngtDIocO+Umw6JD3C4q
	ircteTRJ6ySquHodFcWw9iQLx1XpdDL5E9pGGJoRHT3+LFCfOGhftg=;
X-Spam-Processed: mail.digidescorp.com, Mon, 09 Jul 2012 12:09:22 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1537d3712a=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341853758.2215.34.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted
 inodes/dentries
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 12:09:18 -0500
In-Reply-To: <1341851223.2215.22.camel@iscandar.digidescorp.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 11:27 -0500, Steven J. Magnani wrote: 
> On Tue, 2012-07-10 at 01:10 +0900, OGAWA Hirofumi wrote: 
> > "Steven J. Magnani" <steve@digidescorp.com> writes:
> > 
> > > On Mon, 2012-07-09 at 22:43 +0900, OGAWA Hirofumi wrote: 
> > >> "Steven J. Magnani" <steve@digidescorp.com> writes:
> > >> 
> > >> >> We need the key, possible key is - if it is only directory, FAT may be
> > >> >> able to use i_start as additional search key.
> > >> >
> > >> > Interesting idea. I think this, and reformulating the FAT NFS file
> > >> > handle to include the parent's i_ino, will greatly simplify (and speed
> > >> > up) the code.
> > >> 
> > >> Does it work even if the inode was rename()'ed?
> > >
> > > AFAICT. I don't see why it wouldn't; on a rename, the inode's i_pos
> > > changes but its i_ino stays the same, right?
> > 
> > If the inode is not on cache anymore, is there the possibility that
> > selects the wrong parent? IIRC, NFS Server can be rebooted at any time
> > while the client using the same file handle.
> 
> True, but it's looking like we can just use the default handle
> constructed by export_encode_fh(), namely (i_ino, i_generation,
> parent->i_ino, parent->i_generation). None of those components should
> change in a server reboot.

I think I misunderstood you when I wrote this. I assumed we were talking
about a restart of nfsd, not the entire machine it was running on. If
there is a danger of mismapping on a reboot isn't that present in the
existing mainline code, i.e. fat_fh_to_dentry()? Ideally, the (i_ino,
i_generation) signature would be different on a reboot, although with
only 2-second granularity in i_generation I suppose that's less likely
than we would prefer. Also I would think that many inodes simply
wouldn't exist in the cache, in which case we would fail the operation
with ESTALE.

------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>



