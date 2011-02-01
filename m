Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1BAPCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:02:31 -0500
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:47653 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1BAPCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:02:30 -0500
Subject: Re: [PATCH] security/selinux: fix /proc/sys/ labeling
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Nick Piggin <npiggin@kernel.dk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <1296519474-15714-1-git-send-email-lucian.grijincu@gmail.com>
References: <1296519474-15714-1-git-send-email-lucian.grijincu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Tue, 01 Feb 2011 10:02:18 -0500
Message-ID: <1296572538.12605.4.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 02:17 +0200, Lucian Adrian Grijincu wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>

Is this patch really from Eric or just derived from an earlier patch by
him?

> 
> This fixes an old (2007) selinux regression: filesystem labeling for
> /proc/sys returned
>      -r--r--r-- unknown                          /proc/sys/fs/file-nr
> instead of
>      -r--r--r-- system_u:object_r:sysctl_fs_t:s0 /proc/sys/fs/file-nr
> 
> Events that lead to breaking of /proc/sys selinux labeling:
> 
> 1) sysctl was reimplemented to route all calls through /proc/sysctl
> 
>     commit 77b14db502cb85a031fe8fde6c85d52f3e0acb63
>     [PATCH] sysctl: reimplement the sysctl proc support
> 
> 2) proc_dir_entry was removed from ctl_table:
> 
>     commit 3fbfa98112fc3962c416452a0baf2214381030e6
>     [PATCH] sysctl: remove the proc_dir_entry member for the sysctl tables
> 
> 3) selinux still walked the proc_dir_entry tree to apply
>    labeling. Because ctl_tables don't have a proc_dir_entry, we did
>    not label /proc/sys/ inodes any more. To achieve this the /proc/sys
>    inodes were marked private and private inodes were ignored by
>    selinux.
> 
>     commit bbaca6c2e7ef0f663bc31be4dad7cf530f6c4962
>     [PATCH] selinux: enhance selinux to always ignore private inodes
> 
>     commit 86a71dbd3e81e8870d0f0e56b87875f57e58222b
>     [PATCH] sysctl: hide the sysctl proc inodes from selinux
> 
> Access control checks have been done by means of a special sysctl hook
> that was called for read/write accesses to any /proc/sys/ entry.
> 
> We don't have to do this because, instead of walking the
> proc_dir_entry tree we can walk the dentry tree (as done in this
> patch). With this patch:
> * we don't mark /proc/sys inodes as private
> * we don't need the sysclt security hook
> * we walk the dentry tree to find the path to the inode.
> 
> We have to strip the PID in /proc/PID/ entries that have a
> proc_dir_entry because selinux does not know how to label paths like
> '/1/net/rpc/nfsd.fh' (and defaults to 'proc_t' labeling). Selinux does
> know of '/net/rpc/nfsd.fh' (and applies the 'sysctl_rpc_t' label).
> 
> PID stripping from the path was done implicitly in the previous code
> because the proc_dir_entry tree had the root in '/net' in the example
> from above. The dentry tree has the root in '/1'.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

And did Eric truly sign off on this patch or just on an earlier one?

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index e276eb4..7c5dfb1 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1317,9 +1311,9 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
>  
>  		if ((sbsec->flags & SE_SBPROC) && !S_ISLNK(inode->i_mode)) {
>  			struct proc_inode *proci = PROC_I(inode);
> -			if (proci->pde) {
> +			if (opt_dentry && (proci->pde || proci->sysctl)) {
>  				isec->sclass = inode_mode_to_security_class(inode->i_mode);
> -				rc = selinux_proc_get_sid(proci->pde,
> +				rc = selinux_proc_get_sid(opt_dentry,
>  							  isec->sclass,
>  							  &sid);
>  				if (rc)

It would be nice if we could eliminate the last remaining piece of proc
internal knowledge from this code - why do we need the proci->pde ||
proci->sysctl test here?  What changes without it?

-- 
Stephen Smalley
National Security Agency

