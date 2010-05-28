Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab0E1MOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:14:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35656 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755279Ab0E1MOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:14:38 -0400
Date: Fri, 28 May 2010 13:21:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528132138.2d802d77@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com>
	<20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
	<AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok lets try and produce something more concrete. The control groups may
be the wrong tool but we've got several such tools already


Kernel involved
----------------
acquire:		mark myself important (into cgroup important)
acquire(timeout)	ditto, plus app timer/timeout handler
release:		mark myself unimportant (into cgroup downtrodden) 

All user
--------
isHeld:			app implementation internal
setReferenceCounted:	app implementation internal


In the idle manager [Androids own probably]

	if (member of ignored cgroup && in user space)
		ignore for idle purposes


In the Android code managing this [Android specific bits of
probably userspace]
	mark downtrodden as ignored
	mark downtrodden as not ignored


[Total kernel changes

	Ability to mark/unmark a scheduler control group as outside of
	some parts of idle consideration. Generically useful and
	localised. Group latency will do most jobs fine (Zygo is correct
	it can't solve his backup case elegantly I think)

	Test in the idling logic to distinguish the case and only needed
	for a single Android specific power module. Generically useful
	and localised]

So I put my phone down

	The UI manager gets told the phone is 'down'
	Ten seconds later it is still down
	It marks the downtrodden group as 'ignored'

	The idle logic goes
		Nothing to run powersave
		Still nothing
		Ooh 0.3 seconds of nothing
		Drop into suspend state


If I push the button we get an IRQ
We come out of power save
The app gets poked
The app may be unimportant but the IRQ means we have a new timeout of
    some form to run down to idle
The app marks itself important
The app stays awake for 60 seconds rsyncing your email
The app marks itself unimportant
Time elapses
We return to suspend


If you are absolutely utterly paranoid about it you need the button
driver to mark the task it wakes back as important rather than rely on
time for response like everyone else. That specific bit is uggglly but
worst case its just a google private patch to a few drivers. I understand
why Android wants it. The narrower the gap between 'we are doing nothing,
sit in lowest CPU on state' and 'we are off' the better the battery life
and the more hittable the condition.

Apart from that optional paranoia case my kernel now contains some
trivial changes of generic value that have nothing to do with suspend
blocking. Android has suspend blocking by choosing to use the generic
features in its own specific way and we need almost no code writing ?

Alan
