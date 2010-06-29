Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0F2UXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:23:13 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44661 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0F2UXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:23:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ONhv/gJzx1EdjyOXyis/QLmu6aZZA6BUtM+g5FP93y7pHzz9WPUDbQ71aNL4YHHCfz
         DaeX9LouRaOBdlM/p6NYCYdKAUSldlMYwrUtn6mUAxs2YxKQvv08p2LsTFsza38cDrEk
         0eKw5r5dGx3q/BuWiqBYSZcW6GT+XM3hbOAPM=
MIME-Version: 1.0
In-Reply-To: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
References: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
Date: Tue, 29 Jun 2010 15:23:07 -0500
Message-ID: <AANLkTimIh9ZAasPnN5xxGxbupwkct7UihHcMe26r-MD7@mail.gmail.com>
Subject: Re: [PATCH 0/3] Extended file stat functions
From: Steve French <smfrench@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, jlayton@redhat.com, mcao@us.ibm.com,
       aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, sjayaraman@suse.de,
       linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 3:02 PM, David Howells <dhowells@redhat.com> wrote:
> Implement a pair of new system calls to provide extended and further extensible
> stat functions.
>
> The third of the associated patches provides these new system calls:
>
>        struct xstat_dev {
>                unsigned int    major;
>                unsigned int    minor;
>        };
>
>        struct xstat_time {
>                unsigned long long      tv_sec;
>                unsigned long long      tv_nsec;
>        };
>
>        struct xstat {
>                unsigned int            struct_version;
>        #define XSTAT_STRUCT_VERSION    0
>                unsigned int            st_mode;
>                unsigned int            st_nlink;
>                unsigned int            st_uid;
>                unsigned int            st_gid;
>                unsigned int            st_blksize;
>                struct xstat_dev        st_rdev;
>                struct xstat_dev        st_dev;
>                unsigned long long      st_ino;
>                unsigned long long      st_size;
>                struct xstat_time       st_atime;
>                struct xstat_time       st_mtime;
>                struct xstat_time       st_ctime;
>                struct xstat_time       st_crtime;
>                unsigned long long      st_blocks;
>                unsigned long long      st_inode_version;
>                unsigned long long      st_data_version;
>                unsigned long long      query_flags;
>        #define XSTAT_QUERY_CREATION_TIME       0x00000001ULL
>        #define XSTAT_QUERY_INODE_VERSION       0x00000002ULL
>        #define XSTAT_QUERY_DATA_VERSION        0x00000004ULL
>                unsigned long long      extra_results[0];
>        };
>
>        ssize_t ret = xstat(int dfd,
>                            const char *filename,
>                            unsigned atflag,
>                            struct xstat *buffer,
>                            size_t buflen);
>
>        ssize_t ret = fxstat(int fd,
>                             struct xstat *buffer,
>                             size_t buflen);
>
> which are more fully documented in that patch's description.
>
> The bonuses of these new stat functions are:
>
>  (1) The fields in the xstat struct are cleaned up.  There are no split or
>     duplicated fields.
>
>  (2) Some extra information is made available (file creation time, inode
>     version number and data version number) where provided by the underlying
>     filesystem.
>
>     These are implemented here for Ext4 and AFS, but could also be provided
>     for CIFS, NTFS and BtrFS and probably others.

NFSv4 protocol also has a "recommended attribute" for create time that servers
should return if possible (which presumably now it would be possible to return
for Linux servers)

   time_create         50   nfstime4       R/W      The time of
creation of the object.

SMB2 protocol also returns the equivalent.

>  (3) The structure is versioned and extensible, meaning that further new system
>     calls shouldn't be required.

How does a fs return an "unknown" value for one
(e.g. version field) ... 0  or -1  or ...


>  (2) What extra bits of information might we like to see available through the
>     stat interface?  Security labels?  NFS file IDs?  Xattrs?

The list of mandatory ones for NFS is fairly small, the list of recommended
one for NFSv4 is larger (see page 44ff of
http://www.ietf.org/rfc/rfc3530.txt e.g.)

One hole that this reminded me about is how to return the superblock
time granularity (for NFSv4 this is attribute 51 "time_delta" which
is called on a superblock not on a file).  We run into time rounding
issues with Samba too.

>
>  (4) Should the inode number and data version number fields be 128-bit?
This is tricky for SMB2, if you can also provide a device id (or an object id of
some sort for the superblock) then 64 bit inode number is ok.


-- 
Thanks,

Steve
