Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab1ISSLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:11:30 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50399 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab1ISSLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:11:16 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: POHMELFS is back
In-Reply-To: Your message of "Mon, 19 Sep 2011 10:13:02 +0400."
             <20110919061302.GA19699@ioremap.net>
From: Valdis.Kletnieks@vt.edu
References: <20110919061302.GA19699@ioremap.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316455851_2864P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Sep 2011 14:10:51 -0400
Message-ID: <9891.1316455851@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4E7785AD.0016,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316455851_2864P
Content-Type: text/plain; charset=us-ascii

On Mon, 19 Sep 2011 10:13:02 +0400, Evgeniy Polyakov said:

Please don't take the below in the wrong way - I *realize* that POHMELFS is
still staging/ caliber, and my official $DAYJOB is provisioning storage for our
HPC people.  Mostly giving you a feel for what sort of scaling you need to be
thinking about as you continue development...

> Elliptics is a distributed key/value storage, which by default
> implements hash table system. It has datacenter-aware replica
> management,

Can you please define "datacenter-aware"?  I've sat through a few too many
buzzword-full but content-free vendor presentations. ;)

> First production elliptics cluster was deployed about 2 years ago,
> it is close to 1 Pb (around 200 storage nodes in 4 datacenters) now with

Somehow, I'm not terribly thrilled with the idea of provisioning an entire
storage node with CPUs and memory and an OS image for every 5Tb of disk. But
then, I've currently got about 1Pb of DDN storage behind a 6-node GPFS cluster,
and another 1Pb+ of DDN disk currently coming online in a CXFS/DMF
configuration..

> more that 4 Gb/s of bandwidth from each datacenter,

Also not at all impressive per-node if we're talking an average of 50 nodes per
data center.  I'm currently waiting for some 10GigE to be provisioned at the
moment because we're targeting close to a giga*byte*/sec per server.

> POHMELFS currently is rather alpha version, since it does not support
> object removal 

I'm sure the storage vendors don't mind that. :)

A quick scan of the actual patch:

+	  Elliptics is a key/value storage, which by default imlpements
+	  distributed hash table structure.

typo - implements.

+	struct kref			refcnt;
+
+	/* if set, all received inodes will be attached to dentries in parent dir */
+	int				load_all;
+
+	/* currently read object name */
+	u32				namelen;
+
+	/* currently read inode info */
+	long				offset;

Ouch.  Usual kernel style would be:

	int load_all; /* if set, all received inodes will be attached to dentries in parent dir */
	u32 namelen; /* currently read object name */
	long offset; /* currently read inode info */

I suspect it's just one programmer doing this, as it only happens in a few
places and other places it's done the usual kernel way.

+static ssize_t pohmelfs_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos)
+{
+	ssize_t err;
+	struct inode *inode = filp->f_mapping->host;
+#if 0
+	struct inode *inode = filp->f_mapping->host;

Just remove the #if 0'ed code.

in phhmelfs_fill_inode() (and probably other places):
+	pr_info("pohmelfs: %s: ino: %lu inode is regular: %d, dir: %d, link: %d, mode: %o, "

pr_debug please.  pr_info per inode reference is just insane.

+void pohmelfs_print_addr(struct sockaddr_storage *addr, const char *fmt, ...)
+		pr_info("pohmelfs: %pI4:%d: %s", &sin->sin_addr.s_addr, ntohs(sin->sin_port), ptr);

Gaak.  This apparently gets called *per read*. pr_debug *and* additional
"please spam my log" flags please.

+static inline int dnet_id_cmp_str(const unsigned char *id1, const unsigned char *id2)
+{
+	unsigned int i = 0;
+
+	for (i*=sizeof(unsigned long); i<DNET_ID_SIZE; ++i) {

strncmp()?

Also, as a general comment - since this is an interface to Elliptics, which as
far as I can tell runs in userspace, would this whole thing make more sense
using FUSE?

I'm also assuming that Elliptics is responsible for all the *hard* parts of
distributed filesystems, like quorum management and re-synching after a
partition of the network, and so on?  If so, you really need to discuss that
some more - in particular how well this all works during failure modes.




--==_Exmh_1316455851_2864P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOd4WrcC3lWbTT17ARAtBNAJ4l42q85icZqm/I+eeDMDcamXWKrgCdFk7w
zv93OcFTU7rrRBlsrX8v4eQ=
=bOek
-----END PGP SIGNATURE-----

--==_Exmh_1316455851_2864P--

