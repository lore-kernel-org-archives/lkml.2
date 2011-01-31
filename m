Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab1AaN7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:59:40 -0500
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:52138 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab1AaN7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:59:38 -0500
Subject: Re: [PATCH 2/2] RFC: selinux: sysctl: fix selinux labeling broken
 by last patch
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux <selinux@tycho.nsa.gov>,
        "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <AANLkTi=4CH2zFrDp6DAnSj3pa28MtymfG+NrtQ3iW5k-@mail.gmail.com>
References: <AANLkTi=4CH2zFrDp6DAnSj3pa28MtymfG+NrtQ3iW5k-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Mon, 31 Jan 2011 08:59:14 -0500
Message-ID: <1296482354.26427.21.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 05:26 +0200, Lucian Adrian Grijincu wrote:
> Eric's patch was rejected because it broke selinux labeling:
> http://thread.gmane.org/gmane.linux.kernel.lsm/9807/focus=9841
> 
>        This seems to break labeling.  Prior to this patch, I see:
> 
>        # ls -lZ /proc/1/net/rpc/nfsd.fh
>        -rw-------. root root system_u:object_r:sysctl_rpc_t:s0 channel
> 
>        with the patch:
> 
>        # ls -lZ /proc/1/net/rpc/nfsd.fh
>        -rw-------. root root system_u:object_r:proc_t:s0      channel
> 
> My patch seems to have fixed this problem (it correctly reports
> sysctl_rpc_t in this case), but my selinux experience is ε > 0 and I
> have no ideea what else it may have broken.
> 
> I ran 'find /proc | xargs ls -Z > f' on a kernel with an without
> these patches:
> * http://swarm.cs.pub.ro/~lucian/store/ls-Z-with-patch
> * http://swarm.cs.pub.ro/~lucian/store/ls-Z-without-patch
> 
> My setup is a custom busybox live CD with selinux enabled, with
> /etc/selinux and /usr/share/selinux/default copied from Ubuntu 10.10's
> selinux-policy-default package. I'm sure there are lots of reasons why
> this is not correcly configured, etc., but I have no experience
> regarding selinux. I can make all the scripts/sources/configs/etc
> available to anyone interested.
> 
> NOTE: this patch will be merged with:
>   security/selinux: Simplify proc inode to security label mapping
> 
> I'm only prividing this patch separately to point out the differences
> to Eric W. Biederman's patch.
> 
> Both of these patches apply cleanly agains Linux 2.6.37.
> 
> Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
> ---
>  fs/proc/proc_sysctl.c    |    1 -
>  security/selinux/hooks.c |   20 ++++++++++++++++----
>  2 files changed, 16 insertions(+), 5 deletions(-)

It would be better to include the patch inline for review.  In any
event, a few observations on your patch:
- We don't want to replace "incestuous" knowledge of proc with
"incestous" knowledge of the dcache.  So rather than encoding knowledge
of the magical "//deleted" suffix into selinux, use an interface to the
dcache (or add one if none exists) that does not append that suffix at
all.  I think apparmor did something similar to deal with the (deleted)
suffix for d_path.

- You don't need special handling of /proc/PID entries.  Those are
labeled via the security_task_to_inode -> selinux_task_to_inode hook,
called from proc_pid_make_inode and the _revalidate functions.

- Don't remove the IS_PRIVATE() test from inode_has_perm(), as other
inodes beyond just the /proc/sys ones are marked with that flag
(original usage was for reiserfs xattr inodes).

-- 
Stephen Smalley
National Security Agency

