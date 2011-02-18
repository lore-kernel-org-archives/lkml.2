Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab1BRJIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:08:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46446 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab1BRJII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:08:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wZ/0CU4/kWn/jQ7OXJT743MlITMdEU5XymWRcq5DwIffOtmSpmxSGq9EEmCYcC1r6n
         G5P+q+1XrUPSwCFQ8wkusLnMTq7SywBsWrgsezp6C+8YROYRUS7tBlkuSnYGmTFae7Am
         xcBzp5JqHXn2Q9Trsgs8hphh23e6EOzFcwWV0=
Date: Fri, 18 Feb 2011 10:07:25 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, mingo@redhat.com, johnstul@us.ibm.com, tglx@linutronix.de,
        richard.cochran@omicron.at
Subject: Re: [tip:timers/core] ntp: Add ADJ_SETOFFSET mode bit
Message-ID: <20110218090724.GA2924@riccoc20.at.omicron.at>
References: <20110201134320.688829863@linutronix.de>
 <tip-094aa1881fdc1b8889b442eb3511b31f3ec2b762@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-094aa1881fdc1b8889b442eb3511b31f3ec2b762@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just noticed a problem with this code. As is, the code will not
detect if the microseconds field (the non-ADJ_NANO case) is out of
range. However, the call to timekeeping_inject_offset() would silently
fail.

This patch corrects the problem by letting timekeeping_inject_offset()
do the check and catching the return code.

Author: Richard Cochran <richard.cochran@omicron.at>
Date:   Fri Feb 18 09:54:19 2011 +0100

    ntp: remove useless and incorrect parameter check
    
    The ADJ_SETOFFSET code redundantly checks the range of the nanoseconds
    field of the time value. This field is checked again in the subsequent
    call to timekeeping_inject_offset(). Also, as is, the check will not
    detect whether the number of microseconds is out of range.
    
    This patch simply lets timekeeping_inject_offset() do the error checking.
    
    Signed-off-by: Richard Cochran <richard.cochran@omicron.at>

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 34d1b64..d62f35a 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -648,13 +648,13 @@ int do_adjtimex(struct timex *txc)
 
 	if (txc->modes & ADJ_SETOFFSET) {
 		struct timespec delta;
-		if ((unsigned long)txc->time.tv_usec >= NSEC_PER_SEC)
-			return -EINVAL;
 		delta.tv_sec  = txc->time.tv_sec;
 		delta.tv_nsec = txc->time.tv_usec;
 		if (!(txc->modes & ADJ_NANO))
 			delta.tv_nsec *= 1000;
-		timekeeping_inject_offset(&delta);
+		result = timekeeping_inject_offset(&delta);
+		if (result)
+			return result;
 	}
 
 	getnstimeofday(&ts);
