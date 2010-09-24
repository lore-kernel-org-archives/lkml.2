Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab0IXQTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:19:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43306 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab0IXQTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:19:48 -0400
Message-ID: <4C9CCF67.3000106@zytor.com>
Date: Fri, 24 Sep 2010 09:18:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: simplify is32entry.S again
References: <4C9CB7170200007800018D0B@vpn.id2.novell.com>
In-Reply-To: <4C9CB7170200007800018D0B@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 05:35 AM, Jan Beulich wrote:
> Commits 36d001c70d8a0144ac1d038f6876c484849a74de and
> eefdca043e8391dcd719711716492063030b55ac fixed the same problem in two
> different, redundant of one another ways: Zero-extending the system
> call index from 32 to 64 bits and then doing comparison on the 64 bit
> register is just pointless.
> 
> Undo the second commit completely, as using REX prefixes where needed
> produces more efficient code than having an extra instruction in the
> stream (no matter how simple it is).
> 
> The first commit by itself also did quite a bit more than needed -
> comparison on the full 64-bit register is definitely unnecessary in
> all paths where the value is known to zero extended from 32 bits
> already (in one case this is even directly visible from the patch, as
> the zero extending instruction is the immediately preceding one). Undo
> those parts of the first commit too.

Yes, this optimizes the code slightly... it also removes any redundancy
in the protections which is part of why the bug could reappear in the
first place. Unless you have concrete numbers on system call entry
latency and that these longer instructions hurt, I *really don't* want that.

As Linus said, "the code was too subtle in the first place".

Furthermore, Roland was concerned about buggy ptrace users relying on
the zero-extension... if nothing else zero-extending in some paths and
not in others would open up for another instance of the same class of
problems (tested-is-not-what-is-executed).

So I'm going to NAK this patch unless provided with strong evidence that
the efficiency pays off.  Sorry.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

