Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab0KQBas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:30:48 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44728 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab0KQBaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:30:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Og/CdDvxmV2WMtPPh9VcAFRmlI/ZQkXvM+sXrngwmSc9Mx1XtOOHIlN15md3bmGP4v
         Zvlwsg6kLDixPrgHgMbKD8u87+xPBo78iRejvw9cu+f9W/QRd3lyeByhhXXhXFg67R3s
         cTf217icH+8UAh4fEpoA7UoFAHErcRHqhW1Eo=
MIME-Version: 1.0
In-Reply-To: <1289820672.2607.10.camel@edumazet-laptop>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	<1289489007.17691.1310.camel@edumazet-laptop>
	<AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	<ZXmP8hjgLHA.4648@exchange1.tad.internal.tilera.com>
	<4CDF1945.8090101@tilera.com>
	<AANLkTind92uwcigzmDn8yn9a22exDy7zcreGQ5-6NLV-@mail.gmail.com>
	<AANLkTinzRm_5WW5HwxzXqZZD4255GDpR4yzELqz66Dfn@mail.gmail.com>
	<1289820672.2607.10.camel@edumazet-laptop>
Date: Wed, 17 Nov 2010 09:30:44 +0800
Message-ID: <AANLkTimA3mnPQHYWVb_fzONXMz40WGTaWpf83uZTsYQ2@mail.gmail.com>
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Cypher Wu <cypher.w@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 7:31 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le lundi 15 novembre 2010 à 19:18 +0800, Cypher Wu a écrit :
>> In that post I want to confirm another thing: if we join/leave on
>> different cores that every call will start the timer for IGMP message
>> using the same in_dev->mc_list, could that be optimized?
>>
>
> Which timer exactly ? Is it a real scalability problem ?
>
> I believe RTNL would be the blocking point actually...
>
>
>
>

struct in_device::mr_ifc_timer. Every time when a process join/leave a
MC group, igmp_ifc_event() -> igmp_ifc_start_timer() will start the
timer on the core that the system call issued, and
igmp_ifc_timer_expire() will be called on that core in the bottem halt
of timer interrupt.
If we call join/leave on mutlicores that timers will run on all these
cores, but it seems only one or two will generate IGMP message, others
will only lock the list and loop throught it with nothing generated.


-- 
Cyberman Wu
http://www.meganovo.com
