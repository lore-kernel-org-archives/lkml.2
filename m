Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab1CWVdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:33:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35122 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab1CWVdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:33:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mER2zmiOBPHwLqfZCy+j/1nMOaXYz2cbumjXuSIcXMSG5hktFBDk8VZzwmP9pN4z9a
         PkmSh52i+RT71IljgxZjXgID+Xgo3tG/Ww5UZjXTkY7BZB5PT6lecwLxXwZ7MsiHrpt4
         8HXrw/mcSLfdHub+L/w0DB/VNvWpnJbP1WtOQ=
Message-ID: <4D8A670E.6080706@openvz.org>
Date: Thu, 24 Mar 2011 00:33:02 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] kgdb, x86: Pull up NMI notifier handler priority
References: <4D8A58E1.5090509@openvz.org> <20110323211656.GA29184@redhat.com>
In-Reply-To: <20110323211656.GA29184@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 12:16 AM, Don Zickus wrote:
> On Wed, Mar 23, 2011 at 11:32:33PM +0300, Cyrill Gorcunov wrote:
>> kgdb needs IPI to be sent and handled before perf
>> or anything else NMI, otherwise kgdb hangs with bootup
>> self-tests (found on P4 HT SMP machine). Raise its priority
>> so that we're called first in a notifier chain.
> 
> This is only because P4 perf swallows all the nmis.  If that is the case
> you are arguing to make the perf nmi at the bottom of the priority list,
> which is probably not where it should be due to its volume.

The problem is that there IPI wait cycle inside kgdb and we are to be sure
to handle it early. And perf eventually can consume kgdb NMI which would
lead to infinite wait loop so I don't see any easier way to deal with it.

> 
> I am stuck debugging P4 problems again for RHEL-6 and I noticed a small
> change that is needed (didn't help my problem though) but it looked like
> an oversight that might help your case.
> 
> Cheers,
> Don
> 
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
> index 3769ac8..d945314 100644
> --- a/arch/x86/kernel/cpu/perf_event_p4.c
> +++ b/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -777,6 +787,7 @@ static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
>  	 * the counter has reached zero value and continued counting before
>  	 * real NMI signal was received:
>  	 */
> +	rdmsrl(hwc->event_base, v);
>  	if (!(v & ARCH_P4_UNFLAGGED_BIT))
>  		return 1;
>  

Good catch! Ack! It seems to be escaped in first place (I fear I forgot to
refresh patch before send it). Mind to send the full patch to Ingo?

-- 
    Cyrill
