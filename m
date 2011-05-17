Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1EQU61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:58:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43003 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab1EQU60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CwbvUmRFKfJgq/uZbf3qPur5vtcIvMW1y1I7i6NIn8LMVil2DVe0yPpJIhSw0+CoOh
         iZdo0o66ViYRMuzW22C18/6It/2BreHDzIUjhiHd3ppun/RAQIi8t8rtvmSfUHVQwshL
         XfxxuwDI9mBL5vz8J/coLvVDup3P7Fulttt/o=
Message-ID: <4DD2E16D.1030001@gmail.com>
Date: Tue, 17 May 2011 22:58:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] checkpatch.pl: Add check for task comm references
References: <1305665263-20933-1-git-send-email-john.stultz@linaro.org> <1305665263-20933-4-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1305665263-20933-4-git-send-email-john.stultz@linaro.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 10:47 PM, John Stultz wrote:
> Now that accessing current->comm needs to be protected,
> avoid new current->comm or other task->comm usage by adding
> a warning to checkpatch.pl.
> 
> Fair warning: I know zero perl, so this was written in the
> style of "monkey see, monkey do". It does appear to work
> in my testing though.
> 
> Thanks to Jiri Slaby, Michal Nazarewicz and Joe Perches
> for help improving the regex!
> 
> Close review and feedback would be appreciated.
> 
> CC: Joe Perches <joe@perches.com>
> CC: Michal Nazarewicz <mina86@mina86.com>
> CC: Andy Whitcroft <apw@canonical.com>
> CC: Jiri Slaby <jirislaby@gmail.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: David Rientjes <rientjes@google.com>
> CC: Dave Hansen <dave@linux.vnet.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-mm@kvack.org
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  scripts/checkpatch.pl |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d867081..a67ea69 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2868,6 +2868,13 @@ sub process {
>  			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
>  		}
>  
> +# check for current->comm usage
> +		our $common_comm_vars = qr{(?x:
> +		        current|tsk|p|task|curr|chip|t|object|me

Hrm, chip->comm looks like a total bullshit.
object->comm refers to kmemleak object, so this would trigger false
alarms too.

> +		)};
> +		if ($line =~ /\b($common_comm_vars)\s*->\s*comm\b/) {
> +			WARN("comm access needs to be protected. Use get_task_comm, or printk's \%ptc formatting.\n" . $herecurr);
> +		}
>  # check for %L{u,d,i} in strings
>  		my $string;
>  		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {

thanks,
-- 
js
