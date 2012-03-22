Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2CVUJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:09:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55038 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2CVUJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:09:22 -0400
Date: Thu, 22 Mar 2012 20:09:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: Regression introduced by
 bfcfaa77bdf0f775263e906015982a608df01c76 (vfs: use 'unsigned long' accesses
 for dcache name comparison and hashing)
Message-ID: <20120322200918.GZ6589@ZenIV.linux.org.uk>
References: <20120322183845.GA17264@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322183845.GA17264@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 02:38:46PM -0400, Konrad Rzeszutek Wilk wrote:
> while v3.3 with your patch:
> 
> 
> 8:01:09 # 10 :/proc/xen/ 
> > ls -al
> ls: cannot access xsd_port: No such file or directory
> total 0
> drwxr-xr-x   2 root root 0 Mar 22 17:57 .
> dr-xr-xr-x 126 root root 0 Mar 22 17:57 ..
> -r--r--r--   1 root root 0 Mar 22 17:57 capabilities
> -rw-------   1 root root 0 Mar 22 17:57 privcmd
> -rw-------   1 root root 0 Mar 22 17:57 xenbus
> -rw-------   1 root root 0 Mar 22 17:57 xsd_kva
> -?????????   ? ?    ?    ?            ? xsd_port
> 
> 
> Looking at the code that sets up 'xsd_port' it looks pretty innocent
> and similar to other drivers (ibmasm for example).

Interesting... that's exactly 8 characters.  Oh, I see - hash_name() gets
an extra multiplication by 9 in this case.  Look: full_name_hash() will
handle the first word, decrement len by 8, set hash to <first word> and
bugger off on !len.  hash_name(), OTOH, will go through the loops once,
with hash and a both 0.  hash stays 0, a becomes <first word>.  No NUL or
/ in it, so in we go again; hash becomes a * 9, i.e. <first word> * 9.
a becomes the second word, with mask != 0.  And we are out of the loop,
and proceed to add nothing to hash (the name is over at that point).  As
the result, we get hash mismatch for names that are 8 bytes long or
multiple thereof.

