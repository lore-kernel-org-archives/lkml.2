Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1HaQPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:15:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab1HaQPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:15:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFD: x32 ABI system call numbers
Date: Wed, 31 Aug 2011 18:14:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
References: <4E582577.2060805@zytor.com> <201108301409.27527.arnd@arndb.de> <4E5D1153.5030908@zytor.com>
In-Reply-To: <4E5D1153.5030908@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311814.54906.arnd@arndb.de>
X-Provags-ID: V02:K0:+wZ3fOC3gazPhXo/v6RIh2OgYgJYVnTa6IAkb/PYMRa
 9SAO8Qy8X3kWiL1ySamIKA1KlYAMxAH/59P4a0nnftLW5DqzZ+
 LX5vIXGJ4v0dnSVQCjAYk1CypwdFrvAkWBovktduQaf0DjYHM6
 oEr0ZjUnOkJufjS8WRXAXxTPIT257y62oDQj3GWBQMIErCfzQ7
 ouz1/zGi0CEDpFxbONTjpIscNmRxW34hK3Igh3EQPv7W8XCULK
 /iFy9mzrZ2THzpuKruTJm5FAFYfe2nTU0Vh5M9nebrXEkhFM2S
 F6WMBrj4Ozxfkxsd1b3Cfa4FVk+VFE4IQkmM35ggvzl10nNrfr
 fEgsbSsI/pKO1vUG625U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, H. Peter Anvin wrote:
> On 08/30/2011 05:09 AM, Arnd Bergmann wrote:
> > 
> > I'm wondering about the time_t changes: given that we are still adding
> > new 32 bit architectures, should we change the asm-generic API as well
> > to use 64 bit time_t by default (with fallbacks for the existing ones)?
> > 
> > If you are adding support for these in x32 already, we could use the
> > same code for regular 32 bit architectures.
> > 
> 
> It seems absolutely boggling insane that we're introducing new
> architectures with no legacy whatsoever and use 32-bit time_t on those.

Ok, but I think we do need to consider the potential problems in this.
I would expect a number of things to break if we just define it to
'long long' on new architectures, including:

* pre-c99 C compilers or programs that rely on --std=c89
* padding in struct timespec when you have a long long tv_sec and
  32-bit long tv_nsec. This might cause kernel stack data leakage
  in some kernel interfaces when they don't clear the padding.
* random broken applications assuming that timespec/timeval has
  two 'long' members, instead of using the proper header files.

Obviously these are all fixable for any new ABI, but will cause
some annoyance.

I've added a few people to Cc who are in various stages of the
process to finalize their upstream kernel ports. It's clearly
the right decision to have time_t 64-bit eventually, the question
is how much work is everyone willing to spend in the short run,
and who is going to test it. In particular, openrisc has just
been merged, so we should not be changing it any more unless
there is a serious problem, but if there is not much legacy user
space with the current ABI yet, it may still be worth switching
over.

	Arnd
