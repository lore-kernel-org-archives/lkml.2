Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1DNURg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:17:36 -0400
Received: from mail-04.jhb.wbs.co.za ([196.2.97.3]:58553 "EHLO
	mail-04.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1DNURe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:17:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0RACJVp03AqIOI/2dsb2JhbACETpJZjlF4gQ2xGZE6gwGBdXgEjW8
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression] 2.6.38 ncpfs
Date: Thu, 14 Apr 2011 22:17:12 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.36.2-desktop-2mnb; KDE/4.4.3; x86_64; ; )
Cc: npiggin@kernel.dk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>,
        Petr Vandrovec <petr@vandrovec.name>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@lst.de>
References: <201104051858.20304.bonganilinux@mweb.co.za> <201104141914.23529.bonganilinux@mweb.co.za> <BANLkTin=xwfr5aVhzyL_FFo3K3SNMW9OQw@mail.gmail.com>
In-Reply-To: <BANLkTin=xwfr5aVhzyL_FFo3K3SNMW9OQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_IZ1pN9FAh6oEQMT"
Message-Id: <201104142217.12478.bonganilinux@mweb.co.za>
X-GeoIP: ZA|South Africa
X-EximConfig: v2.5 on mail.iburst.co.za
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_IZ1pN9FAh6oEQMT
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Thursday 14 April 2011 19:29:34 Linus Torvalds wrote:
> On Thu, Apr 14, 2011 at 10:14 AM, Bongani Hlope <bonganilinux@mweb.co.za> 
wrote:
> > The bug is caused by commit fb2d5b86aff355a27ebfc132d3c99f4a940cc3fe,
> > which was committed by Nick. Can you please either revert Nick's changes
> > or include the attached patch (or a better version, because I'm not that
> > clued up with ncpfs).
> 
> Hmm. Your patch isn't correct. You can't just do
> 
>    if (!mutex_is_locked(&dentry->d_inode->i_mutex)) {
>       mutex_lock(&inode->i_mutex);
> 
> because code like that makes no sense - maybe it was locked by
> somebody _else_, and you would need to lock it.
> 
> That said, I do think that the
> 
>   BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
> 
> is wrong, since even the comment above it talks about the _parent_
> dentry, not the dentry that is actually being modified.
> 
> So there's clearly a bug somewhere, and the fix may be to just remove
> that BUG_ON().
> 
> Added some more people to the cc.
> 
>                                    Linus

Looking at the changes,  you are right. The BUG_ON() seems to be what is not 
suppose to be there. The attached patch only removes the BUG_ON(). I'll test 
on my work PC tomorrow and see if that also fixes the bug.

The previous code was:

               if (qname.len == newdent->d_name.len &&
                   memcmp(newdent->d_name.name, qname.name, newdent-
>d_name.len)) {
8<
                        */
                       if (inode)
                               mutex_lock(&inode->i_mutex);
                       spin_lock(&dcache_lock);
                       spin_lock(&newdent->d_lock);
                       memcpy((char *) newdent->d_name.name, qname.name,
                                                               newdent-
>d_name.len);
                       spin_unlock(&newdent->d_lock);
                       spin_unlock(&dcache_lock);
                       if (inode)
                               mutex_unlock(&inode->i_mutex);
               }

and it was replaced by:

       BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
       BUG_ON(dentry->d_name.len != name->len); /* d_lookup gives this */

       spin_lock(&dcache_lock);
       spin_lock(&dentry->d_lock);
       memcpy((unsigned char *)dentry->d_name.name, name->name, name->len);
       spin_unlock(&dentry->d_lock);
       spin_unlock(&dcache_lock);

--Boundary-00=_IZ1pN9FAh6oEQMT
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ncpfs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ncpfs.patch"

diff --git a/fs/dcache.c b/fs/dcache.c
index ad25c4c..39fa508 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2131,7 +2131,6 @@ EXPORT_SYMBOL(d_rehash);
  */
 void dentry_update_name_case(struct dentry *dentry, struct qstr *name)
 {
-	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
 	BUG_ON(dentry->d_name.len != name->len); /* d_lookup gives this */
 
 	spin_lock(&dentry->d_lock);

--Boundary-00=_IZ1pN9FAh6oEQMT--
