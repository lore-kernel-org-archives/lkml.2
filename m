Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab2GGBQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 21:16:31 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:14866 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2GGBQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 21:16:29 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=omFFwXVALcGQOHOtJL09sTUbPnAshsVCgKNta0ky/3iqyytfFmwf8fzGkJza
	/ucHQGhga4evKz/WBYoom2i/qXSJqFIzOFGJzGYzzAIoNs+9LOt5qkOR6
	Ko+c4yeC5aYHto2pYdT1FPw4KmzkNkDoLQhbf21oARlM8kWfl4DDJ4=;
X-Spam-Processed: mail.digidescorp.com, Fri, 06 Jul 2012 20:16:28 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.144.163.32
X-Return-Path: prvs=1535ec46b0=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341623782.2021.9.camel@iscandar>
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted
 inodes/dentries
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 06 Jul 2012 20:16:22 -0500
In-Reply-To: <871ukobntl.fsf@devron.myhome.or.jp>
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	 <1341342576-15394-3-git-send-email-steve@digidescorp.com>
	 <87pq8bokcp.fsf@devron.myhome.or.jp>
	 <1341606824.2214.14.camel@iscandar.digidescorp.com>
	 <871ukobntl.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-07 at 06:07 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> > On Wed, 2012-07-04 at 20:07 +0900, OGAWA Hirofumi wrote: 
> >> Please don't add new lock_super() usage if it is not necessary. Almost
> >> all of lock_super() just replaced lock_kernel() usage. It rather should
> >> be removed in future.  Probably, this should use inode->i_mutex instead.
> >> 
> >> BTW, the above issue is same with all of directory read.
> >
> > I don't think there's really an alternative here. The cases addressed by
> > this patch all involve walking on-disk structures via
> > unofficial/temporary inodes created from information in the NFS handle
> > (i.e., outside the normal inode creation paths). When this process is
> > successful we end up with "official" connected inodes/dentries, but
> > getting there is really a "bottom up" strategy instead of the usual "top
> > down" approach.
> >
> > Because the "bottom up" method is lacking guarantees that "top down"
> > takes for granted - i.e., that a cluster on disk that's supposed to be a
> > directory actually *is* a directory -  I am adding some defensive code
> > in the next spin of the patch.
> 
> I'm not sure what you meant. Where is the problem? ->get_name()? If so,
> it has parent dentry parameter. What is the wrong if we take
> mutex_lock(parent->d_inode)?

The temporary/"unofficial" inodes are unhashed and thus not visible
outside of the functions using them. They exist only to support access
to directory contents when we can't gain that access via other means
(because we only have "bottom up" information, about an object and
perhaps its parent, in a form that can't be used to look up hashed
inodes/dentries). Hashing them wouldn't help, because they don't have
the correct key (for instance, in the case of a ".." entry).

Am I missing something?

Steve
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


