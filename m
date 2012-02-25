Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2BYL2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 06:28:33 -0500
Received: from www17.your-server.de ([213.133.104.17]:37128 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2BYL2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 06:28:31 -0500
Message-ID: <1330169301.1380.2.camel@localhost.localdomain>
Subject: Re: compat: autofs v5 packet size ambiguity - update
From: Thomas Meyer <thomas@m3y3r.de>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, autofs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Sat, 25 Feb 2012 12:28:21 +0100
In-Reply-To: <1329890251.2193.50.camel@perseus.themaw.net>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
	 <20120221.221609.218135609185671883.davem@davemloft.net>
	 <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
	 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
	 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
	 <1329889428.2193.45.camel@perseus.themaw.net>
	 <1329890027.2193.48.camel@perseus.themaw.net>
	 <1329890251.2193.50.camel@perseus.themaw.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 22.02.2012, 13:57 +0800 schrieb Ian Kent:
> On Wed, 2012-02-22 at 13:53 +0800, Ian Kent wrote:
> > On Wed, 2012-02-22 at 13:43 +0800, Ian Kent wrote:
> > > On Tue, 2012-02-21 at 20:56 -0800, Linus Torvalds wrote:
> > 
> > Ahh ... forgot to set the file_operations structure member .. oops
> > 
> > >  
> > > +static int autofs4_root_dir_open(struct inode *inode, struct file *file)
> > > +{
> > > +	struct autofs_sb_info *sbi= autofs4_sbi(file->f_path.dentry->d_sb);
> > > +	if (sbi->compat_daemon < 0)
> > > +		sbi->compat_daemon = is_compat_task();
> > > +	return dcache_dir_open(inode, file);
> > > +}
> > > +
> > 
> 
> Lets try that again.
> 
> autofs: work around unhappy compat problem on x86-64
> 
> From: Ian Kent <raven@themaw.net>
> 
> When the autofs protocol version 5 packet type was added in commit
> 5c0a32fc2cd0 ("autofs4: add new packet type for v5 communications"), it
> obvously tried quite hard to be word-size agnostic, and uses explicitly
> sized fields that are all correctly aligned.
> 
> However, with the final "char name[NAME_MAX+1]" array at the end, the
> actual size of the structure ends up being not very well defined:
> because the struct isn't marked 'packed', doing a "sizeof()" on it will
> align the size of the struct up to the biggest alignment of the members
> it has.
> 
> And despite all the members being the same, the alignment of them is
> different: a "__u64" has 4-byte alignment on x86-32, but native 8-byte
> alignment on x86-64.  And while 'NAME_MAX+1' ends up being a nice round
> number (256), the name[] array starts out a 4-byte aligned.
> 
> End result: the "packed" size of the structure is 300 bytes: 4-byte, but
> not 8-byte aligned.
> 
> As a result, despite all the fields being in the same place on all
> architectures, sizeof() will round up that size to 304 bytes on
> architectures that have 8-byte alignment for u64.
> 
> Note that this is *not* a problem for 32-bit compat mode on POWER, since
> there __u64 is 8-byte aligned even in 32-bit mode.  But on x86, 32-bit
> and 64-bit alignment is different for 64-bit entities, and as a result
> the structure that has exactly the same layout has different sizes.
> 
> So on x86-64, but no other architecture, we will just subtract 4 from
> the size of the structure when running in a compat task.  That way we
> will write the properly sized packet that user mode expects.
> 
> Not pretty.  Sadly, this very subtle, and unnecessary, size difference
> has been encoded in user space that wants to read packets of *exactly*
> the right size, and will refuse to touch anything else.
> 
> Reported-and-tested-by: Thomas Meyer <thomas@m3y3r.de>
> Cc: Ian Kent <raven@themaw.net>
> ---

works for me on top of 3.2.7.


