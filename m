Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab0GWMrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:47:10 -0400
Received: from THUNK.ORG ([69.25.196.29]:37186 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab0GWMrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:47:08 -0400
Date: Fri, 23 Jul 2010 08:46:57 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: shenghui <crosslonelyover@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] check name_len before down_read xattr_sem and sb_read
 in ext2_xattr_get
Message-ID: <20100723124657.GA13090@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	shenghui <crosslonelyover@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>
References: <201007122229025316610@gmail.com>
 <20100721174457.GE1215@atrey.karlin.mff.cuni.cz>
 <AANLkTikXSOHrIw0SVJMYqsQy1aG5sCXkvvOFU4XLDNGv@mail.gmail.com>
 <20100723083759.GA3305@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723083759.GA3305@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 10:37:59AM +0200, Jan Kara wrote:
>   Checking of name_len is fine as you did it. But I wanted to point out
> that if name_len is greater than 255, you then go to 'cleanup' label which
> tries to do up_read(&EXT2_I(inode)->xattr_sem). But that's a bug because
> after you moved the code, we don't hold xattr_sem at the moment we check
> name_len.

Yup, you could just return -ERANGE right there.

The simpler fix though might be to just delete the check altogether.
Neither ext3 nor ext4 checks for the length of the xattr name in their
_xattr_get() function.  Instead they'll just do the search, and then
return -ENODATA.  That seems legit; there can be no entries larger
than 255, so saying the extended attribute doesn't exist is quite
correct.  There is a check in the _xattr_set() functions for both ext3
and ext4, which is quite correct and proper.

Does that mean we'll end up doing a search before returning an error
--- yes, but I don't think that matters.  Why should we care about
optimizing an error case?  It's not like this is going to be in a
timing sensitive part of an application....  (of course the same
consideration could apply to your patch as well).

	      	    	     	  	- Ted
