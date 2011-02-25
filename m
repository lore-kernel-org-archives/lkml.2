Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab1BYBiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 20:38:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18735 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab1BYBiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 20:38:03 -0500
Message-ID: <4D6707E1.3060509@kernel.org>
Date: Thu, 24 Feb 2011 17:37:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: questions about init_memory_mapping_high()
References: <20110223171945.GI26065@htj.dyndns.org> <4D656D1A.7030006@kernel.org> <20110223204656.GA27738@atj.dyndns.org> <4D657359.5060901@kernel.org> <20110223210326.GB27738@atj.dyndns.org> <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com> <20110224091557.GD7840@htj.dyndns.org>
In-Reply-To: <20110224091557.GD7840@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D6707E8.00E9,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 01:15 AM, Tejun Heo wrote:
> Hey, again.
> 
> On Wed, Feb 23, 2011 at 02:17:34PM -0800, Yinghai Lu wrote:
>>> Hmmm... I'm not really following.  Can you elaborate?  The reason why
>>> smaller mapping is bad is because of increased TLB pressure.  What
>>> does using the existing entries have to do with it?
>>
>> assume 1g page is used. first node will actually mapped 512G already.
>> so if the system only have 1024g. then first 512g page table will on node0 ram.
>> second 512g page table will be on node4.
>>
>> when only 2M are used, it is 1G boundary. for 1024g system.
>> page table (about 512k) for mem 0-128g is on node0.
>> page table (about 512k) for mem 128g-256g is on node1.
>> ...
>> Do you mean we need to put those all 512k together to reduce TLB presure?
> 
> Nope, let's say the machine supports 1GiB mapping, has 8GiB of memory
> where [0,4)GiB is node 0 and [4,8)GiB node1, and there's a hole of
> 128MiB right on top of 4GiB.  Before the change, the page mapping code
> wouldn't care about the whole and just map the whole [0,8)GiB area
> with eight 1GiB mapping.  Now with your change, [4, 5)GiB will be
> mapped using 2MiB mappings to avoid mapping the 128MiB hole.
> 
> We end up unnecessarily using smaller size mappings (512 2MiB mappings
> instead of 1 1GiB mapping) thus increasing TLB pressure.  There is no
> reason to match the linear address mapping exactly to the physical
> memory map.  It is no accident that the original code didn't consider
> memory holes.  Using larger mappings over them is more beneficial to
> trying to punch holes with smaller mappings.
> 
> This rather important change was made without any description or
> explanation, which I find somewhat disturbing.  Anyways, what we can
> do is just taking bottom and top addresses of occupied NUMA regions
> and round them down and up, respectively, to the largest page mapping
> size supported as long as the top address doesn't go over max_pfn
> instead of mapping exactly according to the memblocks.
> 

ok, please check two patches that fix the problem.

thanks

Yinghai
