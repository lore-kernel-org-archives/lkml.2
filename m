Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1LGBpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:45:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39663 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1LGBo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:44:59 -0500
Date: Wed, 7 Dec 2011 01:44:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207014458.GT2203@ZenIV.linux.org.uk>
References: <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
 <4EDE94DC.8010106@canonical.com>
 <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com>
 <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk>
 <20111207003922.GO2203@ZenIV.linux.org.uk>
 <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
 <20111207011047.GQ2203@ZenIV.linux.org.uk>
 <20111207013720.GS2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207013720.GS2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 01:37:20AM +0000, Al Viro wrote:
> +	if (path->mnt->mnt_flags & MNT_INTERNAL) {
> +		/* it's not mounted anywhere */
> +		res = dentry_path(path->dentry, buf, buflen);
> +		*name = res;
> +		if (IS_ERR(res)) {
> +			*name = buf;
> +			return PTR_ERR(res);
> +		}
> +		if (path->dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
> +		    strncmp(*name, "/sys/", 5) == 0) {
> +			/* TODO: convert over to using a per namespace
> +			 * control instead of hard coded /proc
> +			 */
> +			return prepend(name, *name - buf, "/proc", 5);


Incidentally, why only /proc/sys?  For one thing, we won't be accessing
anything else on internal vfsmount of proc, so strncmp() part looks
wrong; for another, if some code starts doing that, why would acting
as if it was on normally mounted /proc be the wrong thing?  John?
