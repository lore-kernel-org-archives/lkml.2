Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2KZKfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:35:47 -0500
Received: from 173-254-64-10.unifiedlayer.com ([173.254.64.10]:55854 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754102Ab2KZKfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:35:45 -0500
Message-ID: <1353926134.2025.37.camel@slavad-ubuntu>
Subject: [PATCH v3 0/5] hfsplus: reworked support of extended attributes
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Hin-Tak Leung <htl10@users.sourceforge.net>
Date: Mon, 26 Nov 2012 14:35:34 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 178.177.49.123 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This third version (v3) of patch set adds real support of extended attributes in HFS+ file system.

v2->v3
* Likewise JFS model every pure Mac OS X xattr (for example, com.apple.FinderInfo) is prefixed with "osx." during list_xattr stage. [Christoph Hellwig suggestion]
* It was added handlers for user.*, trusted.* and security.* namespaces.
* The code was reworked for using xattr general dispatching code. [Christoph Hellwig suggestion]
* Functionality of getting, setting and deleting of extended attributes is moved from ioctl.c into xattr.h and xattr.c.

v2->v1
* It was fixed the issue with message "No such file or directory" generation before outputting the expected result for "ls -l".
* It was fixed the issue with wrong 'hfs: xattr searching failed' kernel message generation in the case of real extended attribute absence for requested name.
* It was fixed the issue with checking of necessity to show com.apple.FinderInfo in the list of available extended attributes.

Current mainline implementation of hfsplus file system driver treats as extended attributes only two fields (fdType and fdCreator) of user_info field in file description record (struct hfsplus_cat_file). It is possible to get or set only these two fields as extended attributes. But HFS+ treats as com.apple.FinderInfo extended attribute an union of user_info and finder_info fields as for file (struct hfsplus_cat_file) as for folder (struct hfsplus_cat_folder). Moreover, current mainline implementation of hfsplus file system driver doesn't support special metadata file - attributes tree.

Mac OS X 10.4 and later support extended attributes by making use of the HFS+ filesystem Attributes file B*-tree feature which allows for named forks. Mac OS X supports only inline extended attributes, limiting their size to 3802 bytes. Any regular file may have a list of extended attributes. HFS+ supports an arbitrary number of named forks. Each attribute is denoted by a name and the associated data. The name is a null-terminated Unicode string. It is possible to list, to get, to set, and to remove extended attributes from files or directories.

It exists some peculiarity during getting of extended attributes list by means of getfattr utility. The getfattr utility expects prefix "user." before any extended attribute's name. So, it ignores any names that don't contained such prefix. Such behavior of getfattr utility results in unexpected empty output of extended attributes list even in the case when file (or folder) contains extended attributes. It needs to use empty string as regular expression pattern for names matching (getfattr --match="").  

For support of extended attributes in HFS+:
1. It was added necessary on-disk layout declarations related to Attributes tree into hfsplus_raw.h file.
2. It was added attributes.c file with implementation of functionality of manipulation by records in Attributes tree.
3. It was reworked hfsplus_listxattr, hfsplus_getxattr, hfsplus_setxattr functions in ioctl.c. Moreover, it was added hfsplus_removexattr method.

With the best regards,
Vyacheslav Dubeyko.
---
 fs/hfsplus/Makefile         |    4 +-
 fs/hfsplus/attributes.c     |  399 ++++++++++++++++++++++++
 fs/hfsplus/bfind.c          |   93 +++++-
 fs/hfsplus/bnode.c          |    6 +-
 fs/hfsplus/brec.c           |   23 +-
 fs/hfsplus/btree.c          |    8 +
 fs/hfsplus/catalog.c        |   36 ++-
 fs/hfsplus/dir.c            |   55 +++-
 fs/hfsplus/extents.c        |    4 +-
 fs/hfsplus/hfsplus_fs.h     |   52 +++-
 fs/hfsplus/hfsplus_raw.h    |   68 ++++-
 fs/hfsplus/inode.c          |   18 +-
 fs/hfsplus/ioctl.c          |  108 -------
 fs/hfsplus/super.c          |   56 +++-
 fs/hfsplus/unicode.c        |    7 +-
 fs/hfsplus/xattr.c          |  708 +++++++++++++++++++++++++++++++++++++++++++
 fs/hfsplus/xattr.h          |   60 ++++
 fs/hfsplus/xattr_security.c |  104 +++++++
 fs/hfsplus/xattr_trusted.c  |   63 ++++
 fs/hfsplus/xattr_user.c     |   63 ++++
 include/uapi/linux/xattr.h  |    3 +
 21 files changed, 1753 insertions(+), 185 deletions(-)
-- 
1.7.9.5


