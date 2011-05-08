Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1EHOX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:23:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab1EHOXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:23:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] fs: kill default_llseek
Date: Sun, 8 May 2011 16:23:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hch@infradead.org
References: <1304605677-1882-1-git-send-email-josef@redhat.com>
In-Reply-To: <1304605677-1882-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105081623.39876.arnd@arndb.de>
X-Provags-ID: V02:K0:cqhAxCMloxL8rL2yWv2iPZbBWcex86GAfuwAyU9pdbP
 IHp6mqBnYXo7wKGsNSeW1GXy7pHgzZF17PIb+lE6ZISnQQgZhj
 3ecb8g8aVFNy+YwrvTcxhiO6b2pH8FFJAT/diPCQAHbyfM33YK
 MVxnb1+68ar7zNPkYut9KTp/SQ8HVAREDrAYKd3c39JcAWlKJY
 RiitPqj6N4lci2V306vQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 May 2011 16:27:57 Josef Bacik wrote:
> Looking at this llseek stuff I noticed that default_llseek is the exact same as
> generic_file_llseek, so kill default_llseek.  I patched this using spatch with
> just a simple
> 
> @@
> @@
> 
> - default_llseek
> + generic_file_llseek
> 
> and then I manually removed the default_llseek definitions.  I've built and
> booted this and it works fine.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Good idea in principle, but you missed the fact that generic_file_llseek
checks (offset > inode->i_sb->s_maxbytes), which default_llseek
does not.

This makes a huge difference on file systems that do not initialize
s_maxbytes, leaving it at zero. In particular, it doesn't work for
character devices, IIRC they will use whatever s_maxbytes is set for
the file system that stores the dentry and for debugfs and other
virtual file systems, it is not set at all.

The proper fix should be to make sure all file systems set an appropriate
s_maxbytes, and then add a special case for character devices to
generic_file_llseek. The main reason I didn't do it last year was to
avoid possible regressions when missing some other special cases, but
please continue to push this once you are sure to have a correct version
of the patch.

	Arnd
