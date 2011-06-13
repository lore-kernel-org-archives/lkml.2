Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1FMIAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 04:00:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab1FMIAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 04:00:10 -0400
Message-ID: <4DF5C36A.1040707@redhat.com>
Date: Mon, 13 Jun 2011 10:59:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>	<20110612223840.GA23218@aftab> <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
In-Reply-To: <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2011 08:31 AM, Tony Luck wrote:
> On Sun, Jun 12, 2011 at 3:38 PM, Borislav Petkov<bp@amd64.org>  wrote:
> >  On Thu, Jun 09, 2011 at 05:36:42PM -0400, Luck, Tony wrote:
> >>  From: Tony Luck<tony.luck@intel.com>
> >>
> >>  Existing user return notifier mechanism is designed to catch a specific
> >>  cpu just as it returns to run any task in user mode.  We also need a
> >>  mechanism to catch a specific task.
> >
> >  Why do we need that? I mean, in the remaining patches we end up either
> >  running memory_failure() or sending signals to a task. Can't we do it
> >  all in the user return notifier and not have a different notifier for
> >  each policy?
>
> Unless I'm mis-reading the user-return-notifier code, it is possible that
> we'll context switch before we get to the notifier. At that point the
> user-return-notifier TIF bit is passed on from our task to the newly
> run-able task. But our task is still viable, so another cpu could grab
> it and start running it ... then we have a race ... will the new task
> that inherited the notifier unmap the page fast enough, or will there
> be a loud BANG as the original task runs right into the machine
> check again.

Right.  user-return-notifiers are really a per-cpu notifier, unrelated 
to any specific task.  The use of per-task flags was an optimization.

If running into the MCE again is really bad, then you need something 
more, since other threads (or other processes) could run into the same 
page as well.  If not, do we care?  Let it hit the MCE again, as long as 
we'll catch it eventually.

-- 
error compiling committee.c: too many arguments to function

