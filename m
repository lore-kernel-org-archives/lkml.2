Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1ITGHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 02:07:24 -0400
Received: from tservice.ru ([195.178.208.66]:44994 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752258Ab1ITGHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 02:07:23 -0400
Date: Tue, 20 Sep 2011 10:07:22 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: POHMELFS is back
Message-ID: <20110920060722.GC7910@ioremap.net>
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

Code part comments

On Mon, Sep 19, 2011 at 02:10:51PM -0400, Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> +static ssize_t pohmelfs_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos)
> +{
> +	ssize_t err;
> +	struct inode *inode = filp->f_mapping->host;
> +#if 0
> +	struct inode *inode = filp->f_mapping->host;
> 
> Just remove the #if 0'ed code.

Actually I need to remove other part, it is kind of debugging part :)

> in phhmelfs_fill_inode() (and probably other places):
> +	pr_info("pohmelfs: %s: ino: %lu inode is regular: %d, dir: %d, link: %d, mode: %o, "
> 
> pr_debug please.  pr_info per inode reference is just insane.

Yes, I will clean up all prints for sure

> +void pohmelfs_print_addr(struct sockaddr_storage *addr, const char *fmt, ...)
> +		pr_info("pohmelfs: %pI4:%d: %s", &sin->sin_addr.s_addr, ntohs(sin->sin_port), ptr);
> 
> Gaak.  This apparently gets called *per read*. pr_debug *and* additional
> "please spam my log" flags please.

Please do not be scared by log prints ,they will be cleanup up for
release

> +static inline int dnet_id_cmp_str(const unsigned char *id1, const unsigned char *id2)
> +{
> +	unsigned int i = 0;
> +
> +	for (i*=sizeof(unsigned long); i<DNET_ID_SIZE; ++i) {
> 
> strncmp()?

Actually yes

> Also, as a general comment - since this is an interface to Elliptics, which as
> far as I can tell runs in userspace, would this whole thing make more sense
> using FUSE?

I tried FUSE about 3 years ago, it had _serious_ problems with
performance. Disk storage can run in userspace, since it is never
limited by CPU or copies, but client may not be allowed to waste that
much resources. 

> I'm also assuming that Elliptics is responsible for all the *hard* parts of
> distributed filesystems, like quorum management and re-synching after a
> partition of the network, and so on?  If so, you really need to discuss that
> some more - in particular how well this all works during failure modes.

Yes, POHMELFS is just an another interface.
Elliptics uses eventual consistency model, so when replicas go out of
sync, special checking process starts to bring them back. It also
recovers missed copy, if we replaced disk/server or added new one.

When some servers go down, all IO is handled by their neighbours
according to route tabe generated on the first start. When servers are
turned on again, they start getting those IO requests, and eventual
consistency process rolls out missed writes. If data is old or missed we
will switch to another replica.

Thanks a lot for review!

-- 
	Evgeniy Polyakov
