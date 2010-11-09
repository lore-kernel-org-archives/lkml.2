Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0KIQsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:48:22 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:25569 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752463Ab0KIQsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:48:18 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: P6reAUgVM1mV6rQ1cfqpjmpfVLqXuoTzWmEhbNDi9vR63WU
 kdOoz8iL0NEgBxLlsMKXolSzJjSuvnYoYTEADxdqTCJYhzEvECEPM.eQtp8C
 nWXY4KzTwM5GClFfMadOtb0jQssVXuCiEn2f6MJEhRQFlauD8sWLV1Nd5GVg
 xoRBj1RwjpDgS6XpyUkZUlh1SOVKYeVoZtRADokf2Ts91WGgXjDZFVnphbMl
 Y_tu08Y8jLWBK5TCyOR6f8K14DiKA
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 9 Nov 2010 10:48:13 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: page allocator: Adjust the per-cpu counter
 threshold when memory is low
In-Reply-To: <20101029124002.356bd592.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1011091006280.9898@router.home>
References: <1288278816-32667-1-git-send-email-mel@csn.ul.ie> <1288278816-32667-2-git-send-email-mel@csn.ul.ie> <20101028150433.fe4f2d77.akpm@linux-foundation.org> <20101029101210.GG4896@csn.ul.ie> <20101029124002.356bd592.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010, Andrew Morton wrote:

> > To match the existing maximum which I assume is due to the deltas being
> > stored in a s8.
>
> hm, OK.  So (CHAR_MAX-2) would be a tad clearer, only there's no
> CHAR_MAX and "2" remains mysterious ;)

inc/dec_zone_page_state first increments (allows compiler to generate a
RMV instruction, hmmm... there we could use this cpu....) and then checks
if we are beyond the threshold. So the maximum value has to be below
CHAR_MAX. 125 is the next value that looks somewhat sane as a limit. We
could use CHAR_MAX if we change the comparison logic for the threshhold.

> I do go on about code comments a lot lately.  Eric D's kernel just
> crashed because we didn't adequately comment first_zones_zonelist()
> so I'm feeling all vindicated!

We should not have done the change to add the nodemask to
first_zones_zonelist but instead added a new function. Now the function
has two different ways of behaving.

> I don't really buy that.  The cache footprint will be increased by a
> max of one cacheline (for zone->stat_threshold) and the cache footprint
> will be actually reduced in the much larger percpu area (depending on
> alignment and padding and stuff).

It will increase by one cacheline per zone in use. Large systems have lots
of zones which increases the effect.

The vmstat functions are often used as primitives in various critical code
paths. The cache footprint needs to be kept as low as possible.
