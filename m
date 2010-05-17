Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0EQV4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:56:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:49281 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0EQV4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:56:38 -0400
Date: Mon, 17 May 2010 23:56:30 +0200
From: Jan Kara <jack@suse.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Jan Kara <jack@suse.cz>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mtd: Do not corrupt backing device of device node
 inode
Message-ID: <20100517215630.GF3364@quack.suse.cz>
References: <1273074054-11849-1-git-send-email-kirill@shutemov.name>
 <1273799074.9999.653.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273799074.9999.653.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 14-05-10 02:04:34, David Woodhouse wrote:
> On Wed, 2010-05-05 at 18:40 +0300, Kirill A. Shutemov wrote:
> > We cannot modify file->f_mapping->backing_dev_info, because it will corrupt
> > backing device of device node inode, since file->f_mapping is equal to
> > inode->i_mapping (see __dentry_open() in fs/open.c).
> > 
> > Let's introduce separate inode for MTD device with appropriate backing
> > device.
> 
> I hate the fact that we have to do this -- is it really the only option?
> 
> Is it _just_ for the backing_device_info? Can't that be done
> differently?
  Well, if I understand the problem MTD tries to solve, what you really need
is that file->f_mapping->backing_dev_info points to your structure so that
you can specify the capability of backing device to support mmap and
whatever else. What I'm not sure about is, why you cannot have this
backing_dev_info directly in the original device inode but since this is
the problem you are originally trying to solve, I guess you have some good
reason for that.
  So with this requirement, you have to at least setup complete struct
address_space to which f_mapping can point. This address_space has to be
linked (via mapping->host) to some inode. So you could point i_mapping
to your address_space structure if that would work for you. But this only
has a reasonable chance to work if you would somehow tie the lifetime
of your address_space with the lifetime of your device inode (code in
block_dev.c does something like this because all inodes which represent
the same block block device share one address_space). Moreover you would
have to do all the address_space initialization inode_init_always does (or
probably split out the mapping initialization from inode_init_always and
call it from MTD code). So I'm not sure it's really better.
  When you decide you don't want to take care about proper setup of
address_space and refcounting and whatever, you have to create a full
inode. But this inode has to live in some filesystem -> what Kirill did is
unavoidable in this case...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
