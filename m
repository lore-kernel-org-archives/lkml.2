Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab2IGHJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:09:35 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53341 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab2IGHJd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Fri, 7 Sep 2012 03:09:33 -0400
Message-Id: <5049BA020200007800099920@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 07 Sep 2012 08:10:26 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Alex Shi" <alex.shi@intel.com>
Cc: <jeremy.fitzhardinge@citrix.com>, <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>, <mingo@redhat.com>,
        <cpw@sgi.com>, <steiner@sgi.com>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH] UV: fix incorrect tlb flush all issue
References: <1345798655-3669-1-git-send-email-alex.shi@intel.com>
 <20120906161136.b15e3d91.akpm@linux-foundation.org>
 <50498806.4020701@intel.com>
In-Reply-To: <50498806.4020701@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.09.12 at 07:37, Alex Shi <alex.shi@intel.com> wrote:
> @@ -1113,7 +1114,10 @@ const struct cpumask *uv_flush_tlb_others(const struct 
> cpumask *cpumask,
>  
>  	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
>  
> -	bau_desc->payload.address = start;
> +	if (!end)

So despite having made a very similar mistake on the Xen side,
you're again not following your own code adjustments here:
The indicator for a multi-page flush is not 'end' being zero, nor
would it be okay to use the proper indicator (TLB_FLUSH_ALL)
here. Instead, to yield correct code, you need to check for the
range covering more than one page. Improvements to do finer
grained flushing (if worthwhile on UV) could then be done on
top of this.

Jan

> +		bau_desc->payload.address = TLB_FLUSH_ALL;
> +	else
> +		bau_desc->payload.address = start;
>  	bau_desc->payload.sending_cpu = cpu;
>  	/*
>  	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,


