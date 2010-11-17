Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206Ab0KQEnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:43:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43681 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950Ab0KQEnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:43:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aC3jJLskuv4NFF9ENcjLRf8/9UP+QVLVwXkWTm8b/UCX3+W+gmaBpPZ9S1ZTHv9i3Z
         iR5yPpvN6RGxZHvzOc7cCHRkJjo7dCSqm3uNPqnKnVFi8jevYAqQGdpWaymOrFo9Nc5M
         WI5cvDv4O7fPrWdBDDB0OX/xuiNLqavizAD0s=
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cypher Wu <cypher.w@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTimA3mnPQHYWVb_fzONXMz40WGTaWpf83uZTsYQ2@mail.gmail.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	 <1289489007.17691.1310.camel@edumazet-laptop>
	 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	 <ZXmP8hjgLHA.4648@exchange1.tad.internal.tilera.com>
	 <4CDF1945.8090101@tilera.com>
	 <AANLkTind92uwcigzmDn8yn9a22exDy7zcreGQ5-6NLV-@mail.gmail.com>
	 <AANLkTinzRm_5WW5HwxzXqZZD4255GDpR4yzELqz66Dfn@mail.gmail.com>
	 <1289820672.2607.10.camel@edumazet-laptop>
	 <AANLkTimA3mnPQHYWVb_fzONXMz40WGTaWpf83uZTsYQ2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 05:43:37 +0100
Message-ID: <1289969017.2732.82.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 17 novembre 2010 à 09:30 +0800, Cypher Wu a écrit :
> O
> struct in_device::mr_ifc_timer. Every time when a process join/leave a
> MC group, igmp_ifc_event() -> igmp_ifc_start_timer() will start the
> timer on the core that the system call issued, and
> igmp_ifc_timer_expire() will be called on that core in the bottem halt
> of timer interrupt.
> If we call join/leave on mutlicores that timers will run on all these
> cores, but it seems only one or two will generate IGMP message, others
> will only lock the list and loop throught it with nothing generated.
> 
> 

Problem would not be timer being restarted on different cores (very
small impact), but scanning a list in igmpv3_send_cr() with many items
in it and expensive things, under timer handler (softirq), so adding
spikes of latency.

IGMP_Unsolicited_Report_Interval is 10 seconds, so we start timer in a 5
second average.

I am not sure there is a need to join/leave thousand of groups per
second anyway...



