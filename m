Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2GIQ1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 12:27:10 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:15046 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2GIQ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:27:09 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=WeXqf7QHxQb6kuwqBFyfY5voFjesZ8gc7Lg4OvWFaaILK6t/+hV9eHMuCPDk
	/QtOfzgSpTTS9AwqbyYo3zVh2ScUs4R8vPc3rjhAMLpl/U8/Lq58UIkik
	n4d5iy/K3UtMyefQxaGx9pKKCRzZ/UhShWgzJXG4rpYv3YL0ghN7Eg=;
X-Spam-Processed: mail.digidescorp.com, Mon, 09 Jul 2012 11:27:06 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1537d3712a=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341851223.2215.22.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted
 inodes/dentries
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 11:27:03 -0500
In-Reply-To: <87obnooqz7.fsf@devron.myhome.or.jp>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 01:10 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> > On Mon, 2012-07-09 at 22:43 +0900, OGAWA Hirofumi wrote: 
> >> "Steven J. Magnani" <steve@digidescorp.com> writes:
> >> 
> >> >> We need the key, possible key is - if it is only directory, FAT may be
> >> >> able to use i_start as additional search key.
> >> >
> >> > Interesting idea. I think this, and reformulating the FAT NFS file
> >> > handle to include the parent's i_ino, will greatly simplify (and speed
> >> > up) the code.
> >> 
> >> Does it work even if the inode was rename()'ed?
> >
> > AFAICT. I don't see why it wouldn't; on a rename, the inode's i_pos
> > changes but its i_ino stays the same, right?
> 
> If the inode is not on cache anymore, is there the possibility that
> selects the wrong parent? IIRC, NFS Server can be rebooted at any time
> while the client using the same file handle.

True, but it's looking like we can just use the default handle
constructed by export_encode_fh(), namely (i_ino, i_generation,
parent->i_ino, parent->i_generation). None of those components should
change in a server reboot.

Also, my thinking now is that there's no reliable way to reconstruct
evicted inodes. I was going to drop that portion of the patch, and stick
to fixing reconnection of cached inodes to dentries. Clients who are
sensitive to ESTALE should mount with subtree_check (so that parent
information is included in the NFS file handles, increasing our ability
to reconnect), and either handle ESTALE at the application level, or via
patches such as Jeff Layton's series
(https://lkml.org/lkml/2012/6/29/381 - I will be testing this shortly).

> > Do you have any objection to making the use of a directory logstart
> > cache a mount option that defaults to off? It seems a shame to penalize
> > everyone - particularly embedded systems - with the overhead of such a
> > cache when FAT-backed-NFS seems to be such a small percentage of use
> > cases.
> 
> I'm not sure what did it mean. It means to remove i_logstart from NFS
> file handle?

I am proposing to remove i_logstart from the file handle but what I was
asking here is whether the population of the new logstart index you've
proposed could be optional.

Maybe it's time to post a new spin of the patch so we are all talking
about the same concrete thing.
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


