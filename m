Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab0LIUrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:47:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39481 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab0LIUrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:47:13 -0500
Date: Thu, 9 Dec 2010 21:47:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] persistent store (version 3) (part 1 of 2)
Message-ID: <20101209204708.GA2396@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
	greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jim Keniston <jkenisto@linux.vnet.ibm.com>,
	Kyungmin Park <kmpark@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
References: <AANLkTimWT8=fmqbEeb+qXbwsWOmaz5d2_Bsr-=DON7L1@mail.gmail.com>
 <4d012a025304b1f75@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4d012a025304b1f75@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 11:12:02AM -0800, Luck, Tony wrote:
> > This upsets the traditional layout of having the error
> > recovery part of the function undo all the things that
> > we did leading up to the error. Pity, because your
> > version is easier to read.
> 
> But most of your "move the error fixups to the tail, so the
> normal code path is easier to follow" bit do still hold and
> can be used.  How about this:
> 
> -Tony
> 
> ---
> 
> int pstore_mkfile(char *name, char *data, size_t size, struct timespec time,
> 		  void *private)
> {
> 	struct dentry	*root = pstore_sb->s_root;
> 	struct dentry	*dentry;
> 	struct inode	*inode;
> 	int		rc;
> 
> 	rc = -ENOMEM;
> 	inode = pstore_get_inode(pstore_sb, root->d_inode, S_IFREG | 0444, 0);
> 	if (!inode)
> 		goto fail;

I'd add a newline here.

> 	inode->i_private = private;
> 
> 	mutex_lock(&root->d_inode->i_mutex);
> 
> 	rc = -ENOSPC;
> 	dentry = d_alloc_name(root, name);
> 	if (IS_ERR(dentry))
> 		goto fail_alloc;

ditto.

> 	d_add(dentry, inode);
> 
> 	mutex_unlock(&root->d_inode->i_mutex);
> 
> 	if (!pstore_writefile(inode, dentry, data, size))
> 		goto fail_write;
> 
> 	if (time.tv_sec)
> 		inode->i_mtime = inode->i_ctime = time;
> 
> 	return 0;
> 
> fail_write:
> 	inode->i_nlink--;
> 	mutex_lock(&root->d_inode->i_mutex);
> 	d_delete(dentry);
> 	dput(dentry);
> 	mutex_unlock(&root->d_inode->i_mutex);
> 	goto fail;

Yeah, either that or add a "return rc" to save us the jmp. But since
those paths wouldn't be hit in the normal case, I don't think it matters
that much.

> 
> fail_alloc:
> 	mutex_unlock(&root->d_inode->i_mutex);
> 	iput(inode);
> 
> fail:
> 	return rc;

Thanks.

-- 
Regards/Gruss,
    Boris.
