Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab0ESORJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:17:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58495 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab0ESORF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:17:05 -0400
Message-ID: <4BF3F2DB.7030701@us.ibm.com>
Date: Wed, 19 May 2010 07:16:59 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Brian King <brking@linux.vnet.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, dvhltc@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Will Schmidt <will_schmidt@vnet.ibm.com>,
       niv@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       Doug Maxey <doug.maxey@us.ibm.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded (IRQF_NODELAY)
References: <4BF30793.5070300@us.ibm.com> <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com> <1274232324.29980.9.camel@concordia>
In-Reply-To: <1274232324.29980.9.camel@concordia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 06:25 PM, Michael Ellerman wrote:
> On Tue, 2010-05-18 at 15:22 -0700, Darren Hart wrote:
>> On 05/18/2010 02:52 PM, Brian King wrote:
>>> Is IRQF_NODELAY something specific to the RT kernel? I don't see it in mainline...
>>
>> Yes, it basically says "don't make this handler threaded".
>
> That is a good fix for EHEA, but the threaded handling is still broken
> for anything else that is edge triggered isn't it?

No, I don't believe so. Edge triggered interrupts that are reported as 
edge triggered interrupts will use the edge handler (which was the 
approach Sebastien took to make this work back in 2008). Since XICS 
presents all interrupts as Level Triggered, they use the fasteoi path.

>
> The result of the discussion about two years ago on this was that we
> needed a custom flow handler for XICS on RT.

I'm still not clear on why the ultimate solution wasn't to have XICS 
report edge triggered as edge triggered. Probably some complexity of the 
entire power stack that I am ignorant of.

> Apart from the issue of loosing interrupts there is also the fact that
> masking on the XICS requires an RTAS call which takes a global lock.

Right, one of may reasons why we felt this was the right fix. The other 
is that there is no real additional overhead in running this as 
non-threaded since the receive handler is so short (just napi_schedule()).

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
