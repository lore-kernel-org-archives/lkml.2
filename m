Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0FDLOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:14:46 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:57645 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0FDLOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:14:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=B7HPf6bt5CTgqbAPZB9jMupe8Sw9NKsJEsp128H3VhW3aS+dKLp5rvLoolqEx3q3HL
         YLCwMpsluh+G3J2jEwzYo2oXV9tgtSw66HiT6IqOtZZzxtGkrn7q+IzB9u/5K0ndxxSk
         HvsOJfR/NsQPjK7Uzc9IuZ5w/vKZArPutWTl8=
Date: Fri, 4 Jun 2010 13:14:26 +0200
From: Dan Carpenter <error27@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Jens Axboe <jaxboe@fusionio.com>, Matthew Wilcox <matthew@wil.cx>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v2] fcntl: return -EFAULT if copy_to_user fails
Message-ID: <20100604111426.GF5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
	Jens Axboe <jaxboe@fusionio.com>, Matthew Wilcox <matthew@wil.cx>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100603100402.GR5483@bicker> <4C07826A.6060302@oss.ntt.co.jp> <20100603103542.GV5483@bicker> <4C07990A.8080508@fusionio.com> <4C079D34.5010500@oss.ntt.co.jp> <20100603124536.GW5483@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603124536.GW5483@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 02:45:36PM +0200, Dan Carpenter wrote:
> The heuristic I use is that if we return a variable which is the 
> return value of copy_to_user() and it's non-zero then complain.  It 
> didn't find the f_getown_ex() because that return value could come from
> copy_to_user() or it could be -EINVAL.
> 
> I'll mess with it a bit and see if I can make it catch the f_getown_ex()
> bug.
> 

I changed the heuristic to complain if we return a non-zero return from
copy_to_user() and the minimum possible value of the return is not zero.

	ret = copy_to_user();
	if (ret)
		return ret;  // <- Complain.  The minimum value is 1.

Or:

	if (!foo)
		ret = -ENOMEM;
	if (!ret)
		ret = copy_to_user();
	return ret;  // <- Complain.  The minimum value is -ENOMEM.

This seems to work pretty well.  I've fixed all the bugs this found and 
I've pushed the check to the smatch repo.

regards,
dan carpenter
