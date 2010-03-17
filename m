Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0CRAkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 20:40:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60807 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab0CRAkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 20:40:40 -0400
Date: Wed, 17 Mar 2010 16:25:26 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       containers@lists.linux-foundation.org,
       Matt Helsley <matthltc@us.ibm.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [C/R v20][PATCH 46/96] c/r: add checkpoint operation for
 opened files of generic filesystems
Message-ID: <20100317232526.GI3037@count0.beaverton.ibm.com>
References: <1268842164-5590-9-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-10-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-11-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-12-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-13-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-14-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-15-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-16-git-send-email-orenl@cs.columbia.edu>
 <1268842164-5590-17-git-send-email-orenl@cs.columbia.edu>
 <BA0C23DE-E2B5-42A9-8478-CE216D18A6C6@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BA0C23DE-E2B5-42A9-8478-CE216D18A6C6@sun.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 03:09:00PM -0600, Andreas Dilger wrote:
> On 2010-03-17, at 10:08, Oren Laadan wrote:
> >These patches extend the use of the generic file checkpoint
> >operation to
> >non-extX filesystems which have lseek operations that ensure we
> >can save
> >and restore the files for later use. Note that this does not include
> >things like FUSE, network filesystems, or pseudo-filesystem kernel
> >interfaces.
> 
> I didn't see any other patches posted to linux-fsdevel regarding
> what this code is, or what it is supposed to be doing.  Could you
> please repost the patches related to generic_file_checkpoint(), and

I'm not sure why those weren't sent to linux-fsdevel. It mainly saves
the critical pieces of kernel information from the struct file needed
to restart the open file descriptors. It does not save the file
(system) contents in the checkpoint image. That's left for proper
filesystem freezing, snapshotting, or rsync (for example) depending on
the tools and/or filesystems userspace has chosen.

> the overview email that explains what you mean by "checkpoint".  I'm
> assuming this is related to HPC/process restart/migration, but
> better to not guess.

Your assumption is correct -- this is related to HPC/process
restart/migration. That said, we'd like to make it as useful as
possible for other folks as well.

> 
> >@@ -718,6 +718,7 @@ static const struct file_operations
> >btrfs_ctl_fops = {
> >	.unlocked_ioctl	 = btrfs_control_ioctl,
> >	.compat_ioctl = btrfs_control_ioctl,
> >	.owner	 = THIS_MODULE,
> >+	.checkpoint = generic_file_checkpoint,
> >};
> >
> >const struct file_operations exofs_file_operations = {
> >	.llseek		= generic_file_llseek,
> >+	.checkpoint	= generic_file_checkpoint,
> >	.read		= do_sync_read,
> >	.write		= do_sync_write,
> >	.aio_read	= generic_file_aio_read,
> >
> >static const struct file_operations hostfs_file_fops = {
> >	.llseek		= generic_file_llseek,
> >+	.checkpoint	= generic_file_checkpoint,
> >	.read		= do_sync_read,
> >	.splice_read	= generic_file_splice_read,
> >	.aio_read	= generic_file_aio_read,
> >@@ -430,6 +431,7 @@ static const struct file_operations
> >hostfs_file_fops = {
> >
> >static const struct file_operations hostfs_dir_fops = {
> >	.llseek		= generic_file_llseek,
> >+	.checkpoint	= generic_file_checkpoint,
> >	.readdir	= hostfs_readdir,
> >	.read		= generic_read_dir,
> >};
> >
> >const struct file_operations nilfs_file_operations = {
> >	.llseek		= generic_file_llseek,
> >+	.checkpoint	= generic_file_checkpoint,
> >	.read		= do_sync_read,
> >	.write		= do_sync_write,
> >	.aio_read	= generic_file_aio_read,
> 
> 
> Minor nit - it would be good to add this method in the same place in
> all of the *_file_operation structures for consistency.  Ideally
> these would already be in the order that they are declared in the
> structure, but at least new ones should be added consistently.

I chose to put them right after llseek because that's a critical
operation that determines whether generic_file_checkpoint is suitable
or whether a custom operation is needed. Since the placement here
has nothing to do with the order in memory it's mainly a convention
I thought up to support review of copy-pasted file operations with
new .checkpoint ops.

I'll post a patch to move these down to correspond to definition-order
unless you agree that my reasoning above justifies keeping them
where they are.

> 
> >static const struct vm_operations_struct nfs_file_vm_ops = {
> >	.fault = filemap_fault,
> >	.page_mkwrite = nfs_vm_page_mkwrite,
> >+#ifdef CONFIG_CHECKPOINT
> >+	.checkpoint = filemap_checkpoint,
> >+#endif
> >};
> 
> Why is this one conditional, but the others are not?

filemap_checkpoint is defined in mm/filemap.c and the !CONFIG_CHECKPOINT
section has:

#define filemap_checkpoint NULL

Of course since it's not in a header file that define is useless
elsewhere hence the conditional here. We should move that to a
proper header. Good catch, thanks!

Cheers,
	-Matt Helsley
