Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab0GNQZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:25:34 -0400
Received: from mx2.sophos.com ([195.166.81.53]:57668 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab0GNQZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:25:32 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2010 12:25:32 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Greg KH <greg@kroah.com>
Subject: Re: BUG: Securityfs and bind mounts (2.6.34)
Date: Wed, 14 Jul 2010 17:19:46 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <201007081112.41252.tvrtko.ursulin@sophos.com> <201007081632.42069.tvrtko.ursulin@sophos.com> <20100708154648.GA13923@kroah.com>
In-Reply-To: <20100708154648.GA13923@kroah.com>
MIME-Version: 1.0
Message-ID: <201007141719.46488.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 14/07/2010 17:19:46,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 14/07/2010 17:19:46,
	Serialize complete at 14/07/2010 17:19:46
Content-Type: multipart/mixed; boundary="Boundary-00=_iOePM2mXbQp0324"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_iOePM2mXbQp0324
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Thursday 08 Jul 2010 16:46:48 Greg KH wrote:
> On Thu, Jul 08, 2010 at 04:32:42PM +0100, Tvrtko Ursulin wrote:
> > On Thursday 08 Jul 2010 16:20:59 Greg KH wrote:
> > > > :) Well I do not know, but, it kind of smelled like a bug in the
> > > > : vfs/mount
> > > >
> > > > handling/securityfs area so I thought to let experts know. I _think=
_
> > > > I did nothing that much wrong. Just used the exposed API
> > > > (securityfs_remove) and some bind mount shuffling from userspace.
> > >
> > > securitfs just uses libfs underneath it, and really doesn't have any
> > > bindings for module ownerships, so I wouldn't recommend doing what yo=
u
> > > just did.
> >
> > Just do double check what you are saying, securityfs is not safe for us=
e
> > from modules? If so I would then recommend removing the exports otherwi=
se
> > it is an invitation to shoot yourself into the foot.
>
> Hm, did you properly set the module owner of the file_operations that
> you passed to securityfs?  That should protect if you have an open file,
> but I doubt anyone thought you would do crazy things like bind mounts on
> top of a ramfs and then think it was safe to unload a lower module :)

Hi again,

Here is the reproducer. Build the attached test module and put test.ko in t=
he
cwd. Then run:

umount /sys/kernel/security
mount none -t securityfs /sys/kernel/security/
insmod test.ko
mount file --bind /sys/kernel/security/test/file
rmmod test
insmod test.ko
umount /sys/kernel/security/test/file
umount /sys/kernel/security # <-------- BANG:

It is a bit different than what I initially said. It looks like reference
counting on a dentry gets messed up once securityfs_create_dir() in second
insmod of test.ko fails with -EEXIST.

HTH,

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United=
 Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.

--Boundary-00=_iOePM2mXbQp0324
Content-Transfer-Encoding: 7bit
Content-Type: text/x-csrc; charset="UTF-8"; name="test.c"
Content-Disposition: attachment; filename="test.c"

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/security.h>


static struct dentry *root;
static struct dentry *file;


static int test_open(struct inode *inode, struct file *file)
{
    return -1;
}

static struct file_operations test_fops = {
    .owner =    THIS_MODULE,
    .open =     test_open,
};


static int __init test_init(void)
{
    root = securityfs_create_dir("test", NULL);
    if (IS_ERR(root)) {
        printk("error creating root %d\n", PTR_ERR(root));
        return PTR_ERR(root);
    }

    file = securityfs_create_file("file", S_IRUSR, root, NULL, &test_fops);
    if (IS_ERR(file)) {
        printk("error creating file %d\n", PTR_ERR(file));
        securityfs_remove(root);
        return PTR_ERR(file);
    }

    return 0;
}

static void __exit test_exit(void)
{
    securityfs_remove(file);
    securityfs_remove(root);
}

MODULE_LICENSE("GPL");

module_init(test_init);
module_exit(test_exit);

--Boundary-00=_iOePM2mXbQp0324--
