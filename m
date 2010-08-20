Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0HTP3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:29:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:58780 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab0HTP33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:29:29 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger@dilger.ca>
Subject: Re: [GIT PULL] notification tree: directory events
Date: Fri, 20 Aug 2010 17:29:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>,
        linux-fsdevel@vger.kernel.org
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <5FB2A21F-95D3-4B99-A521-74346EEEAF5B@dilger.ca> <20100820092127.GC20138@infradead.org>
In-Reply-To: <20100820092127.GC20138@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008201729.09535.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 August 2010 11:21:27 Christoph Hellwig wrote:
> On Thu, Aug 19, 2010 at 11:19:07PM -0600, Andreas Dilger wrote:
> > What about unifying the file identification here with the file handle
> > used for open_by_handle()?  That keeps a consistent identifier for the
> > inode between multiple system calls (always a good thing), and allows
> > the inode to be opened again via open_by_handle() if needed.
> 
> That's what the dmapi callouts that are intendeded to do just about the
> same as fanotify always did.  I'm pretty sure I brought this up earlier
> in the discussion.

I remember you bringing this up.

The persistent handles require CAP_DAC_READ_SEARCH for using open_by_handle() 
to prevent an unprivileged process from forging handles and bypassing 
directory permission checks.  This would be okay for users of fanotify which 
can listen to all events in their namespace (and which requires CAP_SYS_ADMIN 
anyway).

I don't see how open_by_handle() could be made safe to use by arbitrary 
processes; I don't think we can make the handles cryptographically strong, for 
example.  But I may be overlooking something here.

[Side note: checking for CAP_DAC_READ_SEARCH in fanotify would probably be 
enough when no perm events are involved because dentry_open() performs tail 
permission checks anyway.]

In the future it will make sense to extend fanotify to allow unprivileged 
processes to listen to "their own" events, for example, like inotify does 
today.  (You know that providing a better inotify replacement was one of the 
goals of fanotify before it got merged anyway.)  Unprivileged processes 
wouldn't be allowed to use open_by_handle() anymore though, and so file 
handles still look like a better choice for fanotify to me.

Thanks,
Andreas
