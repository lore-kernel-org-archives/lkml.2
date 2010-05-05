Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346Ab0EEBLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 21:11:10 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59440 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760167Ab0EEBLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 21:11:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=gyiTY+b/6Q4Jljyv/JbY53sU0f+u+QvQj8f6ATUfsQfEZvpwx+1qAieIwnK0z1crH
	k43pH9ypxNurRLCnluYDg==
MIME-Version: 1.0
In-Reply-To: <201005050222.31038.rjw@sisk.pl>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <201005042223.41370.rjw@sisk.pl>
	 <20100504235644.GA5231@opensource.wolfsonmicro.com>
	 <201005050222.31038.rjw@sisk.pl>
Date: Tue, 4 May 2010 18:11:00 -0700
Message-ID: <v2ta55d774e1005041811se31aa4d1i617b829ae010535@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 5:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> In other words, the issue is that we run into situations where we need
>> an element of suspend control to go along with the opportunistic suspend
>> in order to allow some elements to be kept running - since suspend
>> blocking is taken suspend suppression seems like a reasonable term.
>
> Suspend really is a sledgehammer thing.  Either you suspend the whole system
> or you don't suspend at all.  You can prevent opportunistic suspend from
> happening using suspend blockers (that's what they are for), but that's pretty
> much everything you can do about it.  If you want power savings while some
> parts of the system are active, use runtime PM for that.
>
> What I'd use opportunistic suspend for is not the saving of energy when there's
> a call in progress, because in that case some parts of the system need to be
> active, but to save energy when the device is completely idle, ie. the user
> interface is not used, music is not played "in the background" etc. (my phone
> is in such a state 90% of the time at least).

We actually do use opportunistic suspend for cases like this on
Android today.  It mostly comes down to a question of latency for
return from full suspend.  For example:

Some MSM7201 based devices typically resume from power collapse in
3-5ms, but absolute worst case (because the L1 radio services are
higher priority than the wake-the-apps-cpu services) is ~90ms.  On
these devices we hold a suspend_blocker while playing audio.  Before
discovery of this we went into full suspend while playing audio which
worked fine, but in certain network conditions we would drop buffers
if we could not wake fast enough.

So, it's somewhat system dependent, but it can be very helpful in a
lot of cases.

Brian
