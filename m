Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab1KVAta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:49:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57381 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab1KVAt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:49:29 -0500
MIME-Version: 1.0
In-Reply-To: <20111121233258.GA18466@google.com>
References: <20111121233258.GA18466@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Nov 2011 16:49:07 -0800
X-Google-Sender-Auth: zf-dXqtN8jh0SzVF4O92U1kbWJE
Message-ID: <CA+55aFw1XMbJTBifw1sSUN-7cC2BdeeZwPrqkxsboAo6SFSoNw@mail.gmail.com>
Subject: Re: [PATCH] eCryptfs: Check array bounds for filename characters
To: Michael Halcrow <mhalcrow@google.com>
Cc: tyhicks@canonical.com, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, thieule@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 3:32 PM, Michael Halcrow <mhalcrow@google.com> wrote:
> Characters with ASCII values greater than the size of
> filename_rev_map[] are valid filename
> characters. ecryptfs_decode_from_filename() will access kernel memory
> beyond that array, and ecryptfs_parse_tag_70_packet() will then
> decrypt those characters.

Ugh. I really don't like the patch.

Why isn't the patch just this one-liner:

  diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
  index 58609bde3b9f..7c50715c05d6 100644
  --- a/fs/ecryptfs/crypto.c
  +++ b/fs/ecryptfs/crypto.c
  @@ -1943,7 +1943,7 @@ static unsigned char *portable_filename_chars
= ("-.0123456789ABCD"

   /* We could either offset on every reverse map or just pad some 0x00's
    * at the front here */
  -static const unsigned char filename_rev_map[] = {
  +static const unsigned char filename_rev_map[256] = {
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 7 */
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 15 */
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 23 */

instead?

Making invalid characters over \x50 be somehow magically different
from invalid characters elsewhere seems just totally bogus. There are
lots of characters that aren't valid, and they have the
filename_rev_map[] value of 0 elsewhere.

So the simpler one-liner is not only simpler, but gives much saner
semantics, I think - now invalid character '\x05' gets exactly the
same result as invalid character '\xf5'.

Hmm?

                         Linus
