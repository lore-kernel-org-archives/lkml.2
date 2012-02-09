Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab2BIQ66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:58:58 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49387 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2BIQ65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:58:57 -0500
MIME-Version: 1.0
In-Reply-To: <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20120209154819.32070.93358.stgit@warthog.procyon.org.uk> <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Feb 2012 08:58:37 -0800
X-Google-Sender-Auth: 7wL-nmlnNSkHn63FPwUMuLutVpQ
Message-ID: <CA+55aFxHdFa4otDWJg4f+8sKEP3MBZqKBQCnH0Q8LXYtpdt1EA@mail.gmail.com>
Subject: Re: [PATCH] Reduce the number of expensive division instructions done
 by _parse_integer()
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Howells <dhowells@redhat.com>, adobriyan@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 8:28 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> You could avoid the divide and have cleaner code I think.
>
>        unsigned long long next = *res * base + val;
>
>        if (next < *res)
>                overflow = 1;
>        *res = next;

No. That pattern only works for a single addition.

For multiplication, you can overflow *and* still be bigger than the
starting value.

You either need to do the multiplication in a wider type (which would
be the natural way to do it on many 64-bit architectures, since they
often support 64x64->128 bit multiplies, and then doing a carry-add is
trivial), or you need to check the value before the multiplication. Or
you need to have a multiply that gives you overflow information, which
most don't.

So David's patch looks ok, although if this really is
performance-critical (and I could imagine some crazy /proc or /sys
access loads where the divide really does show up very clearly) I do
think it could be even done more efficiently. But probably only if we
start doing some arch-specific stuff.

                  Linus
