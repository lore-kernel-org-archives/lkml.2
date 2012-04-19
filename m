Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab2DSSZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:25:40 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58582 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab2DSSZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:25:39 -0400
MIME-Version: 1.0
In-Reply-To: <4F90527B.7020005@zytor.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <20120419092255.GA29542@aftab> <20120419092630.GD29542@aftab>
 <4F904541.2030200@zytor.com> <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com>
 <20120419173802.GI3221@aftab.osrc.amd.com> <4F90527B.7020005@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Apr 2012 11:25:17 -0700
X-Google-Sender-Auth: vIQqKJHFC9rQtGAMiu_vCCJqIrg
Message-ID: <CA+55aFxhY1Ug5esj==Sm=o1Epg+NFnvFs74syqRxbYDbPQJEFA@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 10:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I would argue that the O(1) hash makes things simpler as there is no
> need to deal with collisions at all.

Most of the O(1) hashes I have seen more than made up for the trivial
complexity of a few linear lookups by making the hash function way
more complicated.

A linear probe with a step of one really is pretty simple. Sure, you
might want to make the initial hash "good enough" to not often hit the
probing code, but doing a few linear probes is cheap.

In contrast, the perfect linear hashes do crazy things like having
table lookups *JUST TO COMPUTE THE HASH*.

Which is f*cking stupid, really. They'll miss in the cache just at
hash compute time, never mind at hash lookup. The table-driven
versions look beautiful in microbenchmarks that have the tables in the
L1 cache, but for something like the exception handling, I can
guarantee that *nothing* is in L1, and probably not even L2.

So what you want is:
 - no table lookups for hashing
 - simple code (ie a normal "a multiply and a shift/mask or two") to
keep the I$ footprint down too
 - you *will* take a cache miss on the actual hash table lookup, that
cannot be avoided, but linear probing at least hopefully keeps it to
that single cache miss even if you have to do a probe or two.

Remember: this is very much a "cold-cache behavior matters" case. We
would never ever call this in a loop, at most we have loads that get a
fair amount of exceptions (but will go through the exception code, so
the L1 is probably blown even then).

                         Linus
