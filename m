Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1KVNYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:24:53 -0500
Received: from dns1.mips.com ([12.201.5.69]:52644 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1KVNYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:24:52 -0500
From: "Zhu, DengCheng" <dczhu@mips.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Barzilay, Eyal" <eyal@mips.com>, "Fortuna, Zenon" <zenon@mips.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 5/5] perf: Enable applicable siblings when group
 leader is enable-on-exec
Thread-Topic: [PATCH v2 5/5] perf: Enable applicable siblings when group
 leader is enable-on-exec
Thread-Index: AQHMqMcPcUwfPrOJr0SdF29sueMmtJW5Pg2A//+cb6w=
Date: Tue, 22 Nov 2011 13:24:19 +0000
Message-ID: <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA82C@exchdb03.mips.com>
References: <1321932601-21128-1-git-send-email-dczhu@mips.com>,<1321959115.5148.22.camel@twins>
In-Reply-To: <1321959115.5148.22.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.36.79]
x-ems-proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
x-ems-stamp: EnuZ2AWUCv9BrsmJZ7WpmQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ________________________________________
> From: Peter Zijlstra [a.p.zijlstra@chello.nl]
> Sent: Tuesday, November 22, 2011 6:51 PM
> To: Zhu, DengCheng
> Cc: Barzilay, Eyal; Fortuna, Zenon; Paul Mackerras; Ingo Molnar; Arnaldo Carvalho de Melo; ralf@linux-mips.org; LKML
> Subject: Re: [PATCH v2 5/5] perf: Enable applicable siblings when group leader is enable-on-exec
>
> On Tue, 2011-11-22 at 11:30 +0800, Deng-Cheng Zhu wrote:
>> Currently, when grouped events are created disabled and enable-on-exec, the
>> siblings won't be enabled on exec in fact. The problem looks like this:
>
> Arguably that's a daft thing to do, since if the leader is disabled the
> group won't get scheduled anyway. But I guess we should at least try to
> deal with it when people do do it.

Well, by "grouped events" I mean "all of the grouped events", not only the
group leader. In fact the leader (and only the leader) will be enabled by
going through ctx->flexible_groups in perf_event_enable_on_exec().

>
> Seems perf-stat is a bit daft this way.
>
>> This patch fixes it.
>
> I guess it does, but its not pretty, event_enable_on_exec() already
> calls __perf_event_mark_enable(), now this recursion is limited because
> siblings can't have a sibling list of their own, but still.

I did it like this just by reading the code comment of
__perf_event_mark_enabled(): "Enabling the leader of a group effectively
enables all the group members that aren't explicitly disabled ... Note:
this works for group members as well as group leaders since the non-leader
members' sibling_lists will be empty."

So I suppose dealing with siblings' state in this traversal is the right
thing to do and introduces minimal code turmoil, although the latter is by
no means critical.

> The below is a somewhat larger patch that avoids the recursion (and does
> a small cleanup by eradicating all those useless ctx arguments). Quick
> testing seems to indicate it works, but please confirm.

I have no objection of deleting the redundant ctx arguments, but that's
another topic.


Deng-Cheng
