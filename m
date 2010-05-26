Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab0EZWSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:18:47 -0400
Received: from smtp-out.google.com ([74.125.121.35]:63147 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab0EZWSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:18:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=U6inEfPca6oDY5dwjUFDGFWvMhR+NQtPmcbD0DMdYHs/CjMlCqg1CoWHpOfRjTLzc
	Og8Rkdxn1PuuoN2bMoDfg==
MIME-Version: 1.0
In-Reply-To: <20100526231448.41c5be7f@lxorguk.ukuu.org.uk>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<1274482015-30899-3-git-send-email-arve@android.com>
	<1274863428.5882.4860.camel@twins>
	<201005262357.28933.rjw@sisk.pl>
	<20100526231448.41c5be7f@lxorguk.ukuu.org.uk>
Date: Wed, 26 May 2010 15:18:35 -0700
Message-ID: <AANLkTikqYwcJfCSJgBlXKyyDJFAVJmrZmyt38KOby97j@mail.gmail.com>
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend 
	blockers from user-space
From: Brian Swetland <swetland@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <peterz@infradead.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 3:14 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> This whole thing is related to the statistics part, which Arve says is
>> essential to him.  He wants to collect statistics for each suspend blocker
>> activated and deactivated so that he can tell who's causing problems by
>> blocking suspend too often.  The name also is a part of this.
>
> If he wants to collect stats about misbehaving code then presumably he
> needs reliable stats. Arbitary user set names are not reliable and
> judging by app vendor behaviour in the proprietary space with other such
> examples they will actively name their blockers in a manner specifically
> intended to hide the cause so as to 'reduce support costs'.
>
> Its a waste of memory (especially if I create a million of them with a
> long name for fun).

You are limited to one per open fd of the device, and a max name size
which could be further shrunk to something pretty small (32?) if
desired.  The device node interface came about after discussions last
year and concerns that userspace could create an unbounded number of
suspend blockers.

> It's all an economic system, proprietary app vendors are in it to make
> money, some will therefore game the system and the rest will be forced to
> follow to keep their playing field fair.

Untrusted (non-system) code can't directly access the device node from
userspace in the Android world -- so directly created suspend blockers
from userspace are only created by a couple system processes (3-4
typically).  Applications are sandboxed by UID and there is (much
more) per-application accounting in the userspace application manager
process (other resource consumption such as sensors, CPU, etc is
tracked here as well).

For suspend blockers created by drivers and by trusted userspace
processes, having a meaningful name significantly helps statistics
gathering.

Brian
