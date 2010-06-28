Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0F1Tik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:38:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab0F1Tii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:38:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <19AAF9AA-2445-4C73-808B-4AD9C5C7E769@dilger.ca>
References: <19AAF9AA-2445-4C73-808B-4AD9C5C7E769@dilger.ca> <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
To: Andreas Dilger <adilger@dilger.ca>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, smfrench@gmail.com,
       jlayton@redhat.com, mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation available by xattrs
Date: Mon, 28 Jun 2010 20:38:23 +0100
Message-ID: <8831.1277753903@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger <adilger@dilger.ca> wrote:

> - I'd prefer calling these "file.generation" and "file.version".
>   I don't think there is value in the "i_" prefix adds anything,
>   and it seems more like an internal detail to me

That's reasonable.

> - why not expose the ".version" field for regular files?  It seems
>   that all of them are applicable for all file types.

Because Ext4 doesn't support it for anything other than directories.

> - it would be good to not introduce a new xattr namespace, since
>   tools like tar (even the RHEL-patched one) will not backup and
>   restore these namespaces.  Using "trusted." would allow them to
>   be backed up and restored using existing xattr-patched GNU tar
>   by root, but wouldn't allow them to be modified by regular users.
>   I think this is important for proper backup/restore of a filesystem,
>   but can have correctness implications and shouldn't be accessible
>   to regular users.

Does backing them up make sense, though?  They are filesystem structural
attributes.  Can you restore the inode number, for example?  If not, then you
can't restore i_generation either.  Restoring i_version might make sense, but
what if it winds i_version backwards whilst maintaining i_ino and i_generation,
that means there'll be a time in the future where the three values are once
again what might have been already published - and may already be in someone's
persistent cache.

> > file.crtime=0x53ba244c000000000000000000000000
> 
> Is this a binary (host-endian) struct timespec?

Yes.  That might not be the best representation, however.  It could also be,
say "<decimal-secs>.<decimal-nsecs>", eg: "1234.000000567".

> > file.i_generation=0x0000000000000000
> 
> This seems odd, i_generation should never be zero, AFAIK.

That might be because it's the root directory, and so cannot be replaced.

David
