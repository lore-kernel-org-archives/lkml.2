Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab1ANDVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:21:04 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56944 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab1ANDU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:20:57 -0500
Date: Fri, 14 Jan 2011 03:20:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@gmail.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: vfs-scale, d_revalidate from nfsd
Message-ID: <20110114032052.GV19804@ZenIV.linux.org.uk>
References: <8855.1294927436@jrobl>
 <AANLkTik1bj=Z9xFv8JfYrxqefFL1owmH=Rctj=XnH4Mp@mail.gmail.com>
 <20110114030325.GU19804@ZenIV.linux.org.uk>
 <AANLkTi=H7Zhe4VMsh_tdrd7Atb9FX8j4AdiMNepXGsj9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=H7Zhe4VMsh_tdrd7Atb9FX8j4AdiMNepXGsj9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 02:12:35PM +1100, Nick Piggin wrote:
> The main idea here would be to just pass in a flags parameter rather
> thank poking in nd to get the rcu-walk status. That would solve this
> problem and also avoid nd for most filesystems that don't care about
> it.

Start with nd->flags getting passed explicitly, and be ready to see
	* call on the final stage of open split away and folded with
->lookup() and ->open()/->creat()
	* the rest of callers to lose nd completely.
That's what's going to happen in the next cycle.

BTW, why on the earth do you have that:
static int xattr_hide_revalidate(struct dentry *dentry, struct nameidata *nd)
{
        if (nd->flags & LOOKUP_RCU)
                return -ECHILD;
        return -EPERM;
}
when the sole intent of that sucker is to have dentry of /.xattr (pinned
in dcache and hashed all along) rejected on lookups from root?  IOW, WTF
bother with -ECHILD here at all?
