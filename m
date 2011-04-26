Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1DZSjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:39:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826Ab1DZSjR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:39:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110426110300.6da0b684@mschwide.boeblingen.de.ibm.com>
References: <20110426110300.6da0b684@mschwide.boeblingen.de.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Apr 2011 11:38:22 -0700
Message-ID: <BANLkTik_SMi17rgLVss9esoez9OeHEhN0w@mail.gmail.com>
Subject: Re: [GIT PULL] s390 patches for 2.6.39-rc4
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll pull this, but:

On Tue, Apr 26, 2011 at 2:03 AM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
>
> Jan Glauber (3):
>      [S390] prng: prevent access beyond end of stack

I don't think that's _still_ correct.

Just looking at the diff, it looks broken:

>        /* Add the entropy */
>        while (nbytes >= 8) {
> -               *((__u64 *)parm_block) ^= *((__u64 *)buf+i*8);
> +               *((__u64 *)parm_block) ^= *((__u64 *)buf+i);
>                prng_add_entropy();
>                i += 8;
>                nbytes -= 8;

The "i += 8" implies that "i" is a byte offset.

But "(__u64 *)buf+i" will parse as "((__u64 *)buf) + i" and thus still
do another multiply-by-eight.

So the diff fixes one "off by a factor of 8", but not another, if I
read it right.

So the parenthesis should be moved around to something like "*(__u64
*) (buf+i)", I think.

                     Linus
