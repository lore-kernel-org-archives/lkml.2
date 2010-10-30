Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0J3PQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 11:16:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46554 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0J3PQC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 11:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=daCk+xoUyQmsJpU/yWdYBRqI5HWG2OfbHIcJ/lDtaqaS9urnFjspV6vEbkAP27jpA/
         LRWaViwW/OmyuU/Facy8ZsKnoAKiGeMn9H+UQl5HF2UsgemqQNj75igUZBoDAQVRJsLR
         jYYXHWVZxF/yNfI7QBWsbxoLzTzyrct1EJA6I=
MIME-Version: 1.0
Date: Sat, 30 Oct 2010 16:15:44 +0100
Message-ID: <AANLkTinVpZoQ9x5O4v5A718LeWzVBsFUiZgHc9FwoRKH@mail.gmail.com>
Subject: [2.6.37-rc0 patch] direct I/O submission fixes v3
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>, Josef Bacik <josef@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

These patches from myself and Josef are still relevant, but not in
your last mainline pull request.

Can you add them if you are happy please? I've rediffed them [1,2]
against your for-linux tree.

Many thanks,
  Daniel

--- [1]

Fix use-after-free on error path.

Signed-off-by: Josef Bacik <josef@redhat.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 558cac2..986cc40 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5761,7 +5761,7 @@ free_ordered:
 	if (write) {
 		struct btrfs_ordered_extent *ordered;
 		ordered = btrfs_lookup_ordered_extent(inode,
-						      dip->logical_offset);
+						      file_offset);
 		if (!test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags) &&
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
 			btrfs_free_reserved_extent(root, ordered->start,

--- [2]

Fix leak of 'dip' on error path and unnecessary double-assignment.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 558cac2..312eeb7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5701,15 +5701,15 @@ static void btrfs_submit_direct(int rw, struct
bio *bio, struct inode *inode,
 		ret = -ENOMEM;
 		goto free_ordered;
 	}
-	dip->csums = NULL;

 	if (!skip_sum) {
 		dip->csums = kmalloc(sizeof(u32) * bio->bi_vcnt, GFP_NOFS);
 		if (!dip->csums) {
 			ret = -ENOMEM;
-			goto free_ordered;
+			goto out_err;
 		}
-	}
+	} else
+		dip->csums = NULL;

 	dip->private = bio->bi_private;
 	dip->inode = inode;

---------- Forwarded message ----------
From: Daniel J Blueman <daniel.blueman@gmail.com>
Date: 25 July 2010 19:53
Subject: Re: [2.6.35-rc6 patch] direct I/O submission fixes v2
To: Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>


On 25 July 2010 15:42, Josef Bacik <josef@redhat.com> wrote:
> On Sat, Jul 24, 2010 at 12:01:59AM +0100, Daniel J Blueman wrote:
>> Hi Chris,
>>
>> This fixes some issues relating to direct I/O submission, however a
>> further patch will be needed to handle the case where allocation of
>> 'dip' fails, which is always dereferenced when finding the ordered
>> extent.
>>
>
> Hi,
>
> There's an easier way to do this.  This patch should fix the problem,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3232945..7259ef9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5815,7 +5815,7 @@ free_ordered:
>        if (write) {
>                struct btrfs_ordered_extent *ordered;
>                ordered = btrfs_lookup_ordered_extent(inode,
> -                                                     dip->logical_offset);
> +                                                     file_offset);
>                if (!test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags) &&
>                    !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
>                        btrfs_free_reserved_extent(root, ordered->start,
>

Good move!

With your patch applied, mine (now not priority) then becomes:

Fix leak of 'dip' on error path and double assignment.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1bff92a..bd7f940 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5652,15 +5652,15 @@ static void btrfs_submit_direct(int rw, struct
bio *bio, struct inode *inode,
               ret = -ENOMEM;
               goto free_ordered;
       }
-       dip->csums = NULL;

       if (!skip_sum) {
               dip->csums = kmalloc(sizeof(u32) * bio->bi_vcnt, GFP_NOFS);
               if (!dip->csums) {
                       ret = -ENOMEM;
-                       goto free_ordered;
+                       goto out_err;
               }
-       }
+       } else
+               dip->csums = NULL;

       dip->private = bio->bi_private;
       dip->inode = inode;
-- 
Daniel J Blueman
