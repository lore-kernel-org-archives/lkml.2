Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1LSOCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:02:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57179 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab1LSOCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:02:46 -0500
Date: Mon, 19 Dec 2011 15:00:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for 3.2
Message-ID: <20111219140049.GA9097@elte.hu>
References: <1324302373-30872-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324302373-30872-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull this one fix for 3.2.
> 
> Thanks,
> 
> -Robert
> 
> 
> 
> The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:
> 
>   Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Robert Richter (1):
>       oprofile: Fix uninitialized memory access when writing to oprofilefs
> 
>  arch/s390/oprofile/init.c         |    3 +++
>  drivers/oprofile/oprofile_files.c |    9 +++++++++
>  drivers/oprofile/oprofilefs.c     |   15 ++++++++++++++-
>  3 files changed, 26 insertions(+), 1 deletions(-)

Hm, i really don't like this:

+	if (!count)
+		return 0;
+
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
 	if (retval)
 		return retval;

+	if (!count)
+		return 0;
+
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
 	if (retval)
 		return retval;

+	if (!count)
+		return 0;
+
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
 	if (retval)
 		return retval;
 
+	if (!count)
+		return 0;
+
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
 	if (retval)
 		return retval;

+	if (!count)
+		return 0;
+
 	retval = oprofilefs_ulong_from_user(&value, buf, count);
 	if (retval)
 		return retval;

See the ugly and fragile pattern?

This should *really* be solved via the 
oprofilefs_ulong_from_user() helper function, not by sprinkling 
the !count checks in half a dozen places ...

Thanks,

	Ingo
