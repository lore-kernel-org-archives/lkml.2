Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab2GKOUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:20:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35429 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab2GKOUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:20:04 -0400
Message-ID: <4FFD8A8F.6030603@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2012 09:15:43 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] zsmalloc: add details to zs_map_object boiler plate
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <1341263752-10210-4-git-send-email-sjenning@linux.vnet.ibm.com> <4FFB94FF.8030401@kernel.org> <4FFC478C.4050505@linux.vnet.ibm.com> <4FFD2E65.5080307@kernel.org>
In-Reply-To: <4FFD2E65.5080307@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071114-1780-0000-0000-0000074E9E65
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000284; HX=3.00000191; KW=3.00000007;
 PH=3.00000001; SC=3.00000004; SDB=6.00155702; UDB=6.00035096; UTC=2012-07-11
 14:19:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 02:42 AM, Minchan Kim wrote:
> On 07/11/2012 12:17 AM, Seth Jennings wrote:
>> On 07/09/2012 09:35 PM, Minchan Kim wrote:
>>> Maybe we need local_irq_save/restore in zs_[un]map_object path.
>>
>> I'd rather not disable interrupts since that will create
>> unnecessary interrupt latency for all users, even if they
> 
> Agreed.
> Although we guide k[un]map atomic is so fast, it isn't necessary
> to force irq_[enable|disable]. Okay.
> 
>> don't need interrupt protection.  If a particular user uses
>> zs_map_object() in an interrupt path, it will be up to that
>> user to disable interrupts to ensure safety.
> 
> Nope. It shouldn't do that.
> Any user in interrupt context can't assume that there isn't any other user using per-cpu buffer
> right before interrupt happens.
> 
> The concern is that if such bug happens, it's very hard to find a bug.
> So, how about adding this?
> 
> void zs_map_object(...)
> {
> 	BUG_ON(in_interrupt());
> }

I not completely following you, but I think I'm following
enough.  Your point is that the per-cpu buffers are shared
by all zsmalloc users and one user doesn't know if another
user is doing a zs_map_object() in an interrupt path.

However, I think what you are suggesting is to disallow
mapping in interrupt context.  This is a problem for zcache
as it already does mapping in interrupt context, namely for
page decompression in the page fault handler.

What do you think about making the per-cpu buffers local to
each zsmalloc pool? That way each user has their own per-cpu
buffers and don't step on each other's toes.

Thanks,
Seth

