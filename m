Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab0LITMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:12:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:20522 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab0LITMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:12:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,321,1288594800"; 
   d="scan'208";a="685593900"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        "Borislav Petkov" <bp@alien8.de>, "David Miller" <davem@davemloft.net>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Jim Keniston" <jkenisto@linux.vnet.ibm.com>,
        "Kyungmin Park" <kmpark@infradead.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
In-Reply-to: <AANLkTimWT8=fmqbEeb+qXbwsWOmaz5d2_Bsr-=DON7L1@mail.gmail.com>
Subject: Re: [RFC] persistent store (version 3) (part 1 of 2)
Date: Thu, 09 Dec 2010 11:12:02 -0800
Message-Id: <4d012a025304b1f75@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This upsets the traditional layout of having the error
> recovery part of the function undo all the things that
> we did leading up to the error. Pity, because your
> version is easier to read.

But most of your "move the error fixups to the tail, so the
normal code path is easier to follow" bit do still hold and
can be used.  How about this:

-Tony

---

int pstore_mkfile(char *name, char *data, size_t size, struct timespec time,
		  void *private)
{
	struct dentry	*root = pstore_sb->s_root;
	struct dentry	*dentry;
	struct inode	*inode;
	int		rc;

	rc = -ENOMEM;
	inode = pstore_get_inode(pstore_sb, root->d_inode, S_IFREG | 0444, 0);
	if (!inode)
		goto fail;
	inode->i_private = private;

	mutex_lock(&root->d_inode->i_mutex);

	rc = -ENOSPC;
	dentry = d_alloc_name(root, name);
	if (IS_ERR(dentry))
		goto fail_alloc;
	d_add(dentry, inode);

	mutex_unlock(&root->d_inode->i_mutex);

	if (!pstore_writefile(inode, dentry, data, size))
		goto fail_write;

	if (time.tv_sec)
		inode->i_mtime = inode->i_ctime = time;

	return 0;

fail_write:
	inode->i_nlink--;
	mutex_lock(&root->d_inode->i_mutex);
	d_delete(dentry);
	dput(dentry);
	mutex_unlock(&root->d_inode->i_mutex);
	goto fail;

fail_alloc:
	mutex_unlock(&root->d_inode->i_mutex);
	iput(inode);

fail:
	return rc;
}
