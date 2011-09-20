Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab1ITF6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 01:58:16 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:37194 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751845Ab1ITF6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 01:58:15 -0400
Date: Tue, 20 Sep 2011 09:58:12 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: POHMELFS is back
Message-ID: <20110920055812.GA7910@ioremap.net>
References: <20110919061302.GA19699@ioremap.net>
 <9891.1316455851@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9891.1316455851@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 02:10:51PM -0400, Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> On Mon, 19 Sep 2011 10:13:02 +0400, Evgeniy Polyakov said:
> > Elliptics is a distributed key/value storage, which by default
> > implements hash table system. It has datacenter-aware replica
> > management,
> 
> Can you please define "datacenter-aware"?  I've sat through a few too many
> buzzword-full but content-free vendor presentations. ;)

Elliptics allows to save your replicas in different datacenters and read
data either randomly from different groups or from the copy which is
closer to you. We also support 'weights' of the servers, so it is
possible to read data from the replica, which is hosted on the server
with highest weight.

> > First production elliptics cluster was deployed about 2 years ago,
> > it is close to 1 Pb (around 200 storage nodes in 4 datacenters) now with
> 
> Somehow, I'm not terribly thrilled with the idea of provisioning an entire
> storage node with CPUs and memory and an OS image for every 5Tb of disk. But
> then, I've currently got about 1Pb of DDN storage behind a 6-node GPFS cluster,
> and another 1Pb+ of DDN disk currently coming online in a CXFS/DMF
> configuration..
>
> > more that 4 Gb/s of bandwidth from each datacenter,
> 
> Also not at all impressive per-node if we're talking an average of 50 nodes per
> data center.  I'm currently waiting for some 10GigE to be provisioned at the
> moment because we're targeting close to a giga*byte*/sec per server.

If you get 10 times more bandwidth you will not be able to saturate it
with 10 times less servers. Scaling to hundreds of server nodes is a
good result, since we evenly balance all IO between nodes and no single
server is disk or network bound.

> > POHMELFS currently is rather alpha version, since it does not support
> > object removal 
> 
> I'm sure the storage vendors don't mind that. :)

Actually yes, we use garbage collection to actually remove data and do
not really care if it is not removed, since disk volumes and prices allow
not to care about disk space. But yet its kinda good idea to remove some
objects from listing when logic suggest to remove it :)

> A quick scan of the actual patch:
> 
> +	  Elliptics is a key/value storage, which by default imlpements
> +	  distributed hash table structure.
> 
> typo - implements.
> 
> +	struct kref			refcnt;
> +
> +	/* if set, all received inodes will be attached to dentries in parent dir */
> +	int				load_all;
> +
> +	/* currently read object name */
> +	u32				namelen;
> +
> +	/* currently read inode info */
> +	long				offset;
> 
> Ouch.  Usual kernel style would be:
> 
> 	int load_all; /* if set, all received inodes will be attached to dentries in parent dir */
> 	u32 namelen; /* currently read object name */
> 	long offset; /* currently read inode info */
> 
> I suspect it's just one programmer doing this, as it only happens in a few
> places and other places it's done the usual kernel way.
> 
> +static ssize_t pohmelfs_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos)
> +{
> +	ssize_t err;
> +	struct inode *inode = filp->f_mapping->host;
> +#if 0
> +	struct inode *inode = filp->f_mapping->host;
> 
> Just remove the #if 0'ed code.
> 
> in phhmelfs_fill_inode() (and probably other places):
> +	pr_info("pohmelfs: %s: ino: %lu inode is regular: %d, dir: %d, link: %d, mode: %o, "
> 
> pr_debug please.  pr_info per inode reference is just insane.
> 
> +void pohmelfs_print_addr(struct sockaddr_storage *addr, const char *fmt, ...)
> +		pr_info("pohmelfs: %pI4:%d: %s", &sin->sin_addr.s_addr, ntohs(sin->sin_port), ptr);
> 
> Gaak.  This apparently gets called *per read*. pr_debug *and* additional
> "please spam my log" flags please.
> 
> +static inline int dnet_id_cmp_str(const unsigned char *id1, const unsigned char *id2)
> +{
> +	unsigned int i = 0;
> +
> +	for (i*=sizeof(unsigned long); i<DNET_ID_SIZE; ++i) {
> 
> strncmp()?
> 
> Also, as a general comment - since this is an interface to Elliptics, which as
> far as I can tell runs in userspace, would this whole thing make more sense
> using FUSE?
> 
> I'm also assuming that Elliptics is responsible for all the *hard* parts of
> distributed filesystems, like quorum management and re-synching after a
> partition of the network, and so on?  If so, you really need to discuss that
> some more - in particular how well this all works during failure modes.
> 
> 
> 



-- 
	Evgeniy Polyakov
