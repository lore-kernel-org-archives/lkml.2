Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1AODrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 22:47:42 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:47225 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1AODrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 22:47:41 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: vfs-scale, d_revalidate from nfsd
To: Nick Piggin <npiggin@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=H7Zhe4VMsh_tdrd7Atb9FX8j4AdiMNepXGsj9@mail.gmail.com>
References: <8855.1294927436@jrobl> <AANLkTik1bj=Z9xFv8JfYrxqefFL1owmH=Rctj=XnH4Mp@mail.gmail.com> <20110114030325.GU19804@ZenIV.linux.org.uk> <AANLkTi=H7Zhe4VMsh_tdrd7Atb9FX8j4AdiMNepXGsj9@mail.gmail.com>
Date: Sat, 15 Jan 2011 12:47:32 +0900
Message-ID: <6291.1295063252@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick Piggin:
> Of course. I was discussing it with Miklos yesterday too, but haven't
> finished getting a proposal together.
>
> The main idea here would be to just pass in a flags parameter rather
> thank poking in nd to get the rcu-walk status. That would solve this
> problem and also avoid nd for most filesystems that don't care about
> it.

Let me make sure.
- add a flag parameter to ->d_revalidate. not remove the panameter nd.
- FS ->d_revalidate() will (probably) return -ECHILD when LOOKUP_RCU is
  set.
Right?


Then how about the callers?
Current sequence is
- NFSD calls lookup_one_len
- __lookup_hash
- do_revalidate
- d_revalidate
{
	status = dentry->d_op->d_revalidate(dentry, nd);
	if (status == -ECHILD) {
		;;;
		status = dentry->d_op->d_revalidate(dentry, nd);
	}
}

There will be no change in NFSD but VFS d_revalidate(), such like this?
VFS d_revalidate()
{
	if (nd) {
		dentry->d_op->d_revalidate(dentry, nd, nd->flags);
		if (-ECHILD) {
			dentry->d_op->d_revalidate(dentry, nd, nd->flags);
		}
	} else
		return dentry->d_op->d_revalidate(dentry, NULL, 0);
}


J. R. Okajima
