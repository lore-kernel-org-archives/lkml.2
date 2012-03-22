Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab2CVUiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:38:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62160 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758619Ab2CVUiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120322202445.GB6589@ZenIV.linux.org.uk>
References: <20120322183845.GA17264@phenom.dumpdata.com> <20120322200918.GZ6589@ZenIV.linux.org.uk>
 <20120322202445.GB6589@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Mar 2012 13:38:28 -0700
X-Google-Sender-Auth: HkG37sOWft9PUhvO1Ly9ZB_vp84
Message-ID: <CA+55aFyiNKdkkvK0FH1ibo1iJj1HF9RjLEw3VOEjVwc0eiX8Sw@mail.gmail.com>
Subject: Re: Regression introduced by bfcfaa77bdf0f775263e906015982a608df01c76
 (vfs: use 'unsigned long' accesses for dcache name comparison and hashing)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 1:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK, full_name_hash()/hash_name() definitely have a mismatch and it's on the
> names of length 8*n: trivial experiment shows that we have
> name hash_name full_name_hash

Good catch, guys.

Ugh. And I never noticed despite having run this code on my machines
for several weeks, because I don't think I have anything that uses the
"full_name_hash()" function. And it looked so obviously the same.

> Linus, which way do you prefer to shift it?  Should hash_name() change to
> match full_name_hash() or should it be the other way round?
>
> What happens is that you get multiplication by 9 and adding 0 in the former,
> after having added the last full word.  In the latter we add the last full
> word, see that there's nothing left and bugger off.

Yes. I think we should make things match "hash_name()", because that's
the one that is critical and we want to really generate good code for.

I think you can just move the "*=9" down in full_name_hash(), so that
we always "pre-multiply" the hash for the next round.  But I'll have
to double-check my logic.

                 Linus
