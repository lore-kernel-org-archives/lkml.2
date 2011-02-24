Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1BXJQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:16:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36061 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab1BXJQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:16:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=MDC/X8CnjJIzp5n4rCphCNuE6wkOSQNeboo7BZHqrGmcXQL/MvalGZ3PQ1xiMrXqsp
         tbI2IArrNew0O4ZiHCysKogMFeYuP5us7bg47KJW+dv3ifEEe10YNpmcSKKWdp0v1H7j
         enNB+mwVy+e5v9XC/xoQZEgXlnGp7nEIozRxo=
Date: Thu, 24 Feb 2011 10:15:57 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: questions about init_memory_mapping_high()
Message-ID: <20110224091557.GD7840@htj.dyndns.org>
References: <20110223171945.GI26065@htj.dyndns.org>
 <4D656D1A.7030006@kernel.org>
 <20110223204656.GA27738@atj.dyndns.org>
 <4D657359.5060901@kernel.org>
 <20110223210326.GB27738@atj.dyndns.org>
 <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

On Wed, Feb 23, 2011 at 02:17:34PM -0800, Yinghai Lu wrote:
> > Hmmm... I'm not really following.  Can you elaborate?  The reason why
> > smaller mapping is bad is because of increased TLB pressure.  What
> > does using the existing entries have to do with it?
> 
> assume 1g page is used. first node will actually mapped 512G already.
> so if the system only have 1024g. then first 512g page table will on node0 ram.
> second 512g page table will be on node4.
> 
> when only 2M are used, it is 1G boundary. for 1024g system.
> page table (about 512k) for mem 0-128g is on node0.
> page table (about 512k) for mem 128g-256g is on node1.
> ...
> Do you mean we need to put those all 512k together to reduce TLB presure?

Nope, let's say the machine supports 1GiB mapping, has 8GiB of memory
where [0,4)GiB is node 0 and [4,8)GiB node1, and there's a hole of
128MiB right on top of 4GiB.  Before the change, the page mapping code
wouldn't care about the whole and just map the whole [0,8)GiB area
with eight 1GiB mapping.  Now with your change, [4, 5)GiB will be
mapped using 2MiB mappings to avoid mapping the 128MiB hole.

We end up unnecessarily using smaller size mappings (512 2MiB mappings
instead of 1 1GiB mapping) thus increasing TLB pressure.  There is no
reason to match the linear address mapping exactly to the physical
memory map.  It is no accident that the original code didn't consider
memory holes.  Using larger mappings over them is more beneficial to
trying to punch holes with smaller mappings.

This rather important change was made without any description or
explanation, which I find somewhat disturbing.  Anyways, what we can
do is just taking bottom and top addresses of occupied NUMA regions
and round them down and up, respectively, to the largest page mapping
size supported as long as the top address doesn't go over max_pfn
instead of mapping exactly according to the memblocks.

Thanks.

-- 
tejun
