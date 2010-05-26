Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702Ab0EZXAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:00:18 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:43527 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab0EZXAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:00:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100527000004.2da62052@lxorguk.ukuu.org.uk>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<1274482015-30899-3-git-send-email-arve@android.com>
	<1274863428.5882.4860.camel@twins>
	<201005262357.28933.rjw@sisk.pl>
	<20100526231448.41c5be7f@lxorguk.ukuu.org.uk>
	<AANLkTikqYwcJfCSJgBlXKyyDJFAVJmrZmyt38KOby97j@mail.gmail.com>
	<20100527000004.2da62052@lxorguk.ukuu.org.uk>
Date: Wed, 26 May 2010 16:00:14 -0700
Message-ID: <AANLkTilz8z2rWV2gj48FLnIG9UIYA2W-pY_WiTmj6LH1@mail.gmail.com>
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend 
	blockers from user-space
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <peterz@infradead.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 4:00 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> desired.  The device node interface came about after discussions last
>> year and concerns that userspace could create an unbounded number of
>> suspend blockers.
>
> Surely you only need one block per task (or better yet one expression of

No, many suspend blockers protect data, not tasks. We block suspend
when there are unprocessed input events in the kernel queue.
User-space then blocks suspend before reading those events, and it
blocks suspend using a different suspend blocker when its queue of
processed events become not-empty.

> latency per task). If not can you explain why a setup which has a per
> task expression of latency needs (and a 'hard limit' set which you can't
> then bump back down except as root) isn't enough ?
>

> I'd really like this lot to also fix the hard real time and power
> management problem we have today and to try an fix the "suspend is
> special and different" mentality in the kernel, which is getting less and
> less true on a variety of chips.
>
>> > It's all an economic system, proprietary app vendors are in it to make
>> > money, some will therefore game the system and the rest will be forced to
>> > follow to keep their playing field fair.
>>
>> Untrusted (non-system) code can't directly access the device node from
>> userspace in the Android world -- so directly created suspend blockers
>
> Great - but the world is not Android and even if they can't access it
> directly but get passed a handle they can play.
>
>> For suspend blockers created by drivers and by trusted userspace
>> processes, having a meaningful name significantly helps statistics
>> gathering.
>
> By drivers I agree but in the driver case the cost is minimal because
> there should not be many and it is bounded clearly. Again I really think
> 'suspend blocking' is the wrong expression.
>
> A driver needs to express
>
> 'Don't go below this latency'
>
> and
>
> 'Don't go below this state'
>
> This is more generic and helps our power management do the right thing on
> all boxes. For example a serial port can meaningfully say 'I want X
> latency worst case' based upon the fact the fifo is 64 bytes and the user
> space just asked for 115,200 baud.
>
> The don't go below for states out of which the device must wake but
> cannot. Eg if your device is being told by user space to set wake on lan
> and can only wake on lan from a higher state than 'off' it needs to say
> so.
>
> Alan
>



-- 
Arve Hjønnevåg
