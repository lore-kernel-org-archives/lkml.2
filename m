Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab0FPVAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:00:55 -0400
Received: from emroute1.ornl.gov ([160.91.4.119]:46863 "EHLO emroute1.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670Ab0FPVAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:00:51 -0400
X-Greylist: delayed 965 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jun 2010 17:00:51 EDT
Date: Wed, 16 Jun 2010 16:44:44 -0400
From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH v2] d_ino considered harmful
In-reply-to: <20100616195359.GA24382@shell>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Message-id: <1276721084.13788.53.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
References: <20100616185913.GA15566@shell> <20100616195359.GA24382@shell>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 15:54 -0400, Valerie Aurora wrote:
> On Wed, Jun 16, 2010 at 02:59:13PM -0400, Valerie Aurora wrote:
> > Who needs d_ino anyway?  I am running a kernel with this patch -
> > Gnome, a browser, IRC, kernel compile, etc. and everything works.

For large-scale Lustre users, not having a valid d_ino in the dirent is
a problem when we need to put a name (or names) to an inode number.

>From time to time, we have a problem reported in the logs against an
inode and need to figure out the name of that file. stat() is very slow
on these filesystems due to the need to talk to multiple servers to get
file size information. When we purge the filesystem, it is faster to do
a scan of the inode table looking for old files than it is to walk the
tree. Then we have to match those inodes to names for unlink().

For example, our main Lustre scratch space has over 285 million files in
it, and using find -inum takes over 72 hours to walk the tree using
stat(). Using a scanner that takes advantage of d_ino allows us to cover
that ground in 13 hours. It's not perfectly apples-to-apples, as the
custom scanner has some parallelism, but it gives you an idea of the
problem's scale. Certainly, using d_ino reduces the number of RPCs we
have to send.

Using ne2scan -- which uses libext2fs and combines the inode scan and
the name lookup -- takes over 48 hours to generate a list of candidate
files for the purge example. With an optimized inode scan and the custom
scanner above, it should take 18 hours, which is a considerable time
saver for us.

I can see that there are pitfalls in the presence of mountpoint and
such, but we control the environment on these machines, and using d_ino
is a huge win for us.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


