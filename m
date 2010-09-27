Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab0I0ND5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:03:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:55926 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616Ab0I0ND4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:03:56 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V4 07/11] vfs: Make acl_permission_check() work for richacls
Date: Mon, 27 Sep 2010 15:03:49 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; i686; ; )
Cc: Jeff Layton <jlayton@redhat.com>, sfrench@us.ibm.com, ffilz@us.ibm.com,
        adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
        bfields@citi.umich.edu, linux-fsdevel@vger.kernel.org,
        nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100924115049.47b1217b@tlielax.poochiereds.net> <m3y6ar9djc.fsf@linux.vnet.ibm.com>
In-Reply-To: <m3y6ar9djc.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009271503.49193.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 September 2010 20:55:51 Aneesh Kumar K. V wrote:
> To be POSIX compatible we need to ensure that additional file access
> control mechanisms may only further restrict the access permissions defined
> by the file permission bits.

That's true but I don't think it fully answers Jeff's question.

With POSIX ACLs, the owner file permission bits are always identical to the 
permissions that the owner is granted through the ACL.  Therefore, when 
acl_permission_check() is invoked on behalf of the owner, the ACL does not 
need to be consulted at all.  For non-owners, the ACL always needs to be 
checked.  This optimization is also true for richacls for the base permissions 
(read, write, execute), but:

 * Some permissions are more fine-grained than the file mode permission
   bits: richacls distinguish between write and append, and between creating
   directories and non-directories.

 * Some permissions go beyond what the owner is implicitly allowed or what can
   be expressed with read, write, execute: in a richacl, a user can be granted
   the right to delete a specific file even without write access to the
   containing directory and to take ownership of a file

(* In addition, a richacl can grant the right to chmod and set the acl of a
   file, and to explicitly set the file timestamps.  These are permissions
   which the owner is implicitly allowed anyway, so they are not relevant to
   this change to acl_permission_check().)

To handle those cases correctly too, we always look at the acl for richacls, 
even for the owner.  (We could still skip the acl check in some, but fewer, 
cases.)

Thanks,
Andreas
