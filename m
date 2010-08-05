Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502Ab0HEPPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:15:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8179 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab0HEPPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:15:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=NsDt7wR3l40nOEGmfF2oeARZQFDcLRVeSIdVasecmdlFcjnYpVj8M9d+D5dIP9ZLm
	DdCygl0OYI8TG0d29vE7Q==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008050724110.25170@asgard.lang.hm>
References: <20100803183447.0275c134@infradead.org>
	<20100804163216.GB24163@linux.vnet.ibm.com>
	<20100804163509.GA31523@srcf.ucam.org>
	<alpine.DEB.2.00.1008041124580.6545@asgard.lang.hm>
	<20100804185520.GA2417@srcf.ucam.org>
	<alpine.DEB.2.00.1008041207260.6545@asgard.lang.hm>
	<20100804192115.GA2946@srcf.ucam.org>
	<alpine.DEB.2.00.1008041222280.6545@asgard.lang.hm>
	<20100804195723.GA3553@srcf.ucam.org>
	<alpine.DEB.2.00.1008041508040.6545@asgard.lang.hm>
	<20100805133811.GA20565@srcf.ucam.org>
	<alpine.DEB.2.00.1008050724110.25170@asgard.lang.hm>
Date: Thu, 5 Aug 2010 08:15:35 -0700
Message-ID: <AANLkTinOkBvKKtrvb_ZYTPzAU9r24yXVPfcbSGqHUUji@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Brian Swetland <swetland@google.com>
To: david@lang.hm
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 7:34 AM,  <david@lang.hm> wrote:
>
> for example, if you want to abort the suspend because there is network
> activity, you can check the packet count of your network interface, decide
> to go to sleep, setup the network interface to raise a 'wake me up'
> interrupt (because you have decided in a userspace policy that you want
> this), and then check to see if the packet count has changed. If it has,
> abort the suspend, if not continue the suspend and once you are suspended if
> the 'wake me up' interrupt is set you will wake back up.
>
> there are probably cleaner/better ways of doing this than the simple logic
> that I'm listing, but why wouldn't the simple logic provide the correct
> result?

If your network interrupt happens before the network driver's
suspend() hook is called this works -- the check in the suspend hook
observes the change and returns an abort status.

If your network interrupt happens after the suspend() hook is called
this does not work -- the event comes after your opportunity to abort
suspend has happened, your interrupt handler processed it, set the
flag, but the system proceeds to suspend anyway, missing the event.

The wakelock/suspendblock mechanism avoids races like the above.

Brian
