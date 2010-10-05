Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab0JEQwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:52:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38120 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab0JEQwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:52:31 -0400
Date: Tue, 5 Oct 2010 17:51:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>,
        "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        phillip@lougher.demon.co.uk, hsweeten@visionengravers.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] initramfs: strcpy destination string overflow
Message-ID: <20101005165159.GQ19804@ZenIV.linux.org.uk>
References: <cover.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
 <b6cdf32448371a89fdab2f3875ac5b32365bf518.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
 <AANLkTinoCgO56O1kPNW3vjd9Nd1kY2SU34UH2RQa9qkE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinoCgO56O1kPNW3vjd9Nd1kY2SU34UH2RQa9qkE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 08:55:01AM -0700, Linus Torvalds wrote:

> I think this is wrong.
> 
> If the name is too long to fit in the hash table, we should not create
> a new hash entry at all, because we'd be returning the wrong
> (truncated) name when we find it next time.
> 
> So it would be much better to just do
> 
>    if (strlen(name) >= sizeof(q->name))
>       return NULL;
> 
> in find_link(), because as far as I can tell, the hard-linking is
> always just an optimization.
> 
> Comments? Peter?

Take a look at struct hash definition.  That sizeof is PATH_MAX and
do_header() will reject an entry with name longer than that.  IOW,
the whole thing is a non-issue; we can add
	if (strlen(name) >= PATH_MAX)
		BUG();
if we really care, but that's it.

As a side note, it looks like we need a fat warning about blind "improvements"
of that kind in CodingStyle; cargo-cult replacements like that can easily
hide real bugs... ;-/
