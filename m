Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1HZUlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:41:12 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:46510 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754300Ab1HZUlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:41:10 -0400
Date: Fri, 26 Aug 2011 16:40:53 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: convert k{un}map_atomic(p, KM_type) to
 k{un}map_atomic(p)
Message-ID: <20110826204053.GA3408@elliptictech.com>
References: <1314346676.6486.25.camel@minggr.sh.intel.com>
 <1314349096.26922.21.camel@twins>
 <20110826124239.fc503491.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110826124239.fc503491.akpm@linux-foundation.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-26 12:42 -0700, Andrew Morton wrote:
> On Fri, 26 Aug 2011 10:58:16 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2011-08-26 at 16:17 +0800, Lin Ming wrote:
> > > 
> > > The KM_type parameter for kmap_atomic/kunmap_atomic is not used
> > > anymore since commit 3e4d3af(mm: stack based kmap_atomic()).
[...]
> > yet-another-massive patch.. (you're the third or fourth to do so) if
> > Andrew wants to take this one I won't mind, however previously he
> > didn't want flag day patches..
> 
> I'm OK with cleaning all these up, but I suggest that we leave the
> back-compatibility macros in place for a while, to make sure that
> various stragglers get converted.  Extra marks will be awarded for
> working out how to make unconverted code generate a compile warning ;)

It's possible to (ab)use the C preprocessor to accomplish this sort of
thing.  For instance, consider the following:

  #include <stdio.h>

  int foo(int x)
  {
     return x;
  }

  /* Deprecated; call foo instead. */
  static inline int __attribute__((deprecated)) foo_unconverted(int x, int unused)
  {
     return foo(x);
  }

  #define PASTE(a, b) a ## b
  #define PASTE2(a, b) PASTE(a, b)
  
  #define NARG_(_9, _8, _7, _6, _5, _4, _3, _2, _1, n, ...) n
  #define NARG(...) NARG_(__VA_ARGS__, 9, 8, 7, 6, 5, 4, 3, 2, 1, :)

  #define foo1(...) foo(__VA_ARGS__)
  #define foo2(...) foo_unconverted(__VA_ARGS__)
  #define foo(...) PASTE2(foo, NARG(__VA_ARGS__)(__VA_ARGS__))

  int main(void)
  {
    printf("%d\n", foo(42));
    printf("%d\n", foo(54, 42));
    return 0;
  }

The preprocessor will select between "foo" and "foo_unconverted"
depending on the number of arguments passed; and gcc will emit a warning
for the latter case:

  % gcc test.c
  test.c: In function ‘main’:
  test.c:27: warning: ‘foo_unconverted’ is deprecated (declared at test.c:9)

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
