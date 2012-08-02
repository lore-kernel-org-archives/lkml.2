Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2HBSI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 14:08:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38792 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2HBSI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 14:08:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120802175904.GB6251@jtriplet-mobl1>
References: <20120801202432.GE15477@google.com> <5019B0B4.1090102@gmail.com>
 <20120801224556.GF15477@google.com> <501A4FC1.8040907@gmail.com>
 <20120802103244.GA23318@leaf> <501A633B.3010509@gmail.com>
 <87txwl1dsq.fsf@xmission.com> <501AAC26.6030703@gmail.com>
 <87fw851c3d.fsf@xmission.com> <CA+55aFw_dwO5ZOuaz9eDxgnTZFDGVZKSLUTm5Fn99faALxxJRQ@mail.gmail.com>
 <20120802175904.GB6251@jtriplet-mobl1>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Aug 2012 11:08:06 -0700
X-Google-Sender-Auth: q2YHhwWWO0qptgL2EkJBwrejGTI
Message-ID: <CA+55aFwqC9hF++S-VPHJBFRrqfyNvsvqwzP=Vtzkv8qSYVqLxA@mail.gmail.com>
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <levinsasha928@gmail.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 10:59 AM, Josh Triplett <josh@joshtriplett.org> wrote:
>
> You shouldn't have any extra indirection for the base, if it lives
> immediately after the size.

Umm. You *always* have the extra indirection. Because you have that allocation.

So you have to follow the pointer to get the base/size, because they
aren't compile/link-time constants.

The cache misses were noticeable in macro-benchmarks, and in
micro-benchmarks the smaller L1 hash table means that things fit much
better in the L2.

It really improved performance. Seriously. Even things like "find /"
that had a lot of L1 misses ended up faster, because "find" is
apparently pretty moronic and does some things over and over. For
stuff that fit in the L1, it qas quite noticeable.

Of course, one reason for the speedup for the dcache was that I also
made the L1 only contain the simple cases (ie no "d_compare" thing
etc), so it speeded up dcache lookups in other ways too. But according
to the profiles, it really looked like better cache behavior was one
of the bigger things.

Trust me: every problem in computer science may be solved by an
indirection, but those indirections are *expensive*. Pointer chasing
is just about the most expensive thing you can do on modern CPU's.

               Linus
