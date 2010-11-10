Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab0KJO4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:56:43 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:33149 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab0KJO4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:56:42 -0500
Date: Wed, 10 Nov 2010 09:56:14 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: more possible aesthetic cleanup -- *lots* of power of 2 stuff
Message-ID: <alpine.DEB.2.00.1011100956060.5730@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  following up on jesper's yeoman efforts to tidy up a lot of the
*malloc calls, once upon a time, i whined enough to get the
<linux/log2.h> header file added so that a lot of painful bit tests
for power of 2 could be abbreviated.

  the most useful test seems to have been:

static inline __attribute__((const))
bool is_power_of_2(unsigned long n)
{
        return (n != 0 && ((n & (n - 1)) == 0));
}

i wrote a short script that looks for various forms of the old power
of 2 tests:

===== start =====
#!/bin/sh

DIR=${1-*}

echo -e "     x & (x - 1):\n"
grep -Ern "([^\(\)]+) ?\& ?\(\1 ?- ?1\)" ${DIR}
echo -e "     x & ((x) - 1):\n"
grep -Ern "([^\(\)]+) ?\& ?\(\(\1\) ?- ?1\)" ${DIR}
echo -e "     (x) & (x - 1):\n"
grep -Ern "\(([^\(\)]+)\) ?\& ?\(\1 ?- ?1\)" ${DIR}
echo -e "     (x) & ((x) - 1):\n"
grep -Ern "\(([^\(\)]+)\) ?\& ?\(\(\1\) ?- ?1\)" ${DIR}
===== end =====

and, unsurprisingly, while i once submitted a fair bit of that
cleanup, there's lots left -- just run the script at the top of the
source tree (give an optional subdir to restrict the search).  there
are even a few places where code is still defining that test for
itself:

drivers/net/bna/bna.h:50:#define BNA_POWER_OF_2(x) (((x) & ((x) - 1)) == 0)
drivers/net/wireless/rt2x00/rt2x00reg.h:187:#define is_power_of_two(x)	( !((x) & ((x)-1)) )

  if anyone wants to run the script on their favourite bit of the
tree, have at it.

rday

p.s.  perhaps tests like this could be added to the checkpatch.pl
script.  just a thought.

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
