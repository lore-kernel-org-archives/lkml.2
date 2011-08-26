Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1HZV0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:26:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:27236 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab1HZV0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:26:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,287,1312182000"; 
   d="scan'208";a="45196508"
Subject: Re: MTRR setup failure on Fujitsu Lifebook S761
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Tony Vroon <tony@linx.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, yinghai@kernel.org
Date: Fri, 26 Aug 2011 14:29:17 -0700
In-Reply-To: <1314385315.8356.0.camel@localhost>
References: <4E579397.6010009@linx.net>  <4E57CBBB.3040806@zytor.com>
	 <1314385315.8356.0.camel@localhost>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1314394157.4729.23.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 12:01 -0700, Tony Vroon wrote:
> On Fri, 2011-08-26 at 09:37 -0700, H. Peter Anvin wrote:
> > Hm, I don't see any evidence of the MTRR sanitizer running at all...
> 
> It is almost as if it failed to find an optimal configuration; does that
> error path not print anything?

MTRR cleanup bails out in mtrr_need_cleanup() if it finds any entry
other than WB or UC. And the first entry you had was write-protect.

There are couple of issues.

a. mtrr_add_page() checks for the type mismatch between the new entry
and any existing entry. _ANY_ is wrong and we should have used
mtrr_type_lookup() in mtrr_add_page(). mtrr_type_lookup() will look at
all the existing MTRR entries and comeup with the right type for a given
range. We should use that instead.

b. And even after fixing 'a', your bios has already setup all the MTRR's
and there are no spare MTRR's available. So we should really sanitize to
makeup some space if we can.

BTW, before all this: you seem to be using PAT and we really shouldn't
depend on the MTRR configuration to get the write-combining behavior if
PAT is used.

And you seem to say, things were _little_ bit better by using a MTRR
script. What do you mean by _little_ ?

Do you still see the original issue of hangcheck timer elapsed and it is
just that the MTRR warning from drm driver disappeared with your MTRR
script?

thanks,
suresh

