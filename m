Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0G2Nuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:50:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:54448 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753828Ab0G2Nuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:50:51 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX19JZ21s4VtJg4oq7HSM4Ivyb6EJmFbVlYnLyIETYP
	lljDU3gwYgTyVK
Date: Thu, 29 Jul 2010 15:50:38 +0200
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        viro@zeniv.linux.org.uk
Subject: Questions concerning memory mapping in stackable filesystems
Message-ID: <20100729135038.GA9885@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am currently working on a stackable filesystem and would like to implement
memory mapping for it. 
I have looked at the ecryptfs way of doing this and wonder if this really
has to be that complicated (create a persistent file for each inode, start 
a kernel thread only to handle requests to open those persistent files, etc.). 

My plan to handle this was to:

- provide a readpage() address_space operation
- provide a writepage() address_space operation
- delegate the fsync() file operation to the lower filesystem

readpage should do:
1. get the lower page via read_cache_page()
2. copy the content of lower page to upper page

writepage should do:
1. get the lower page via grab_cache_page()
2. copy the content of upper page to lower page
3. mark the lower page dirty (dont actually write it)

fsync should do:
call vfs_fsync() for the lower file and dentry to 
actually write the dirty pages to disk. 

(see code samples below)

So my questions are: 

- Are there any circumstances in which this solution wont work? (It _seems_ 
  to work - at least I was able to copy a file via mmap()).

- What else do i have to take into account for implementing memory mapping in
  a stackable filesystem ?

- What is the difference between grab_cache_page(), read_cache_page() and
  page_cache_read()? They all seem to do more or less the same (look into
  the page cache for the requested page and create it if it was not found)


Thx in advance for any hints and comments!

Lino Sanfilippo


static int my_readpage(struct file *file, struct page *page)
{
	...

	lower_page = read_cache_page(lower_inode->i_mapping, page->index,
				     (filler_t *)lower_a_ops->readpage,
				     (void *)lower_file);
	if (IS_ERR(lower_page)) {
		err = PTR_ERR(lower_page);
		lower_page = NULL;
		printk(KERN_ERR "Error reading from page cache.\n");
		goto out;
	}
	wait_on_page_locked(lower_page);

	page_data = (char *)kmap(page);
	if (!page_data) {
		err = -ENOMEM;
		printk(KERN_ERR "Error mapping page.\n");
		goto out;
	}
	lower_page_data = (char *)kmap(lower_page);
	if (!lower_page_data) {
		err = -ENOMEM;
		printk(KERN_ERR "Error mapping lower page.\n");
		goto out;
	}
	memcpy(page_data, lower_page_data, PAGE_CACHE_SIZE);
	kunmap(lower_page);
	kunmap(page);
out:
	if (lower_page)
		page_cache_release(lower_page);

	if (err)
		ClearPageUptodate(page);
	else
		SetPageUptodate(page);

	unlock_page(page);

	return err;
}

static int my_writepage(struct page *page, struct writeback_control *wbc)
{
	...

	lower_page = grab_cache_page(lower_inode->i_mapping, page->index);

	if (!lower_page) {
		// TODO: proper error value
		rv = -ENOMEM;
		goto fail;
	}
	page_data = (char *) kmap(page);
	if (!page_data) {
		rv = -ENOMEM;
		unlock_page(lower_page);
		goto fail;
	}
	lower_page_data = (char *) kmap(lower_page);
	if (!lower_page_data) {
		rv = -ENOMEM;
		kunmap(page);
		unlock_page(lower_page);
		goto fail;
	}
	memcpy(lower_page_data, page_data, PAGE_CACHE_SIZE);
	kunmap(page);
	kunmap(lower_page);

	SetPageDirty(lower_page);
	unlock_page(lower_page);
	
	SetPageUptodate(page);
fail:
	unlock_page(page);

	return rv;
}


static int my_fsync(struct file *file, struct dentry *dentry,
			  int datasync)
{
	...

	/* do actually write lower pages to disc */
	err = vfs_fsync(lower_file, lower_dentry, datasync);
	return err;
}

