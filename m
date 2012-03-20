Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2CTBpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 21:45:01 -0400
Received: from mail.nudt.edu.cn ([61.187.54.11]:42948 "HELO eyou.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752633Ab2CTBo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 21:44:56 -0400
X-EYOU-SPAMVALUE: 0
X-EYOU-DEALDRC: 
X-EMDG-VER: 2011-01-28
Message-ID: <532207070.20372@eyou.net>
X-EYOUMAIL-SMTPAUTH: liwang@nudt.edu.cn
From: "Li Wang" <liwang@nudt.edu.cn>
To: "'Tyler Hicks'" <tyhicks@canonical.com>
Cc: "'Dustin Kirkland'" <dustin.kirkland@gazzang.com>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        "'Yunchuan Wen'" <wenyunchuan@kylinos.com.cn>,
        <ecryptfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1331638789-3770-1-git-send-email-liwang@nudt.edu.cn> <531757825.11205@eyou.net>
In-Reply-To: <531757825.11205@eyou.net>
Subject: RE: [PATCH] eCryptfs: Fix kernel bug for writing mmaped non-eCryptfs file
Date: Tue, 20 Mar 2012 09:44:43 +0800
Message-ID: <001801cd063b$0858b200$190a1600$@edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac0CIyYaWSzovpACTeqXdKM+xRB+mQEEV9vw
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tyler,
  There are three ways to go for non-eCryptfs files accessed from eCryptfs mount,
1 Fully access
2 Read only
3 No access

Personally, we prefer the first way, the reasons are as follows, the idea behind eCryptfs is tranparent
encrption/decryption file system,
Transparent is in terms of applications, that is, applications do not know the existence of encryption/decrption, rather
than people.
If make the non-eCryptfs files read-only/no-access from eCryptfs mount against the traditional unix file rwx permission, to
some extent,
it is no longer apparent to applications. And, some times, people want to mix plain/cipher text files in his folder, for
example, some big
video/audio files for fun are not wanted to be encrypted, some small private photos/ documents files are. If choose 3rd
option, people have
to access the files inside same folder from different places.

Nevertheless, for any option, we are happy to help to get a corresponding patch, it is up to your decisions.

Cheers,
Li Wang

-----Original Message-----
From: Tyler Hicks [mailto:tyhicks@canonical.com] 
Sent: Thursday, March 15, 2012 4:56 AM
To: Li Wang
Cc: Dustin Kirkland; Linus Torvalds; Yunchuan Wen; ecryptfs@vger.kernel.org; linux-fsdevel@vger.kernel.org;
linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: Fix kernel bug for writing mmaped non-eCryptfs file

On 2012-03-13 19:39:49, Li Wang wrote:
> eCryptfs did not handle the writing for mmaped non-eCryptfs file.
> Instead, it put BUG_ON(!(crypt_stat->flags & ECRYPTFS_ENCRYPTED))
> on ecryptfs_writepage call path. This patch enables eCryptfs to
> deal with such case, to fully support non-eCryptfs operations as it
> claims.

Hi Li - Thanks for the patch!

Before I review/merge it, I'm curious if you use the
ecryptfs_plaintext_passthrough feature? IMO, it is a terrible design and
I've found that hardly anyone uses it. Maybe *no one*, after knowing
that mmap was broken for plaintext files...

Having to pre-create the file in the lower filesystem in order for it to
be a "plaintext" file inside the eCryptfs mount is a terrible idea. The
admin/user/application has no idea if the file is plaintext by looking
at it inside the eCryptfs mount and he/she has to examine the file in
the lower filesystem to find out. If that file is ever unlinked and then
created again, it turns into an encrypted file. There is too much
uncertainty around this feature for it to exist in a cryptographic
filesystem.

I'd really like to continue focusing on getting eCryptfs as stable as
possible and then dump the CONFIG_EXPERIMENTAL dependency at some point.
As a prerequisite to that, I'm thinking that
ecryptfs_plaintext_passthrough support should be removed, at least in
its current form. Any thoughts?

Tyler

> 
> ---
> 
> To make the bug present
> 
> cd cipher // enter eCryptfs cipher text folder
> echo "123" > foo // make non-eCryptfs file
> cd ..
> mount -t ecryptfs cipher plain -o ecryptfs_passthrough // allow for non-eCryptfs files to be read and written from within
an eCryptfs mount
> cd plain
> run the following program
> 
> int main()
> {
> 	int fd = open("foo", O_RDWR);
> 	char * addr;
> 	addr = (char *)mmap(NULL, 256, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> 	add[0] = '3';
> 	munmap(addr, 256);
> 	close(fd);
> 	return 0;
> }
> 
> Signed-off-by: Li Wang <liwang@nudt.edu.cn>
> Signed-off-by: Yunchuan Wen <wenyunchuan@kylinos.com.cn>
> ---
>  fs/ecryptfs/mmap.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
> index 10ec695..a4be0e9 100644
> --- a/fs/ecryptfs/mmap.c
> +++ b/fs/ecryptfs/mmap.c
> @@ -65,6 +65,32 @@ struct page *ecryptfs_get_locked_page(struct inode *inode, loff_t index)
>  static int ecryptfs_writepage(struct page *page, struct writeback_control *wbc)
>  {
>  	int rc;
> +	struct inode *inode;
> +	struct ecryptfs_crypt_stat *crypt_stat;
> +
> +	inode = page->mapping->host;
> +	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
> +	if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
> +		size_t size;
> +		loff_t file_size = i_size_read(inode);
> +		pgoff_t end_page_index = file_size >> PAGE_CACHE_SHIFT;
> +
> +		if (end_page_index < page->index)
> +			size = 0;
> +		else if (end_page_index == page->index)
> +			size = file_size & ~PAGE_CACHE_MASK;
> +		else
> +			size = PAGE_CACHE_SIZE;
> +
> +		rc = ecryptfs_write_lower_page_segment(inode, page, 0, size);
> +		if (unlikely(rc)) {
> +			ecryptfs_printk(KERN_WARNING, "Error write "
> +					"page (upper index [0x%.16lx])\n", page->index);
> +			ClearPageUptodate(page);
> +		} else
> +			SetPageUptodate(page);
> +		goto out;
> +	}
>  
>  	/*
>  	 * Refuse to write the page out if we are called from reclaim context
> -- 
> 1.7.6.5
> 

