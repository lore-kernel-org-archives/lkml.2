Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031283Ab2CVV76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:59:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44076 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031165Ab2CVV75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:59:57 -0400
Date: Thu, 22 Mar 2012 21:59:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: Regression introduced by
 bfcfaa77bdf0f775263e906015982a608df01c76 (vfs: use 'unsigned long' accesses
 for dcache name comparison and hashing)
Message-ID: <20120322215952.GG6589@ZenIV.linux.org.uk>
References: <20120322183845.GA17264@phenom.dumpdata.com>
 <20120322200918.GZ6589@ZenIV.linux.org.uk>
 <20120322202445.GB6589@ZenIV.linux.org.uk>
 <20120322203658.GC6589@ZenIV.linux.org.uk>
 <20120322214157.GB12985@phenom.dumpdata.com>
 <CA+55aFxBS3bJoB8BiUR3Ni2KqpK5ofxSBC9+LcgRRoxYGAMKjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxBS3bJoB8BiUR3Ni2KqpK5ofxSBC9+LcgRRoxYGAMKjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 02:54:37PM -0700, Linus Torvalds wrote:
> On Thu, Mar 22, 2012 at 2:41 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >
> > Works for me! Thanks for coming up with a patch so quickly. Please add
> >
> > Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Goodie. Al, I can commit it as yours, but I'd want a sign-off and a
> commit message for that. Otherwise I'll take credit..

Hmm...  How about

Fix full_name_hash() behaviour when length is a multiple of 8

We want it to match what hash_name() is doing, which means extra
multiply by 9 in this case...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/namei.c b/fs/namei.c
index 13e6a1f..7451d6f8 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1439,10 +1439,10 @@ unsigned int full_name_hash(const unsigned char *name, unsigned int len)
 
 	for (;;) {
 		a = *(unsigned long *)name;
-		hash *= 9;
 		if (len < sizeof(unsigned long))
 			break;
 		hash += a;
+		hash *= 9;
 		name += sizeof(unsigned long);
 		len -= sizeof(unsigned long);
 		if (!len)
