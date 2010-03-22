Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0CVVB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:01:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36347 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab0CVVB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:01:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 15551] New: wifi doesn't work after resume from s2ram on ThinkPad T61
Date: Mon, 22 Mar 2010 22:04:47 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       alex.vizor@gmail.com
References: <bug-15551-10286@http.bugzilla.kernel.org/> <20100322125656.24ce2c11.akpm@linux-foundation.org>
In-Reply-To: <20100322125656.24ce2c11.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003222204.47169.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010, Andrew Morton wrote:
> On Tue, 16 Mar 2010 22:03:53 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=15551
> 
> This'll be a post-2.6.33 regression.
> 
> >            Summary: wifi doesn't work after resume from s2ram on ThinkPad
> >                     T61
> >            Product: Networking
> >            Version: 2.5
> >     Kernel Version: 2.6.34-rc1
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Wireless
> >         AssignedTo: networking_wireless@kernel-bugs.osdl.org
> >         ReportedBy: alex.vizor@gmail.com
> >         Regression: Yes
> > 
> > 
> > Created an attachment (id=25561)
> >  --> (http://bugzilla.kernel.org/attachment.cgi?id=25561)
> > dmesg
> > 
> > Hi. I caught this after several resumes from s2ram, from s2disk it works ok.
> > 
> > I attached my dmesg. Please inform me if I can do the report more useful.
> > 
> 
> This:
> 
> : [22456.252166] s2ram: page allocation failure. order:4, mode:0x4010
> : [22456.252172] Pid: 23558, comm: s2ram Not tainted 2.6.34-rc1 #1
> : [22456.252175] Call Trace:
> : [22456.252187]  [<ffffffff810b8dc9>] __alloc_pages_nodemask+0x565/0x60c
> : [22456.252195]  [<ffffffff810de879>] alloc_pages_current+0x90/0x99
> : [22456.252201]  [<ffffffff810b7a9e>] __get_free_pages+0x9/0x46
> : [22456.252221]  [<ffffffffa03b4bdd>] iwl_tx_queue_init+0xf2/0x2a1 [iwlcore]
> : [22456.252227]  [<ffffffffa03b4f12>] iwl_txq_ctx_reset+0x186/0x20c [iwlcore]
> : [22456.252233]  [<ffffffffa03ae41c>] iwl_hw_nic_init+0x124/0x139 [iwlcore]
> 
> Rafael, this is fallout from 452aa6999e6703ffbddd7f6ea124d3968915f3e3
> ("mm/pm: force GFP_NOIO during suspend/hibernation and resume"). 
> Wireless was previously doing this stupidly-large allocation with
> GFP_KERNEL.  But I think the above change is what flipped it to
> __GFP_WAIT, which caused the page allocator to go into lame-and-sucky
> mode, so the allocation failed.

Well, technically the problem is in the driver.  It shouldn't do anything like
this during suspend/resume.  I'll try to figure out how to fix this at minimal cost.

> (btw, that was a bug - 452aa6999e6703ffbddd7f6ea124d3968915f3e3 should
> have cleared the __GFP_WAIT bit too).

Hmm, should it?  That would make all allocations GFP_ATOMIC and is this what
we really want?

Rafael
