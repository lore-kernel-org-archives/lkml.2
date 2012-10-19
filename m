Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030374Ab2JSO05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:26:57 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:50378 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030291Ab2JSO0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:26:53 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH 1/2] efi_pstore: hold multiple logs
Thread-Topic: [RFC][PATCH 1/2] efi_pstore: hold multiple logs
Thread-Index: Ac2jK99U09LpQXG2SOCTo9e3vvE7GwKf8wOAABYFMeA=
Date: Fri, 19 Oct 2012 14:26:33 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138796E1@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41386D119@USINDEM103.corp.hds.com>
 <CAGTjWtDgrDGN-+yCqfFsfaA8Xjbhj8nherA+puoGVRs-8vXO5g@mail.gmail.com>
In-Reply-To: <CAGTjWtDgrDGN-+yCqfFsfaA8Xjbhj8nherA+puoGVRs-8vXO5g@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-19_03:2012-10-19,2012-10-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1210190149
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Thank you for reviewing my patch.
Here is my comment.

> >   - Write callback
> >     - Check if there are enough spaces to write logs with QueryVariableInfo()
> >       to avoid handling out of space situation. (It is suggested by
> > Matthew Garrett.)
> >
> 
> I would prefer to see the exposing query_variable_info callback as a separate patch.  The check in the patch looks good.
>

OK. I will make a separate patch.

 
> >     - Remove a logic erasing existing entries.
> >
> >   - Erase callback
> >     - Freshly create a logic rather than sharing it with a write callback because
> >       erasing entries doesn't need in a write callback.
> >
> 
> This sort of change is a lot easier to review if you copy and paste the routine in a patch separate from this one.
> 

I will separate it as well.


> > +       /*
> > +        * Check if there is a space enough to log.
> > +        * size: a size of logging data
> > +        * DUMP_NAME_LEN * 2: a maximum size of variable name
> > +        *
> 
> extra line
> 

Will fix.

> > +
> > +       efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
> > +                                  size, psi->buf);
> > +
> > +       spin_unlock(&efivars->lock);
> > +
> > +       if (size)
> > +               ret = efivar_create_sysfs_entry(efivars,
> > +                                         utf16_strsize(efi_name,
> > +                                                       DUMP_NAME_LEN * 2),
> > +                                         efi_name, &vendor);
> 
> What is happening here?  Why is size checked for non-zero?
> 

I just copied an original code sharing a logic of write callback and erase callback.. 
But, if size is zero, we don't need to create a sysfs file because a set_variable service erases the entry.
It is defined in EFI specification.
So, I think this code is right.

> > +++ b/fs/pstore/inode.c
> > @@ -175,7 +175,8 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
> >         struct pstore_private *p = dentry->d_inode->i_private;
> >
> >         if (p->psi->erase)
> > -               p->psi->erase(p->type, p->id, p->psi);
> > +               p->psi->erase(p->type, p->id, dentry->d_inode->i_ctime,
> > +                             p->psi);
> 
> This doesn't look right.  What guarantees that the i_ctime means anything across reboots?
> 

Ctime is persistent across reboots because ctime of pstore means the date that the recode was
originally stored. (See below.)

To do this, efi_pstore saves the ctime to variable name at writing time and passes it to pstore at reading time.

fs/pstore/inode.c:
<snip>
/*
  * Make a regular file in the root directory of our file system.
  * Load it up with "size" bytes of data from "buf".
  * Set the mtime & ctime to the date that this record was originally stored.
  */
int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
                   char *data, size_t size, struct timespec time,
                   struct pstore_info *psi) {
         struct dentry           *root = pstore_sb->s_root;
         struct dentry           *dentry;
         struct inode            *inode;
         int                     rc = 0;
         char                    name[PSTORE_NAMELEN];
<snip>

Seiji
