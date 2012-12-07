Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2LGW7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:59:11 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:34731 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2LGW7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:59:09 -0500
Message-ID: <50C274B1.90408@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2012 14:58:57 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] Debugging: Keep track of page owners
References: <20121207212417.FAD8DAED@kernel.stglabs.ibm.com> <20121207142614.428b8a54.akpm@linux-foundation.org> <50C26FA7.9010000@linux.vnet.ibm.com> <20121207144428.98b3eaf4.akpm@linux-foundation.org>
In-Reply-To: <20121207144428.98b3eaf4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120722-4834-0000-0000-000001389840
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 02:44 PM, Andrew Morton wrote:
> AFACIT that difference was undescribed.  I can see that the new version
> uses the stack-tracing infrastructure, but the change to
> pagetypeinfo_showmixedcount_print() is a mystery.

Ahhh, I assume you're talking about this hunk:

>> @@ -976,10 +976,7 @@ static void pagetypeinfo_showmixedcount_print(struct seq_file *m,
>>  
>>                         pagetype = allocflags_to_migratetype(page->gfp_mask);
>>                         if (pagetype != mtype) {
>> -                               if (is_migrate_cma(pagetype))
>> -                                       count[MIGRATE_MOVABLE]++;
>> -                               else
>> -                                       count[mtype]++;
>> +                               count[mtype]++;
>>                                 break;
>>                         }

That was to fix the comment that Laura Abbott made about it miscounting
MIGRATE_CMA pages.

My patch-sending scripts were choking a bit on the text description in
your patch.  I'm using a long-ago-forked copy of your patch-utils and
the DESC/EDESC in the patch I imported is giving them fits when I send
via email and stripping large parts of the description.  I'm happy to
resend via email, too, but here, the raw patch (will the full description):

	https://www.sr71.net/~dave/linux/pageowner.patch

The important description that the scripts managed to strip out when
emailed was this:

Updated 12/4/2012 - should apply to 3.7 kernels.  I did a quick
sniff-test to make sure that this boots and produces some sane
output, but it's not been exhaustively tested.

 * Moved file over to debugfs (no reason to keep polluting /proc)
 * Now using generic stack tracking infrastructure
 * Added check for MIGRATE_CMA pages to explicitly count them
   as movable.

The new snprint_stack_trace() probably belongs in its own patch
if this were to get merged, but it won't kill anyone as it stands.

-----

