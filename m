Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1EMFjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 01:39:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42017 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab1EMFjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 01:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E/rW+4CCVmxwXcYPHCXEjNy2VxpwWqT87jVz389TLgN6CAj/IC1SoJ/ehn6C45+waz
         TJIfka1YDAKP1gUnqkA7/YimilAOT3nYpmpyogn14NPcY9UjaABn0lc/t+tXtWpdIuLO
         FGgs4XJfyeSkSmCft54ehLG7MHJZ/w2591mz8=
MIME-Version: 1.0
In-Reply-To: <BANLkTikRFjGtBhnTBH_n=rDe+Y6kCjt30g@mail.gmail.com>
References: <1305127773-10570-4-git-send-email-mgorman@suse.de>
	<alpine.DEB.2.00.1105120942050.24560@router.home>
	<1305213359.2575.46.camel@mulgrave.site>
	<alpine.DEB.2.00.1105121024350.26013@router.home>
	<1305214993.2575.50.camel@mulgrave.site>
	<1305215742.27848.40.camel@jaguar>
	<1305225467.2575.66.camel@mulgrave.site>
	<1305229447.2575.71.camel@mulgrave.site>
	<1305230652.2575.72.camel@mulgrave.site>
	<1305237882.2575.100.camel@mulgrave.site>
	<20110512221506.GM16531@cmpxchg.org>
	<BANLkTikRFjGtBhnTBH_n=rDe+Y6kCjt30g@mail.gmail.com>
Date: Fri, 13 May 2011 14:39:03 +0900
Message-ID: <BANLkTimmn_PyU0xtfnG-CKxDxd1CTKx=Aw@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 7:58 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Fri, May 13, 2011 at 7:15 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> On Thu, May 12, 2011 at 05:04:41PM -0500, James Bottomley wrote:
>>> On Thu, 2011-05-12 at 15:04 -0500, James Bottomley wrote:
>>> > Confirmed, I'm afraid ... I can trigger the problem with all three
>>> > patches under PREEMPT.  It's not a hang this time, it's just kswapd
>>> > taking 100% system time on 1 CPU and it won't calm down after I unload
>>> > the system.
>>>
>>> Just on a "if you don't know what's wrong poke about and see" basis, I
>>> sliced out all the complex logic in sleeping_prematurely() and, as far
>>> as I can tell, it cures the problem behaviour.  I've loaded up the
>>> system, and taken the tar load generator through three runs without
>>> producing a spinning kswapd (this is PREEMPT).  I'll try with a
>>> non-PREEMPT kernel shortly.
>>>
>>> What this seems to say is that there's a problem with the complex logic
>>> in sleeping_prematurely().  I'm pretty sure hacking up
>>> sleeping_prematurely() just to dump all the calculations is the wrong
>>> thing to do, but perhaps someone can see what the right thing is ...
>>
>> I think I see the problem: the boolean logic of sleeping_prematurely()
>> is odd.  If it returns true, kswapd will keep running.  So if
>> pgdat_balanced() returns true, kswapd should go to sleep.
>>
>> This?
>
> Yes. Good catch.

In addition, I see some strange thing.
The comment in pgdat_balanced says
"Only zones that meet watermarks and are in a zone allowed by the
callers classzone_idx are added to balanced_pages"

It's true in case of balance_pgdat but it's not true in sleeping_prematurely.
This?

barrios@barrios-desktop:~/linux-mmotm$ git diff mm/vmscan.c
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 292582c..d9078cf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2322,7 +2322,8 @@ static bool sleeping_prematurely(pg_data_t
*pgdat, int order, long remaining,
                                                        classzone_idx, 0))
                        all_zones_ok = false;
                else
-                       balanced += zone->present_pages;
+                       if (i <= classzone_idx)
+                               balanced += zone->present_pages;
        }

        /*
@@ -2331,7 +2332,7 @@ static bool sleeping_prematurely(pg_data_t
*pgdat, int order, long remaining,
         * must be balanced
         */
        if (order)
-               return pgdat_balanced(pgdat, balanced, classzone_idx);
+               return !pgdat_balanced(pgdat, balanced, classzone_idx);
        else
                return !all_zones_ok;
 }





-- 
Kind regards,
Minchan Kim
