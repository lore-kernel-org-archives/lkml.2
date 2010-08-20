Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0HTUjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:39:44 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:28077 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab0HTUjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:39:40 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=37qdrPIVUooonMxFi2BWZ8DhoCRe+hJcgJuumZcJ4K8= c=1 sm=1
 a=_3D-azteyJAA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=X5HIPg_mzqVYZtpeRpsA:9
 a=OH-q9ySdR_-1iJLrJ0MA:7 a=UQwoFyk4C-9aBLAsZT81XgRkcdEA:4 a=CjuIK1q_8ugA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [GIT PULL] notification tree: directory events
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <201008201729.09535.agruen@suse.de>
Date: Fri, 20 Aug 2010 14:39:39 -0600
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
        Matt Helsley <matthltc@us.ibm.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, Michael Kerrisk <michael.kerrisk@gmail.com>,
        linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5FBC3180-1402-4C44-802C-31ADAE5DB50D@dilger.ca>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <5FB2A21F-95D3-4B99-A521-74346EEEAF5B@dilger.ca> <20100820092127.GC20138@infradead.org> <201008201729.09535.agruen@suse.de>
To: Andreas Gruenbacher <agruen@suse.de>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-20, at 09:29, Andreas Gruenbacher wrote:
> On Friday 20 August 2010 11:21:27 Christoph Hellwig wrote:
>> On Thu, Aug 19, 2010 at 11:19:07PM -0600, Andreas Dilger wrote:
>>> What about unifying the file identification here with the file handle
>>> used for open_by_handle()?  That keeps a consistent identifier for the
>>> inode between multiple system calls (always a good thing), and allows
>>> the inode to be opened again via open_by_handle() if needed.
>> 
>> That's what the dmapi callouts that are intended to do just about the
>> same as fanotify always did.  I'm pretty sure I brought this up earlier
>> in the discussion.
> 
> I remember you bringing this up.
> 
> The persistent handles require CAP_DAC_READ_SEARCH for using open_by_handle() 
> to prevent an unprivileged process from forging handles and bypassing 
> directory permission checks.  This would be okay for users of fanotify which 
> can listen to all events in their namespace (and which requires CAP_SYS_ADMIN 
> anyway).
> 
> I don't see how open_by_handle() could be made safe to use by arbitrary 
> processes; I don't think we can make the handles cryptographically strong, for 
> example.  But I may be overlooking something here.

If the file handles only need to have a limited lifetime for unprivileged processes, then they can contain a random salt that is kept on the in-core inode.  For me and my intended HPC use case this would be a useful addition for open_by_handle() to allow unprivileged process access.  At worst, if the inode is evicted from memory the process would redo the name_to_handle(), or do the slower open-by-path().

I suspect it would also be possible to have an array of per-superblock (or global) crypto keys that are hashed with the file handle data.  That avoids the per-inode memory, and allows a well-defined lifetime for the handle (minutes, hours, days) only as a function of how quickly the crypto key needs to rotate (based on key length and attack speed) and the size of the array that is kept.

> In the future it will make sense to extend fanotify to allow unprivileged 
> processes to listen to "their own" events, for example, like inotify does 
> today.  (You know that providing a better inotify replacement was one of the 
> goals of fanotify before it got merged anyway.)  Unprivileged processes 
> wouldn't be allowed to use open_by_handle() anymore though, and so file 
> handles still look like a better choice for fanotify to me.


Cheers, Andreas





