Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab1HZOmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:42:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:54479 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1HZOmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:42:50 -0400
MIME-Version: 1.0
Message-ID: <16da6dde-3c17-40bf-8d84-82167b96c1ae@default>
Date: Fri, 26 Aug 2011 07:42:32 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nebojsa Trpkovic <trx.lists@gmail.com>, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: RE: cleancache can lead to serious performance degradation
References: <4E4C395E.20000@gmail.com> <20110825041212.GA5014@dumpdata.com>
 <3aef71a8-d390-4a91-bfef-561c89edc040@default
 4E579E9F.9090906@linux.vnet.ibm.com>
In-Reply-To: <4E579E9F.9090906@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A020209.4E57B0E5.00EA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> 
> On 08/25/2011 11:56 AM, Dan Magenheimer wrote:
> 
> > Third, zcache is relatively new and can certainly benefit from
> > the input of other developers.  The lzo1x compression in the kernel
> > is fairly slow; Seth Jennings (cc'ed) is looking into alternate
> > compression technologies.  Perhaps there is a better compression
> > choice more suitable for older-slower processors, probably with a
> > poorer compression ratio.  Further, zcache currently does compression
> > and decompression with interrupts disabled, which may be a
> > significant factor in the slowdowns you've observed.  This should
> > be fixable.
> 
> This was something I've meaning to ask about.  Why are compression
> and decompression done with interrupts disabled?

The "hb->lock" is held during most tmem operations.  If a tmem
operation (or the callback to zcache) is interrupted and the
current cpu is scheduled to run another task, and the new task
calls into tmem, deadlock could occur.

In some cases, I think disabling preemption or bottom-halves instead
of disabling interrupts may be sufficient, but I ran into problems
when I tried that and never got back to it.  Note though that
interrupts are already disabled in some cases when cleancache is
called, so that would only solve part of the problem.

> What would need to change so that we don't have to disable interrupts?

Not easy, but not terribly hard I think:

1) On put, copy the page into tmem uncompressed, and keep a list
of not-yet-compressed pages.  (The copy would still need to be
done with interrupts disabled but copying a page is presumable
one-to-three orders of magnitude faster than compress/decompress.)
2) An independent lower-priority thread would be launched periodically
to compress one or more pages on the uncompressed list and
atomically replace the uncompressed page with the compressed version,
and change all pointers.  Then the uncompressed page could be freed.
There are likely some ugly race conditions in here.
3) On get, ensure not-yet-compressed pages are properly handled.

Dan

P.S. On vacation today, no more email until next week.

