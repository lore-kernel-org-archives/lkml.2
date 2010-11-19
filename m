Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab0KSItP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 03:49:15 -0500
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:25476 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751550Ab0KSItN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 03:49:13 -0500
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
Date: Fri, 19 Nov 2010 17:49:31 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
        linville@tuxdriver.com, randy.dunlap@oracle.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6> <1290010595.3777.0.camel@jlt3.sipsolutions.net> <AANLkTimoogSLAipNy=njGtHypqBQSk=usDmXut=KN9TM@mail.gmail.com>
In-Reply-To: <AANLkTimoogSLAipNy=njGtHypqBQSk=usDmXut=KN9TM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191749.31974.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu November 18 2010 08:11:18 Bob Copeland wrote:
> On Wed, Nov 17, 2010 at 11:16 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2010-11-17 at 17:28 +0900, Bruno Randolf wrote:
> >> I understand that this could be more efficient, but if it matters or not
> >> - honestly, I don't know. Can a more knowledgeable person than me
> >> comment on this?
> > 
> > Yes, it does matter -- think of an embedded MIPS board running at 500MHz
> > and trying to push 11n speeds.

OK, I have done tests with a 266MHz x86 board, pushing 30Mbps UDP thru it. It 
can handle maximum around 18Mbps thuput in both cases, with and without the 
average. And that is using the ewma function two times (ath5k beacons and 
signal average). Here are the results of iperf -u -c IP -b 30M -t 120 (2min of 
30Mbps UDP):

With average:

0.0-120.4 sec    269 MBytes  18.7 Mbits/sec  0.370 ms 114323/306094 (37%)
0.0-120.4 sec    263 MBytes  18.3 Mbits/sec  0.336 ms 118668/306110 (39%)
0.0-120.4 sec    265 MBytes  18.5 Mbits/sec  0.229 ms 117036/306120 (38%)

Without:

0.0-120.4 sec    267 MBytes  18.6 Mbits/sec  0.385 ms 115457/306123 (38%)
0.0-120.4 sec    267 MBytes  18.6 Mbits/sec  0.374 ms 115868/306063 (38%)
0.0-120.4 sec    261 MBytes  18.2 Mbits/sec  0.566 ms 119603/306112 (39%)

So I conclude that compared to all the other things we do when we receive a 
packet having one division more or less does not have a huge performance 
impact.

> I assume the number of samples (weight) is the more
> important tunable.  One option is you can require factor
> to be a power of two that is much larger than weight,
> then at least you can store factor/weight precomputed
> and multiply by it instead of doing a divide in ewma_add.
> Then ewma_get can also just be a shift as well.

That's a good idea! I will try to improve the code.

bruno
