Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1AOSfE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 13:35:04 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60903 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab1AOSfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 13:35:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cYv/I3740K2T/KuB4hU9x6UyeKO2F+sphafjacfwTJa4T9s5fVPjHrgOUqgclmu3Hu
         2SCSVwFpWfCd914hT+PV5+ZNksl0KQlT+RYFQz/xcpkbkAMWsvDNpxmwTK+zDlbR8e7V
         w2BwLA916ZnrFfHoJelhVbYZlx02QtUpkOuNM=
MIME-Version: 1.0
In-Reply-To: <6291.1295063252@jrobl>
References: <8855.1294927436@jrobl>
	<AANLkTik1bj=Z9xFv8JfYrxqefFL1owmH=Rctj=XnH4Mp@mail.gmail.com>
	<20110114030325.GU19804@ZenIV.linux.org.uk>
	<AANLkTi=H7Zhe4VMsh_tdrd7Atb9FX8j4AdiMNepXGsj9@mail.gmail.com>
	<6291.1295063252@jrobl>
Date: Sun, 16 Jan 2011 05:11:01 +1100
Message-ID: <AANLkTinnCNskNku=Ps75+PWgwH2tK9GbC7RbCkiPDgD2@mail.gmail.com>
Subject: Re: vfs-scale, d_revalidate from nfsd
From: Nick Piggin <npiggin@gmail.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 2:47 PM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Nick Piggin:
>> Of course. I was discussing it with Miklos yesterday too, but haven't
>> finished getting a proposal together.
>>
>> The main idea here would be to just pass in a flags parameter rather
>> thank poking in nd to get the rcu-walk status. That would solve this
>> problem and also avoid nd for most filesystems that don't care about
>> it.
>
> Let me make sure.
> - add a flag parameter to ->d_revalidate. not remove the panameter nd.
> - FS ->d_revalidate() will (probably) return -ECHILD when LOOKUP_RCU is
>  set.
> Right?
>
>
> Then how about the callers?
> Current sequence is
> - NFSD calls lookup_one_len
> - __lookup_hash
> - do_revalidate
> - d_revalidate
> {
>        status = dentry->d_op->d_revalidate(dentry, nd);
>        if (status == -ECHILD) {
>                ;;;
>                status = dentry->d_op->d_revalidate(dentry, nd);
>        }
> }
>
> There will be no change in NFSD but VFS d_revalidate(), such like this?
> VFS d_revalidate()
> {
>        if (nd) {
>                dentry->d_op->d_revalidate(dentry, nd, nd->flags);
>                if (-ECHILD) {
>                        dentry->d_op->d_revalidate(dentry, nd, nd->flags);
>                }
>        } else
>                return dentry->d_op->d_revalidate(dentry, NULL, 0);
> }

Yes that's the idea. I also want to pass a struct inode * parameter, to
facilitate rcu-walk implementations that want to check the inode
(such as fuse).
