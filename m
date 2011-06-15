Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1FOK7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 06:59:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:58885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1FOK7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 06:59:36 -0400
Subject: Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, ak@linux.intel.com,
        shaohua.li@intel.com, alex.shi@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1308134200.15315.32.camel@twins>
References: <1308097798.17300.142.camel@schen9-DESK>
	 <1308134200.15315.32.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Jun 2011 12:58:15 +0200
Message-ID: <1308135495.15315.38.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 12:36 +0200, Peter Zijlstra wrote:
> On Tue, 2011-06-14 at 17:29 -0700, Tim Chen wrote:
> > MOSBENCH test suite.
> 
> Argh, I'm trying to get this thing to run, but its all snake poo..
> 
> /me takes up a heavy club and goes snake hunting, should make a pretty
> hat or something.

Sweet, I've got meself a snake-skin hat!

The first thing that stood out when running it was:

31694 root      20   0 26660 1460 1212 S 17.5  0.0   0:01.97 exim 
    7 root      -2  19     0    0    0 S 12.7  0.0   0:06.14 rcuc0 
   24 root      -2  19     0    0    0 S 11.7  0.0   0:04.15 rcuc3 
   34 root      -2  19     0    0    0 S 11.7  0.0   0:04.10 rcuc5 
   39 root      -2  19     0    0    0 S 11.7  0.0   0:06.38 rcuc6 
   44 root      -2  19     0    0    0 S 11.7  0.0   0:04.53 rcuc7 
   49 root      -2  19     0    0    0 S 11.7  0.0   0:04.11 rcuc8 
   79 root      -2  19     0    0    0 S 11.7  0.0   0:03.91 rcuc14 
   89 root      -2  19     0    0    0 S 11.7  0.0   0:03.90 rcuc16 
  110 root      -2  19     0    0    0 S 11.7  0.0   0:03.90 rcuc20 
  120 root      -2  19     0    0    0 S 11.7  0.0   0:03.82 rcuc22 
   13 root      -2  19     0    0    0 S 10.7  0.0   0:04.37 rcuc1 
   19 root      -2  19     0    0    0 S 10.7  0.0   0:04.19 rcuc2 
   29 root      -2  19     0    0    0 S 10.7  0.0   0:04.12 rcuc4 
   54 root      -2  19     0    0    0 S 10.7  0.0   0:04.11 rcuc9 
   59 root      -2  19     0    0    0 S 10.7  0.0   0:04.40 rcuc10 
   64 root      -2  19     0    0    0 R 10.7  0.0   0:04.17 rcuc11 
   69 root      -2  19     0    0    0 R 10.7  0.0   0:04.23 rcuc12 
   84 root      -2  19     0    0    0 S 10.7  0.0   0:03.90 rcuc15 
   95 root      -2  19     0    0    0 S 10.7  0.0   0:03.99 rcuc17 
  100 root      -2  19     0    0    0 S 10.7  0.0   0:03.88 rcuc18 
  105 root      -2  19     0    0    0 S 10.7  0.0   0:04.14 rcuc19 
  125 root      -2  19     0    0    0 S 10.7  0.0   0:03.79 rcuc23 
   74 root      -2  19     0    0    0 S  9.7  0.0   0:04.33 rcuc13 
  115 root      -2  19     0    0    0 R  9.7  0.0   0:03.82 rcuc21 

Which is an impressive amount of RCU usage..
