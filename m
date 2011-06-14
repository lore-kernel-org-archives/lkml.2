Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1FNDFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 23:05:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59303 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1FNDE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 23:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nBWckc+YRyUfEX2ehtVGFoeswc9b7XT8gcWT51zDnBjjXUiG3mgmik/RLgJ4yDxZgz
         me/9sDbDGIr1LNIHmaXhhDuaHLIL8JjfGxbSyGYvXKpKIUd85eLG+XWZAKok4oBm/m4r
         wLnHxBJlP6kPFd7mj/aAjqoMFycgqzBKWMZ7Y=
MIME-Version: 1.0
In-Reply-To: <4DF6B8F6.2000902@jp.fujitsu.com>
References: <4df6892b12944b314b@agluck-desktop.sc.intel.com>
	<4DF6B8F6.2000902@jp.fujitsu.com>
Date: Mon, 13 Jun 2011 20:04:58 -0700
X-Google-Sender-Auth: Bbjr8IKGd_EzmuJX1kkPrZS3RKs
Message-ID: <BANLkTi=sLTFtVKdHryRiPvKfj1_Pzc3AEA@mail.gmail.com>
Subject: Re: [PATCH 09/10] MCE: run through processors with more severe
 problems first
From: Tony Luck <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/13 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> BTW in case of "no_way_out" events, we don't clear banks because they
> could be carried over to the next boot (expecting logged as bootlog).
> So we may need to have some trick for some known cases; e.g. ignore
> observed AR by bystanders, anyway.

Yes. The overall plan is that we should leave the machine check banks
alone for fatal errors (so that the BIOS, or next OS after the reset can
do something with them). Non-fatal errors can be handled, logged and
cleared.  But this leaves us in a pickle if we initially think we can handle
an error, and later decide that we can't.  Leaving errors for too long in
the machine check banks has its own problems too - overwrite rules
mean that two errors in the same bank which are each non-fatal, may
become a fatal error for the OS.

>> +     u64     mask = MCG_STATUS_MCIP;
>
> Why do you check the MCG_STATUS_MCIP too here?
> What happens if there is a problematic cpu that could not read
> MCG register properly so indicates "PANIC with !MCIP"?

You figured out the answer later - but perhaps I should have given better
clues in the comments. I think that the !MCIP panic is a "can't
happen" case.

>> +             cpu = cpumask_next(cpu, cpu_possible_mask);
>
> possible? online?

The old code has "for_each_possible_cpu" when scanning through
mces_seen - and I didn't want to change this functionality at this
point.

> Ah, I guess you assumed that all cpus checked in should have
> mces_seen with MCIP while offline cpus have cleaned mces_seen.
>
> Though we know there might be races with cpu hotplug, now we
> already use num_online_cpus() in this rendezvous mechanism,
> it is OK to use cpu_online_mask here at the moment, I think.
>
> Or we should invent new, better rendezvous mechanism...

Eventually we need something better. Currently we may do some
very strange things if someone has taken cpus offline (since they
will still arrive to rendezvous and we'll get more than num_online_cpus()
showing up.  Ditto if someone hot-added another cpu board but hasn't
yet brought the cpus online. Or if we booted with less than all cpus
by kernel command line argument. Etc.  Unfortunately I don't have
good ideas on how to do this better - ideally we'd have some very small
time interval in which to expect that cpus would arrive at the handler.
But the SDM gives no guidance on this.

-Tony
