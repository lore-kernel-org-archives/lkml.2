Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab2DDN3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:29:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab2DDN3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:29:52 -0400
Message-ID: <4F7C4CC8.7060007@suse.de>
Date: Wed, 04 Apr 2012 09:29:44 -0400
From: Jeff Mahoney <jeffm@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs/extent_io.c: return -ENOMEM instead of BUG_ON on
 allocation failure in set_extent_bit if __GFP_WAIT is set in the mask
References: <4F76B15D.9010801@gmail.com>
In-Reply-To: <4F76B15D.9010801@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/31/2012 03:25 AM, Wang Sheng-Hui wrote:
> If __GFP_WAIT is set in the mask, set_extent_bit should return 
> -ENOMEM to its caller to decide what to do on allocation failure, 
> instead of BUG_ON.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com> --- 
> fs/btrfs/extent_io.c |    3 ++- 1 files changed, 2 insertions(+), 1
> deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c index
> b67814c..fd2411e 100644 --- a/fs/btrfs/extent_io.c +++
> b/fs/btrfs/extent_io.c @@ -720,7 +720,8 @@ int
> set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, 
> again: if (!prealloc && (mask & __GFP_WAIT)) { prealloc =
> alloc_extent_state(mask); -		BUG_ON(!prealloc); +		if (!prealloc) +
> return -ENOMEM; }
> 
> spin_lock(&tree->lock);

Hi Sheng-Hui -

Do you have a follow-on series to this? With the exception of the
set_extent_dirty call in end_bio_extent_readpage, every set_extent_bit
caller uses GFP_NOFS, which includes __GFP_WAIT. If we return a
failure here, we need to catch the failure in the call sites.
Otherwise, the failure will just be ignored and we'll end up with an
inconsistent extent state tree.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPfEzIAAoJEB57S2MheeWyqcoP/RagYePToMYOdgjjxVz2cwkf
BLT5B0KWWaJa0KtEOpgQATmldmA4CCq6WmC7R/Omy1q9RD75rheKxaxuQY35NTFe
czBSfVr3VeMy1A6dIK+wHOiAfheuT90xSgXJJMpdkjHmNjEA1g2nupAFltUE/L70
+xFxotBuoYuTe8u++QES0JGqnw8YI6FW0z3Z4buyoqRhgiX7TukNfXXgx4c2HI0/
cOkxyvYpDi2WF9EtESn/ekwf4Rjx9kNUX/9owmDWYgHD4MLjwSQsRbwZ7BrZEM3k
aBe8yZGpgr3UuL9nGiPbWHsyBeAskvXaL6Y2YIczJSvsoP/DM+9SsHAwnqkVaBHv
8qQiQqUhF1mrdl3GBSvKJarGczrSmbWZ5X94oYq4MCKyi3SeTN/bcJS+p5EV1Tvs
LMRqqj26leHnl+bYKGWIfJqQRuYcfbkzTOADbn54iMYj2aG2raUjI9D53TUIInuV
Csm2hhKJn+HDwu2+gZX1F99W0ehs1ps86oGfkT4WA/H7fTmugiEYxsM1Dk71Ti7/
eadns62DYFZyzKk4/jP/8Rjygc4YM/T2F9qb+SX3hWGhIIZiz5qOxjgBZy91i+84
W+DDUHjZPU+O14nNlKFA3INGS9823ENklRkzpNUhLx7ffrCLOAS73O2rzHcaSmtk
FSDWO4EqxIAi4t3LoL14
=Pxwh
-----END PGP SIGNATURE-----
