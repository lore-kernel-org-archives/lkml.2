Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1LVNtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 08:49:03 -0500
Received: from tango.0pointer.de ([85.214.72.216]:55286 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1LVNtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 08:49:00 -0500
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Dec 2011 08:48:59 EST
Date: Thu, 22 Dec 2011 14:40:17 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Brian Swetland <swetland@google.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        Tim Bird <tim.bird@am.sony.com>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: RFC: android logger feedback request
Message-ID: <20111222134017.GC7512@tango.0pointer.de>
References: <4EF264C3.6000104@am.sony.com>
 <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com>
 <20111222005114.GA22541@suse.de>
 <4EF288B4.1070601@am.sony.com>
 <20111222014718.GA13085@suse.de>
 <4EF29217.7040408@am.sony.com>
 <20111222034717.GB14174@suse.de>
 <CAPXgP10ikqHFn41wc1HPsKHyaC7fe1WGC2eHqs-hdRaZ7XCTLw@mail.gmail.com>
 <CANqkERCcciVxybh=66K5xxzzGmgw=fg0vwmcitWZ1y=DTxxtOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqkERCcciVxybh=66K5xxzzGmgw=fg0vwmcitWZ1y=DTxxtOA@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21.12.11 20:22, Brian Swetland (swetland@google.com) wrote:

> > If we want to think about any next generation logging, I'm convinced,
> > we need to support records, structured data and binary data; anything
> > else is unlikely worth to change the current stuff.
> 
> Any thoughts as to how one could allow N userspace agents to log to a
> single shared buffer without one agent, if buggy or malicious,
> spamming out all the other contents of the log?  This is one of the
> main reasons we maintain separate logs in Android today, and are
> likely to continue doing so until we figure out how resolve the issue.

I have been working on some code to rate limit what clients can log to
the journal, with some nice tricks: the rate limiting is per-cgroup, so
that services can't flush out other services data so easily (assuming
they are in separate cgroups, which they are in a systemd world). Also,
different rates apply to to messages with different priorities
(i.e. we'll have a lower limit on debug messages, and allow more
important messages to be logged at a higher rate). And finally, we look
at the available disk space: the overall rate limits are increased if
there's more free space, and lowered if there's less.

> Also, as I mentioned earlier, from a security standpoint it is highly
> desirable to be able to restrict which records certain readers can
> read.  Convincing third party app developers to not log sensitive or
> PII data remains a challenge -- providing the ability for filtered
> read access allows some mitigation (app can retrieve it's own logs for
> a bug report but can't sift through all logs looking for interesting
> tidbits).

The journal splits up user data into sparate files and sets file access
permissions to ensure that users can access their own data but nothing
else. However, when root wants to read all data it can, and the data
will be interleaved automatically.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
