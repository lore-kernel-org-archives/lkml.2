Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451Ab2DKOXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:23:33 -0400
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:10766 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760341Ab2DKOX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:23:29 -0400
X-TM-IMSS-Message-ID: <a315d8ba00017e52@nsa.gov>
Subject: Re: [PATCH v2] Add security.* XATTR support for the UBIFS
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Subodh Nijsure <subodh.nijsure@gmail.com>
Cc: linux-mtd@lists.infradead.org, Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Subodh Nijsure <snijsure@grid-net.com>
In-Reply-To: <CALr9Q3a89_wa48BfOriP=MEQAXa1Sgf+k_Ey=kuKN9Ydewwegw@mail.gmail.com>
References: <1334015486-20616-1-git-send-email-snijsure@grid-net.com>
	 <1334061985.23411.3.camel@moss-pluto>
	 <CALr9Q3Yto9VOhFNRQFVqP7Zi6RWWBaoDUu1zxsup7=+g7_pijQ@mail.gmail.com>
	 <1334149853.14296.29.camel@moss-pluto>
	 <CALr9Q3a89_wa48BfOriP=MEQAXa1Sgf+k_Ey=kuKN9Ydewwegw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Wed, 11 Apr 2012 10:23:22 -0400
Message-ID: <1334154202.14296.58.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 07:12 -0700, Subodh Nijsure wrote:
> On Wed, Apr 11, 2012 at 6:10 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > On Wed, 2012-04-11 at 06:00 -0700, Subodh Nijsure wrote:
> >> On Tue, Apr 10, 2012 at 5:46 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> >> > On Mon, 2012-04-09 at 16:51 -0700, subodh.nijsure@gmail.com wrote:
> >> >> From: Subodh Nijsure <snijsure@grid-net.com>
> >> >>
> >> >> Also fix couple of bugs in UBIFS extended attribute length calculation.
> >> >>
> >> >> Changes Since V1:
> >> >>          Instead of just handling security.selinux extended attribute handle
> >> >>          all security.* attributes.
> >> >>
> >> >> TESTING: Tested on  MX28 based platforms using Micron MT29F2G08ABAEAH4 NAND
> >> >>          With these change we are able to label UBIFS filesystem with
> >> >>          security.selinux and run system with selinux enabled.
> >> >>          This change also allows one to set other security.* extended
> >> >>          attributesr, such as security.smack security.evm, security.ima
> >> >>          Ran integck test on UBI filesystem.
> >> >>
> >> >> Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
> >> >> ---
> >> >>  fs/ubifs/dir.c     |    4 ++
> >> >>  fs/ubifs/file.c    |    6 ++
> >> >>  fs/ubifs/journal.c |   12 +++-
> >> >>  fs/ubifs/super.c   |    3 +
> >> >>  fs/ubifs/ubifs.h   |    9 +++
> >> >>  fs/ubifs/xattr.c   |  147 ++++++++++++++++++++++++++++++++++++++++++++++++----
> >> >>  6 files changed, 167 insertions(+), 14 deletions(-)
> >> >>
> >> >> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> >> >> index ec9f187..f4e06c4 100644
> >> >> --- a/fs/ubifs/dir.c
> >> >> +++ b/fs/ubifs/dir.c
> >> >> @@ -293,6 +293,7 @@ static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
> >> >>       ubifs_release_budget(c, &req);
> >> >>       insert_inode_hash(inode);
> >> >>       d_instantiate(dentry, inode);
> >> >> +     ubifs_init_security(dir, inode, &dentry->d_name);
> >> >>       return 0;
> >> >>
> >> >>  out_cancel:
> >> >
> >> > The ubifs_init_security() should occur before d_instantiate() so that
> >> > the inode is not accessible to other threads before its security
> >> > attributes have been set.  And if it fails, you would ideally drop the
> >> > inode altogether and return an error to the creating process.
> >> >
> >>
> >> I will look into moving ubifs_init_security() before d_instantiate().
> >> Last time I had tried I had run into some issues and had to keep
> >> creating inode and then creating xattr as two seperate items. I will
> >> look through the UBIFS code that actually creates xattr ubi nodes.
> >> Also I will wait for couple of days to send v3 patch with to see if
> >> mtd folks have other comments this patch.
> >
> > I'd favor moving the call to ubifs_init_security() inside of
> > ubifs_new_inode() so that it gets done as part of all inode creation.
> > To do that, you'll need to pass the &dentry->d_name (const struct qstr
> > *) down to ubifs_new_inode(). But you can see that it is done that way
> > for ext4_new_inode(), for example.
> >
> > --
> 
> Okay, I will look at that code little bit mode.
> 
> UBIFS create_xattr() (fs/ubifs/xattr.c)  calls ubifs_new_inode() so it
> can get tricky if I want to create xattr in ubifs_new_inode().
> 
> Also noticed that UBIFS doesn't d_instantiate() inode entry created to
> hold extended attribute, not certain if that would be an issue.
> 
> I will look how other fs manage xattrs, I certainly don't want to
> modify how UBIFS manages extended attributes.

Oh, I missed the fact that ubifs xattrs are implemented as their own
inodes.  In that case, I guess you don't want to do what I said above,
and your current approach is fine (aside from moving it up before
d_instantiate and handling the error case).  ext4 doesn't implement the
xattr as a regular inode so that is different.

-- 
Stephen Smalley
National Security Agency

