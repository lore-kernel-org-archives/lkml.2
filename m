Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1FCWli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:41:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56906 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FCWlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:41:37 -0400
Date: Fri, 3 Jun 2011 23:41:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Scott Wood <scottwood@freescale.com>, Timur Tabi <timur@freescale.com>,
        alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] lib: introduce strdup_from_user
Message-ID: <20110603224133.GQ11521@ZenIV.linux.org.uk>
References: <1307119552-15573-1-git-send-email-timur@freescale.com>
 <BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
 <4DE92675.6080908@freescale.com>
 <BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>
 <4DE9294B.3040501@freescale.com>
 <BANLkTinqQS11nXQAJBMSvCrp4tOtCg5Qww@mail.gmail.com>
 <20110603135303.0800e4a7@schlenkerla.am.freescale.net>
 <BANLkTikmVncMdJhK0Hi6uWeiE_S9TtdhTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikmVncMdJhK0Hi6uWeiE_S9TtdhTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 10:12:37PM +0300, Alexey Dobriyan wrote:

> Because now you're lucky C strings are NUL-terminated.
> If this "idiom" applies to some other case like "validate + copy",
> we have a bug.
> 
> We copy data to kernelspace THEN validate or copy or whatever.
> This is obviously correct and safe.

In this case we don't know how _much_ needs to be copied, and that information
comes precisely from NUL-termination.  IOW, it's not a matter of luck at all.

"Copy the amount of bytes equal to the limit given to us, then truncate if
needed" is seriously broken in this case.  Think what happens if you have
a short string sitting in the middle of a page, with the next page not
mapped at all.  And ask to copy up to 4096 bytes.  The string itself is
much shorter than that.  However, trying to blindly copy those 4096 bytes
will give you -EFAULT.  Which is not what we want when copying strings
from userland.

We certainly do not want to *reread* them, but this "find the length, then
copy that much" is just fine.
