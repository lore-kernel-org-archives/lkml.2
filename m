Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab0LOJuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:50:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42369 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0LOJua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:50:30 -0500
Date: Wed, 15 Dec 2010 09:49:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: P??draig Brady <P@draigBrady.com>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, wharms@bfs.de,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>, kernel-janitors@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Message-ID: <20101215094953.GG19804@ZenIV.linux.org.uk>
References: <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
 <20101114092533.GB5323@albatros>
 <20101114180643.593d19ac.akpm@linux-foundation.org>
 <1289848341.2607.125.camel@edumazet-laptop>
 <20101123140111.GA3816@hack>
 <4CEBD37E.5060107@bfs.de>
 <203E1F2A-2D04-4B7F-8D1B-9DC24522CB5E@dilger.ca>
 <4CECECA2.6070301@draigBrady.com>
 <20101124110535.GD5139@cr0.nay.redhat.com>
 <4CECFB19.1090003@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CECFB19.1090003@draigBrady.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 11:46:33AM +0000, P??draig Brady wrote:

> Looks like gcc is following the standard exactly.
> 
> C90 - 6.5.7
> C99 - 6.7.8
> 
>   If there are fewer initializers in a brace-enclosed list than
>   there are elements or members of an aggregate ... the remainder
>   of the aggregate shall be initialized implicitly the same as
>   objects that have static storage duration.

Incorrect.  See 6.2.6.1 in C99; basically, padding bytes have unspecified
contents.  Implementation is allowed to leave them in any state (including
not bothering to copy them when doing struct assignments, etc.).  See
Appendix J (portability issues) as well.

The text you are quoting is about handling of missing initializers - it
essentially refers you back to the rules in 6.7.8p{9,10} (for arithmetical
types use zero, for pointers - null pointer, for arrays - apply recursively
to each array member, for structs - apply recursively for each named
member, for unions - apply recursively for the first named member).  That's
it - nothing in the standard says how to initialize padding.  Note that
these rules are _not_ guaranteed to be "fill everything with zero bits";
it often will be true, but it's implementation-dependent.  Implementation
may decide to fill padding with all-zeroes; it's not required to do so.

The bottom line: if you rely on that, you are relying on non-portable
details of compiler behaviour.  Moreover, the authors are not even
required to document what they are doing or to keep that behaviour
consistent.
