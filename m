Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab2JKQGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:06:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55318 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2JKQGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:06:40 -0400
Date: Thu, 11 Oct 2012 17:06:33 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] efivarfs: efivarfs_fill_super() ensure we clean up
 correctly on error
Message-ID: <20121011160633.GA23494@dm>
References: <1349416496.810727.310563927016.1.gpush@pecola>
 <1349951541-20498-1-git-send-email-apw@canonical.com>
 <1349951541-20498-6-git-send-email-apw@canonical.com>
 <5076D1EC.1060100@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5076D1EC.1060100@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 10:04:28PM +0800, Jeremy Kerr wrote:
> Hi Andy,
> 
> >@@ -969,16 +970,18 @@
> >  		return -ENOMEM;
> >
> >  	list_for_each_entry_safe(entry, n, &efivars->list, list) {
> >-		struct inode *inode;
> >  		struct dentry *dentry, *root = efivarfs_sb->s_root;
> >-		char *name;
> >  		unsigned long size = 0;
> >  		int len, i;
> >
> >+		inode = NULL;
> >+
> >  		len = utf16_strlen(entry->var.VariableName);
> >
> >  		/* GUID plus trailing NULL */
> >  		name = kmalloc(len + 38, GFP_ATOMIC);
> >+		if (!name)
> >+			goto fail;
> >
> >  		for (i = 0; i < len; i++)
> >  			name[i] = entry->var.VariableName[i] & 0xFF;
> >@@ -991,7 +994,13 @@
> >
> >  		inode = efivarfs_get_inode(efivarfs_sb, root->d_inode,
> >  					  S_IFREG | 0644, 0);
> >+		if (!inode)
> >+			goto fail_name;
> >+			
> >  		dentry = d_alloc_name(root, name);
> >+		if (!dentry)
> >+			goto fail_inode;
> >+
> >  		/* copied by the above to local storage in the dentry. */
> >  		kfree(name);
> 
> If we break out of the loop on the second (and onwards) iteration,
> won't we still have the other inodes and dentries remaining
> allocated?

As we calling this from the mount_single() wrapper:

        return mount_single(fs_type, flags, data, efivarfs_fill_super);


which does this:

    struct dentry *mount_single(struct file_system_type *fs_type,
	    int flags, void *data,
	    int (*fill_super)(struct super_block *, void *, int))
    {
    [...]
		    error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
		    if (error) {
			    deactivate_locked_super(s);
			    return ERR_PTR(error);
		    }
    [...]

I am expecting us to get called back via deactivate_locked_super(),
which calls sb->kill_sb() which is:

    static void efivarfs_kill_sb(struct super_block *sb)
    {       
	    kill_litter_super(sb);
	    efivarfs_sb = NULL;
    }       

Which I believe will clean them up.

-apw

