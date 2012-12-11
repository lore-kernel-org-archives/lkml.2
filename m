Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab2LKSJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:09:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65105 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2LKSJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:09:27 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxh2SH9WcXbb+hD3PtWa4ZTqYNUxvbqZh27vwANuUTE8w@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	<CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	<CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
	<1355234914.2356.85.camel@falcor>
	<CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
	<CALLzPKZQ3=qNOxJk-yqDGEzqkcKLoc9tPPD8o9QbJOUOB1nWuQ@mail.gmail.com>
	<CA+55aFxh2SH9WcXbb+hD3PtWa4ZTqYNUxvbqZh27vwANuUTE8w@mail.gmail.com>
Date: Tue, 11 Dec 2012 13:09:25 -0500
Message-ID: <CACLa4pt698L4+BFSErV_rrmosmU-ELYZcmSBR8JqtYBTN35z9g@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 12:55 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> And your "pseudo-filesystems" argument is pretty stupid too, since WE
> ALREADY HAVE A FLAG FOR THAT!
>
> Guess where it is? Oh, it's in the place I already mentioned makes
> more sense. Look for S_PRIVATE in inode->i_flags, and IS_PRIVATE() in
> users. It's what the other security models already use to avoid
> bothering calling down to the security layers. The fact that the
> integrity layer bypasses the normal security layer in
> ima_file_check(), for example, is no excuse to then make up totally
> new flags.

IS_PRIVATE() is not used by and darn well better not be used by, all
psuedo filesystems like procfs which IMA may want to ignore.  LSMs
like to do control on them.  I thought S_PRIVATE was really only used
by the anon_inode and reiserfs's really crazy ass internal inodes.  I
could always be wrong.

I don't know if I agree with dmitry but let me explain what's going on here.

Lets say the user accesses an inode in procfs.  Without this patch one
would search the ima policy and find a rule that says 'if this inode
is on procfs we don't care.'  We can then cache that in the struct
inode like you say and move along.  If another inode on procfs is
opened we will have the same policy search and the same per inode 'i
don't give a crap' marking.  This absolutely works you are right.  But
we search the IMA policy for every inode.

With Dmitry's patch we can instead search the IMA policy one time and
mark the whole superblock as 'i don't give a crap' if IMA policy says
we don't care about that fstype.  When the second procfs inode is
opened we instead look at the per superblock 'who gives a crap' and
never search the IMA policy.  So we save all future policy searches.

I'd say this patch would only be a good idea if there is a real
performance hit which is measurable in a real work situation.  Not,
'look how much faster it is to access proc inodes' microbenchmark,
since noone is actually going to do that, but some results of a useful
benchmark you care about.  Maybe Dmitry gave those numbers and I
missed them?  Otherwise, stick with per inode like Linus wants...
