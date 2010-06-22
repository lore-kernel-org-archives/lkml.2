Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab0FVF4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 01:56:04 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:65046 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab0FVF4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 01:56:01 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [autofs] [PATCH 04/38] autofs4: Save autofs trigger's vfsmount in super block info
To: Ian Kent <raven@themaw.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       vaurora@redhat.com, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, jblunck@suse.de
In-Reply-To: <1277181999.2829.2.camel@localhost>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-5-git-send-email-vaurora@redhat.com> <1276661043.2339.35.camel@localhost> <1277091579.3827.9.camel@localhost> <E1OQghj-0001Bt-RU@pomaz-ex.szeredi.hu> <1277181999.2829.2.camel@localhost>
Date: Tue, 22 Jun 2010 14:49:16 +0900
Message-ID: <26799.1277185756@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ian Kent:
> +static vfsmount *autofs4_find_vfsmount(struct path *parent, struct dentry *root)
> +{
> +	struct vfsmount *mnt = NULL;
> +	struct dentry *child;
> +
> +	spin_lock(&dcache_lock);
> +	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {

dentry->d_subdirs?
parent->dentry->...?

Or how about iterate_mounts() instead of loop over dentries?
For example (just a example),

struct args {
	/* input */
	struct dentry *root;

	/* output */
	struct vfsmount *mnt;
};

static int compare_mnt(struct vfsmount *mnt, void *arg)
{
	struct args *a = arg;

	if (mnt->mnt_root != a->root)
		return 0;
	a->mnt = mntget(mnt);
	return 1;
}

struct vfsmount *autofs4_find_vfsmount(struct dentry *root)
{
	int err;
	struct args args = {
		.root = root
	};

	err = iterate_mounts(compare_mnt, &args, current->nsproxy->mnt_ns);
}


J. R. Okajima
